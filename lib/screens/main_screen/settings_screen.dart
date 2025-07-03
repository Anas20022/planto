import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/mode_provider.dart';

import '../../providers/local_provider.dart';
import '../feedback_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final languages = [
    {'name': 'English', 'locale': const Locale('en')},
    {'name': 'العربية', 'locale': const Locale('ar')},
  ];

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr()),
        backgroundColor: const Color(0xFF508776),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'General'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text('Dark Mode'.tr()),
            trailing: Switch(
              value: Provider.of<ModeProvider>(context, listen: false).darkModeEnable,
              onChanged: (value) {
                Provider.of<ModeProvider>(context, listen: false).changeMode();
                log("dark mode");
                setState(() {});
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('Language'.tr()),
            trailing: SizedBox(
              width: 120,  // عرض معقول

              child: DropdownButtonFormField<Locale>(
                value: localeProvider.locale,
                icon: const Icon(Icons.arrow_drop_down),
                decoration: InputDecoration(
                  isDense: true,  // لتقليل ارتفاع الحقل
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF508776), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Color(0xFF508776), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: languages.map((lang) {
                  return DropdownMenuItem<Locale>(
                    value: lang['locale'] as Locale,
                    child: Text(lang['name'] as String ,style: const TextStyle(color: Color(0xFF508776)),),
                  );
                }).toList(),
                onChanged: (Locale? selectedLocale) {
                  if (selectedLocale != null) {
                    localeProvider.setLocale(selectedLocale);
                    context.setLocale(selectedLocale);
                  }
                },
              ),
            ),


          ),
          const Divider(),
          const SizedBox(height: 20),
          Text(
            'Support'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: Text('Contact Us'.tr()),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // هنا يمكن إضافة الإجراء المطلوب عند الضغط
            },
          ),
          const Divider(),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FeedbackFormPage(),
                ),
              );
            },
            child: ListTile(
              leading: const Icon(Icons.feedback_outlined),
              title: Text('Send Feedback'.tr()),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}
