import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_1/pref/mode_them.dart';
import 'package:test_1/providers/bottom_nav_provider.dart';
import 'package:test_1/providers/mode_provider.dart';
import 'package:test_1/providers/plant_selection_provider.dart';
import 'package:test_1/providers/tip_provider.dart';

import 'screens/SplashScreen_2.dart';
import 'common/global_context.dart';
import 'providers/disease_provider.dart';

import 'dart:developer' as developer;
import 'utils/TfliteModel.dart';

// استيرادات إضافية ضرورية
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Color(0xffedf3fa)),
  );

  try {
    // تحميل الصورة كبايتات من الأصول
    final ByteData data = await rootBundle.load("assets/image/Tomato leaf mold.jpeg");
    final Uint8List tomatoImageBytes = data.buffer.asUint8List();
    // تمرير البايتات إلى runModelTest
    await runModelTest("Tomato", tomatoImageBytes);
  } catch (e) {
    // تسجيل أي أخطاء تحدث أثناء تحميل وتشغيل النموذج التجريبي
    developer.log("Error loading initial image for runModelTest: $e");
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DiseaseProvider()),
    ChangeNotifierProvider(create: (_) => BottomNavProvider()),
    ChangeNotifierProvider(create: (_) => PlantSelectionProvider()),
    ChangeNotifierProvider(create: (_) => TipProvider()),
    ChangeNotifierProvider(create: (_) => ModeProvider()..getTheme()),
  ],child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<ModeProvider>(context).darkModeEnable ? ModeTheme.darkTheme : ModeTheme.lightMode,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Splashscreen2(),
    );
  }
}