
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_project/providers/bottom_nav_provider.dart';
import 'package:test_project/providers/plant_selection_provider.dart';
import 'package:test_project/providers/tip_provider.dart';

import 'screens/SplashScreen_2.dart';
import 'common/global_context.dart';
import 'providers/disease_provider.dart';

import 'dart:developer' as developer;
import 'utils/TfliteModel.dart';
import 'package:flutter/services.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Color(0xffedf3fa)),
  );
  await runModelTest("Tomato", "assets/image/Tomato leaf mold.jpeg");
  await Future.delayed(Duration(seconds: 60));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DiseaseProvider()),
          ChangeNotifierProvider(create: (_) => BottomNavProvider()), // أضفنا هذا السطر
          ChangeNotifierProvider(create: (_) => PlantSelectionProvider()),
          ChangeNotifierProvider(create: (_) => TipProvider()),

        ],      child:  MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.light,
      // theme: ThemeData(
      //   scaffoldBackgroundColor: const Color(0xffedf3fa),
      //   primaryColor: const Color(0xff112a42),
      //   iconTheme: const IconThemeData(color: Color(0xff112a42)),
      //   textTheme: GoogleFonts.notoSansTextTheme().apply(
      //     bodyColor: const Color(0xff112a42),
      //     displayColor: const Color(0xff112a42),
      //   ),
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.white,
      //       foregroundColor: const Color(0xff112a42),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(15),
      //       ),
      //       elevation: 4,
      //     ),
      //   ),
      // ),

      home: Splashscreen2(),
      // home: const MainScreen(),
    )

    );
  }
}
Future<void> runModelTest(String modelName, String imagePath) async {
  final modelManager = ModelManager();

  if (!modelManager.modelPaths.containsKey(modelName)) {
    developer.log("Model '$modelName' not found.");
    return;
  }


  final ByteData data = await rootBundle.load(imagePath);
  final Uint8List bytes = data.buffer.asUint8List();

  final output = await modelManager.classifyImage(modelName, bytes);

  if (output == null) {
    developer.log("Model inference failed.");
    return;
  }

  final labels = modelManager.plantClassLabels[modelName]!;
  final result = {
    for (int i = 0; i < labels.length; i++) labels[i]: output[i],
  };


  final sorted = result.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  print("About to log top result");
  final topResult = sorted.first;
  print("${topResult.key} (${(topResult.value * 100).toStringAsFixed(2)}%)");
  print("Logged top result");
}
