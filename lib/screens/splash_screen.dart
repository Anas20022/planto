import 'package:flutter/material.dart';
import '../main_screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full background image
          Image.asset(
            'assets/image/image_splash.jpg',
            fit: BoxFit.cover,
          ),

          // Bottom curved shape (¼ of screen height)
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: TopCurveClipper(), // custom curve upwards
              child: Container(
                padding: EdgeInsets.only(top: 100),
                height: height * 0.50,
                width: MediaQuery.sizeOf(context).width,
                color: const Color(0xFF1B3A24),
                child: Column(

                  children: [
                    const Text(
                      'Plant a tree &\nsave our planet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Plant a tree and help us to\ncure our planet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF62E145),
                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Plant a tree',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 50); // ابدأ من اليسار بنقطة مرتفعة قليلاً

    path.quadraticBezierTo(
      size.width * 0.25, 0, // من اليسار إلى الربع
      size.width * .4, 30, // نزول للنص (أخفض نقطة)
    );

    path.quadraticBezierTo(
      size.width * 0.8, 100, // من النص إلى ثلاثة أرباع (يرتفع شوي)
      size.width, 0, // نهاية عند اليمين مرتفعة
    );

    path.lineTo(size.width, size.height); // يمين تحت
    path.lineTo(0, size.height); // يسار تحت
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
