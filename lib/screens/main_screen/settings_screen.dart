import 'package:flutter/material.dart';

import '../feedback_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF508776),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'General',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
            onTap: () {
              // هنا تضيف تفعيل الدارك مود لاحقًا
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // تفتح صفحة اختيار اللغة
            },
          ),
          const Divider(),
          const SizedBox(height: 20),
          const Text(
            'Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Contact Us'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // تفتح صفحة تواصل معنا
            },
          ),
          const Divider(),
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const   FeedbackScreen(),
                ),
              );
            },
            child: ListTile(
              leading: const Icon(Icons.feedback_outlined),
              title: const Text('Send Feedback'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // تفتح صفحة الفيدباك إذا بدك
              },
            ),
          ),
        ],
      ),
    );
  }
}
