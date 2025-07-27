import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  // فتح الرابط
  Future<void> _launchUrl(String url) async {
    final Uri uri;
    if (url == "aalamrin@students.iugaza.edu.ps"&&false){
      uri = Uri(
        scheme: 'mailto',
        path: url,
      );
    }else {
      uri = Uri.parse(url);
    }
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget buildContactButton({
    required IconData icon,
    required String labelKey,
    required String subtitleKey,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDark
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ]
                : null,
          ),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: isDark ? const Color(0xFF3E3E55) : Colors.black,
                child: Icon(icon, color: isDark ? const Color(0xFFB0B0C3) : Colors.white),
              ),
              const SizedBox(height: 10),
              Text(labelKey.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFD1D1E9) : Colors.black,
                  )),
              Text(subtitleKey.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF9A9AC9) : Colors.grey,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSocialCard({
    required IconData icon,
    required String titleKey,
    required String subtitleKey,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A40) : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ]
              : null,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isDark ? const Color(0xFF3E3E55) : Colors.black,
              child: Icon(icon, color: isDark ? const Color(0xFFB0B0C3) : Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titleKey.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFD1D1E9) : Colors.black,
                      )),
                  Text(subtitleKey.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF9A9AC9) : Colors.grey,
                      )),
                ],
              ),
            ),
            Icon(Icons.share_outlined,
                color: isDark ? const Color(0xFFB0B0C3) : Colors.black),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor =
    isDark ? const Color(0xFF121226) : const Color(0xFFCFFAD3);


    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: BackButton(color: isDark ? const Color(0xFFD1D1E9) : Colors.black),
        title: Text("contact_us".tr(),
            style: TextStyle(color: isDark ? const Color(0xFFD1D1E9) : Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Text(
              "contact_us_description".tr(),
              style: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFFB0B0C3) : Colors.black87),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                buildContactButton(
                  icon: Icons.call,
                  labelKey: "call_us",
                  subtitleKey: "working_hours",
                  onTap: () => _launchUrl("tel:+972567070887"),
                  context: context,
                ),
                buildContactButton(
                  icon: Icons.email,
                  labelKey: "email_us",
                  subtitleKey: "working_hours",
                  onTap: () => _launchUrl("mailto:aalamrin@students.iugaza.edu.ps"),
                  context: context,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text("social_media".tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFD1D1E9) : Colors.black,
                )),
            const SizedBox(height: 12),
            buildSocialCard(
              icon: FontAwesomeIcons.instagram,
              titleKey: "instagram",
              subtitleKey: "instagram_desc",
              onTap: () => _launchUrl("https://www.instagram.com/houseplusplant/?hl=ar"),
              context: context,
            ),
            buildSocialCard(
              icon: FontAwesomeIcons.telegram,
              titleKey: "telegram",
              subtitleKey: "telegram_desc",
              onTap: () => _launchUrl("https://t.me/abood_3am"),
              context: context,
            ),
            buildSocialCard(
              icon: FontAwesomeIcons.facebook,
              titleKey: "facebook",
              subtitleKey: "facebook_desc",
              onTap: () => _launchUrl("https://www.facebook.com/bdallhahmd.850998"),
              context: context,
            ),
            buildSocialCard(
              icon: FontAwesomeIcons.whatsapp,
              titleKey: "whatsapp",
              subtitleKey: "working_hours",
              onTap: () => _launchUrl("https://wa.me/+201070831238"),
              context: context,
            ),
            buildSocialCard(
              icon: FontAwesomeIcons.youtube,
              titleKey: "youtube",
              subtitleKey: "youtube_desc",
              onTap: () => _launchUrl("https://www.youtube.com/@DrPlantsss"),
              context: context,
            ),
            buildSocialCard(
              icon: Icons.location_on,
              titleKey: "location",
              subtitleKey: "location_desc",
              onTap: () => _launchUrl(
                  "https://www.google.com/maps?q=Gaza+Palestine+"),
              context: context,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:easy_localization/easy_localization.dart';
//
// class ContactUsScreen extends StatelessWidget {
//   const ContactUsScreen({super.key});
//
//   // فتح الرابط
//   Future<void> _launchUrl(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       throw Exception('Could not launch $url');
//     }
//   }
//
//   Widget buildContactButton({
//     required IconData icon,
//     required String labelKey,
//     required String subtitleKey,
//     required VoidCallback onTap,
//     required BuildContext context,
//   }) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           margin: const EdgeInsets.symmetric(horizontal: 8),
//           decoration: BoxDecoration(
//             color: isDark ? Colors.grey[900] : Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             children: [
//               CircleAvatar(
//                 backgroundColor: isDark ? Colors.white : Colors.black,
//                 child: Icon(icon, color: isDark ? Colors.black : Colors.white),
//               ),
//               const SizedBox(height: 10),
//               Text(labelKey.tr(),
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               Text(subtitleKey.tr(),
//                   style: const TextStyle(fontSize: 12, color: Colors.grey)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildSocialCard({
//     required IconData icon,
//     required String titleKey,
//     required String subtitleKey,
//     required VoidCallback onTap,
//     required BuildContext context,
//   }) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//           color: isDark ? Colors.grey[850] : Colors.black.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: isDark ? Colors.white : Colors.black,
//               child: Icon(icon, color: isDark ? Colors.black : Colors.white),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(titleKey.tr(),
//                       style: const TextStyle(fontWeight: FontWeight.bold)),
//                   Text(subtitleKey.tr(),
//                       style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//             ),
//             Icon(Icons.share_outlined,
//                 color: isDark ? Colors.white70 : Colors.black),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final Color backgroundColor =
//     isDark ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFCFFAD3);
//
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         leading: BackButton(color: isDark ? Colors.white : Colors.black),
//         title: Text("contact_us".tr(),
//             style: TextStyle(color: isDark ? Colors.white : Colors.black)),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: ListView(
//           children: [
//             const SizedBox(height: 10),
//             Text(
//               "contact_us_description".tr(),
//               style: TextStyle(
//                   fontSize: 14,
//                   color: isDark ? Colors.white70 : Colors.black87),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 buildContactButton(
//                   icon: Icons.call,
//                   labelKey: "call_us",
//                   subtitleKey: "working_hours",
//                   onTap: () => _launchUrl("tel:+1234567890"),
//                   context: context,
//                 ),
//                 buildContactButton(
//                   icon: Icons.email,
//                   labelKey: "email_us",
//                   subtitleKey: "working_hours",
//                   onTap: () => _launchUrl("mailto:test@example.com"),
//                   context: context,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Text("social_media".tr(),
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             buildSocialCard(
//               icon: FontAwesomeIcons.instagram,
//               titleKey: "instagram",
//               subtitleKey: "instagram_desc",
//               onTap: () => _launchUrl("https://instagram.com/flutter.dev"),
//               context: context,
//             ),
//             buildSocialCard(
//               icon: FontAwesomeIcons.telegram,
//               titleKey: "telegram",
//               subtitleKey: "telegram_desc",
//               onTap: () => _launchUrl("https://t.me/flutterdev"),
//               context: context,
//             ),
//             buildSocialCard(
//               icon: FontAwesomeIcons.facebook,
//               titleKey: "facebook",
//               subtitleKey: "facebook_desc",
//               onTap: () => _launchUrl("https://facebook.com/flutterdev"),
//               context: context,
//             ),
//             buildSocialCard(
//               icon: FontAwesomeIcons.whatsapp,
//               titleKey: "whatsapp",
//               subtitleKey: "working_hours",
//               onTap: () => _launchUrl("https://wa.me/1234567890"),
//               context: context,
//             ),
//             buildSocialCard(
//               icon: FontAwesomeIcons.youtube,
//               titleKey: "youtube",
//               subtitleKey: "youtube_desc",
//               onTap: () => _launchUrl("https://youtube.com/flutterdev"),
//               context: context,
//             ),
//             buildSocialCard(
//               icon: Icons.location_on,
//               titleKey: "location",
//               subtitleKey: "location_desc",
//               onTap: () => _launchUrl(
//                   "https://www.google.com/maps?q=Amman+Jordan"),
//               context: context,
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
