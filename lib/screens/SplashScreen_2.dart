import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'on_boarding_screen.dart';

class Splashscreen2 extends StatefulWidget {
  const Splashscreen2({super.key});

  @override
  State<Splashscreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<Splashscreen2> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<Offset> _logoOffset;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;

  late AnimationController _textController;

  final String fullText = "Planto";
  int currentLength = 0;

  bool showText = false;

  @override
  void initState() {
    super.initState();

    // logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoOffset = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    ));

    _logoScale = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    _logoController.forward();

    // delay a bit before starting text animation
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        showText = true;
      });

      _textController.forward();
    });

    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: fullText.length * 150),
    )..addListener(() {
      setState(() {
        currentLength = (fullText.length * _textController.value).round();
      });
    });

    // Navigate to onboarding screen
    Future.delayed(const Duration(milliseconds: 3000), () {
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
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Image.asset(
                    'assets/icon/logo.png',
                    width: 180,
                    height: 180,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: showText ? 1 : 0,
              duration: const Duration(milliseconds: 600),
              child: Text(
                visibleText,
                style: GoogleFonts.aclonica(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
