import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xFFE0E0E0), // لون الحقول في الوضع الفاتح
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xFF424242), // لون الحقول في الوضع الداكن
        ),
      ),
      themeMode: ThemeMode.system, // يتبع إعدادات الجهاز
      home: const FeedbackFormPage(),
    ),
  );
}

class FeedbackFormPage extends StatelessWidget {
  const FeedbackFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: const Color(0xFF2E7D6D),
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  'FEEDBACK FORM',
                  style: TextStyle(
                    fontSize: 24,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildInputField(
              icon: Icons.person,
              hintText: 'Name',
              context: context,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              icon: Icons.email,
              hintText: 'mail Id',
              context: context,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              icon: Icons.phone,
              hintText: 'Mobile Number',
              context: context,
            ),
            const SizedBox(height: 16),

            // حقل Your feedback
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple),
              ),
              height: 150,
              child: TextField(
                maxLines: null,
                style: TextStyle(color: textColor),
                decoration: InputDecoration.collapsed(
                  hintText: 'Your feedback',
                  hintStyle: TextStyle(color: textColor?.withOpacity(0.6)),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // زر الإرسال
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D6D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hintText,
    required BuildContext context,
    double height = 50,
  }) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: TextField(
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            icon: Icon(icon, color: textColor),
            hintText: hintText,
            hintStyle: TextStyle(color: textColor?.withOpacity(0.6)),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
