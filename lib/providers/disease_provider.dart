import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../model/fetch_fertilizer_model.dart';
import '../model/model_result.dart';
import 'disease_details.dart';
import '../utils/TfliteModel.dart';

class DiseaseProvider with ChangeNotifier {
  bool _offline = false;
  List<Map<String, dynamic>>? _archivedResults;
  List<Map<String, dynamic>>? get archivedResults => _archivedResults;
  bool get offline => _offline;

  Future<void> loadArchivedResults() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> rawList = prefs.getStringList('archived_results') ?? [];

    _archivedResults = rawList
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();

    notifyListeners();
  }

  Future<Map<String, dynamic>> loadDiseaseData(String diseaseName) async {
    final String jsonString = await rootBundle.loadString('assets/diseases_data.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    if (jsonMap.containsKey(diseaseName)) {
      return jsonMap[diseaseName];
    } else {
      throw Exception("Disease not found in JSON: $diseaseName");
    }
  }

  Future<void> deleteArchivedResult(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> results = prefs.getStringList('archived_results') ?? [];

    if (index >= 0 && index < results.length) {
      results.removeAt(index);
      await prefs.setStringList('archived_results', results);
      await loadArchivedResults();
    }
  }

  Future<void> saveLastAnalysisResult(String plantName, String diseaseName, double accuracy) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> lastResult = {
      'plantName': plantName,
      'diseaseName': diseaseName,
      'accuracy': accuracy,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString('lastAnalysisResult', jsonEncode(lastResult));
    print("Last analysis result saved: $lastResult");
  }


  Future<Map<String, dynamic>?> getLastAnalysisResult() async {
    final prefs = await SharedPreferences.getInstance();
    final String? resultString = prefs.getString('lastAnalysisResult');
    if (resultString != null) {
      return jsonDecode(resultString);
    }
    return null;
  }

  Future<bool> saveArchivedAnalysisResult(String plantName, String diseaseName, double accuracy) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> archivedList = prefs.getStringList('archived_results') ?? [];

    final alreadyExists = archivedList.any((entry) {
      final data = jsonDecode(entry);
      return data['plantName'] == plantName &&
          data['diseaseName'] == diseaseName &&
          (data['accuracy'] as double).toStringAsFixed(4) == accuracy.toStringAsFixed(4); // نطابق النسبة بدقة
    });

    if (alreadyExists) {
      return false; // لم نحفظ لأنها موجودة
    }

    final Map<String, dynamic> newResult = {
      'plantName': plantName,
      'diseaseName': diseaseName,
      'accuracy': accuracy,
      'timestamp': DateTime.now().toIso8601String(),
    };

    archivedList.add(jsonEncode(newResult));
    await prefs.setStringList('archived_results', archivedList);
    await loadArchivedResults();
    notifyListeners();
    return true; // تم الحفظ
  }



  Future<List<Map<String, dynamic>>> getArchivedAnalysisResult() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> archivedList = prefs.getStringList('archivedResults') ?? [];

    return archivedList.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<DiseaseDetails> detectDisease(String plantName, Uint8List imageBytes) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    print("Connectivity result: $connectivityResult");

    final allFertilizers = await Fertilizer.getFertilizers();
    allFertilizers.shuffle(Random());
    final randomSuggestions = allFertilizers.take(4).toList();

    if (connectivityResult == ConnectivityResult.none) {
      _offline = true;
      notifyListeners();

      print("No internet connection. Returning the last saved analysis result.");
      final lastResult = await getLastAnalysisResult();
      if (lastResult != null) {
        return DiseaseDetails(
          accuracy: lastResult['accuracy'] ?? 0.0, // ✅ أضفناها هنا

          plantName: lastResult['plantName'],
          diseaseName: lastResult['diseaseName'],
          remedies: ["علاج الأوفلاين: راجع النصائح المحفوظة.", "علاج الأوفلاين: تأكد من أن نبتتك لا تزال موجودة."],
          prevention: ["وقاية الأوفلاين: استشر خبيرًا عندما يتوفر الاتصال."],
          suggestions: randomSuggestions, fertilizer: {},
        );
      } else {
        print("No internet and no previous analysis saved. Throwing error.");
        throw Exception("لا يوجد اتصال بالإنترنت ولا توجد نتائج تحليل سابقة محفوظة.");
      }
    } else {
      _offline = false;
      notifyListeners();

      print("Internet connection detected. Running local TFLite model.");

      try {
        ModelResult? result = await runModelTest(plantName, imageBytes);
        if (result == null) {
          throw Exception("فشل في التحليل، النموذج لم يرجع نتيجة.");
        }

        final String detectedDiseaseName = result.label;
        final double confidence = result.confidence;

        // 👇 إذا النتيجة أقل من العتبة => Unknown => نرجع ونوقف كل شيء
        if (confidence < 0.70) {
          await saveLastAnalysisResult(plantName, "Unknown", confidence);

          print("⚠️ Low confidence (${confidence.toStringAsFixed(2)}), returning Unknown early.");

          return DiseaseDetails(
            plantName: plantName,
            diseaseName: "Unknown",
            accuracy: confidence,
            remedies: [],
            prevention: [],
            suggestions: [],
            fertilizer: {},
            link: null,
          );
        }

        // ✅ إذا النتيجة Healthy
        if (detectedDiseaseName == "Healthy") {
          await saveLastAnalysisResult(plantName, "Healthy", confidence);

          return DiseaseDetails(
            plantName: plantName,
            diseaseName: "Healthy",
            accuracy: confidence,
            remedies: [],
            prevention: [],
            suggestions: randomSuggestions,
            fertilizer: {},
          );
        }

        // 👉 إلى هنا واصل فقط إن كانت النتيجة حقيقية مع دقة جيدة
        await saveLastAnalysisResult(plantName, detectedDiseaseName, confidence);

        final diseaseInfo = await loadDiseaseData(detectedDiseaseName); // <<<<<< هذا السطر ما يشتغل إلا لما نكون متأكدين

        return DiseaseDetails(
          plantName: plantName,
          diseaseName: detectedDiseaseName,
          accuracy: confidence,
          remedies: List<String>.from(diseaseInfo['remedies'] ?? []),
          prevention: List<String>.from(diseaseInfo['prevention'] ?? []),
          suggestions: randomSuggestions,
          fertilizer: {},
        );
      }
      catch (e) {
        print("Error running local TFLite model: $e");
        throw Exception("حدث خطأ أثناء تشغيل النموذج المحلي: ${e.toString()}");
      }
    }
  }
}
