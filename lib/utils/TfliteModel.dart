import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:developer' as developer;

import '../model/model_result.dart';


class TfliteModel {
  late Interpreter _interpreter;
  final String modelName;
  final String modelPath;
  final List<String> classLabels;

  TfliteModel({
    required this.modelName,
    required this.modelPath,
    required this.classLabels,
  });

  // Updated to handle the model loading process with error logging
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      print("Model loaded successfully.");
    } catch (e) {
      print("Error loading model: $e");
      rethrow;  // Rethrow the error to propagate it
    }
  }

  // Preprocess the image: resize and normalize to float32 [0.0, 1.0]
  List<List<List<List<double>>>> preprocessImage(Uint8List inputData) {
    img.Image? image = img.decodeImage(inputData);
    if (image == null) throw Exception("Image decoding failed");

    img.Image resized = img.copyResize(image, width: 150, height: 150);

    List<List<List<List<double>>>> input = List.generate(
      1,
          (_) => List.generate(150, (y) => List.generate(150, (x) {
        final pixel = resized.getPixel(x, y);
        return [
          img.getRed(pixel) / 255.0,
          img.getGreen(pixel) / 255.0,
          img.getBlue(pixel) / 255.0
        ];
      })),
    );

    return input;
  }

  // Updated to check if the interpreter is initialized before running the model
  Future<List?> runModelOnImage(Uint8List inputData) async {
    if (_interpreter == null) {
      print("Interpreter is not initialized.");
      return null;  // Return null if the interpreter is not initialized
    }

    var output = List.filled(classLabels.length, 0.0).reshape([1, classLabels.length]);

    try {
      var input = preprocessImage(inputData);
      _interpreter.run(input, output);
    } catch (e) {
      print("Error running model: $e");
      return null;
    }

    return output[0]; // Return the class probability list
  }

  // Dispose method to release resources
  void dispose() {
    _interpreter.close();
    print("Interpreter disposed.");
  }
}

class ModelManager {
  final Map<String, String> modelPaths = {
    "Apple": "assets/models/Apple_model.tflite",
    "Cherry": "assets/models/Cherry_model.tflite",
    "Corn": "assets/models/Corn_model.tflite",
    "Grape": "assets/models/Grape_model.tflite",
    "Peach": "assets/models/Peach_model.tflite",
    "Pepper_bell": "assets/models/Pepper_bell_model.tflite",
    "Potato": "assets/models/Potato_model.tflite",
    "Strawberry": "assets/models/Strawberry_model.tflite",
    "Tomato": "assets/models/Tomato_model.tflite",
  };

  final Map<String, List<String>> plantClassLabels = {
    "Apple": ["Apple Scab", "Apple Black Rot", "Cedar Apple Rust", "Healthy"],
    "Cherry": ["Cherry Powdery Mildew", "Healthy"],
    "Corn": ["Corn Cercospora Leaf Spot", "Corn Common Rust", "Corn Northern Leaf Blight", "Healthy"],
    "Grape": ["Grape Black Rot", "Grape Black Measles", "Grape Isariopsis Leaf Spot", "Healthy"],
    "Peach": ["Peach Bacterial Spot", "Healthy"],
    "Pepper_bell": ["Pepper Bell Bacterial Spot", "Healthy"],
    "Potato": ["Potato Early Blight", "Potato Late Blight", "Healthy"],
    "Strawberry": ["Strawberry Leaf Scorch", "Healthy"],
    "Tomato": ["Tomato Bacterial Spot", "Tomato Early Blight", "Tomato Late Blight", "Tomato Leaf Mold",
      "Tomato Septoria Leaf Spot", "Tomato Spider Mites", "Tomato Target Spot",
      "Tomato Yellow Leaf Curl Virus", "Tomato Mosaic Virus", "Healthy"],
  };

  TfliteModel? _currentModel;

  // Updated method to handle loading and classification
  Future<List?> classifyImage(String modelName, Uint8List inputData) async {
    if (_currentModel != null) {
      _currentModel!.dispose();  // Ensure previous model is disposed of before loading new one
    }

    if (!modelPaths.containsKey(modelName)) {
      throw Exception("Model $modelName not found.");
    }

    _currentModel = TfliteModel(
      modelName: modelName,
      modelPath: modelPaths[modelName]!,
      classLabels: plantClassLabels[modelName]!,
    );

    // Load the model and handle errors
    await _currentModel!.loadModel();

    // Run the model on the image and return the output
    return await _currentModel!.runModelOnImage(inputData);
  }
}


// Run the model and return the top result as a readable string
// في ملف: utils/TfliteModel.dart

// ... (باقي الكود) ...

// Run the model and return the top result as a readable string
Future<ModelResult?> runModelTest(String modelName, Uint8List imageBytes) async {
  final modelManager = ModelManager();

  if (!modelManager.modelPaths.containsKey(modelName)) {
    developer.log("Model '$modelName' not found.");
    return null;
  }

  final output = await modelManager.classifyImage(modelName, imageBytes);

  if (output == null) {
    developer.log("Model inference failed.");
    return null;
  }

  final labels = modelManager.plantClassLabels[modelName]!;
  final result = {
    for (int i = 0; i < labels.length; i++) labels[i]: output[i],
  };

  final sorted = result.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  if (sorted.isEmpty) {
    developer.log("No classes detected for model '$modelName'.");
    return null;
  }

  final topResult = sorted.first;

  print("About to log top result from TFLiteModel:");
  print("${topResult.key} (${(topResult.value * 100).toStringAsFixed(2)}%)");

  return ModelResult(topResult.key, topResult.value);
}
