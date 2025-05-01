
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_project/providers/bottom_nav_provider.dart';
import 'package:test_project/main_screens.dart';
import 'package:test_project/providers/plant_selection_provider.dart';
import 'package:test_project/providers/tip_provider.dart';
import 'package:test_project/screens/splash_screen.dart';

import 'screens/SplashScreen_2.dart';
import 'common/global_context.dart';
import 'providers/disease_provider.dart';
import 'screens/main_screen/home_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Color(0xffedf3fa)),
  );
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
