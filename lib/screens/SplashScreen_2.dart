import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_project/screens/on_boarding_screen.dart';

class Splashscreen2 extends StatefulWidget {
  const Splashscreen2({super.key});

  @override
  State<Splashscreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<Splashscreen2> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<Offset> _logoOffset;
  late Animation<double> _logoOpacity;

  late AnimationController _textController;

  final String fullText = "Planto";
  int currentLength = 0;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoOffset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    ));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    ));

    _logoController.forward();

    // Text typing animation
    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: fullText.length * 100),
    )..addListener(() {
      setState(() {
        currentLength = (fullText.length * _textController.value).round();
      });
    });

    _textController.forward();

    // Navigate to onboarding screen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String visibleText = fullText.substring(0, currentLength);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _logoOffset,
              child: FadeTransition(
                opacity: _logoOpacity,
                child: Image.asset(
                  'assets/icon/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              visibleText,
              style: GoogleFonts.aclonica(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color:Color(0xFF438853) ,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
