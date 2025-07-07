import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/disease_details.dart';
import '../providers/disease_provider.dart';
import '../providers/mode_provider.dart';

class DiseaseDetailsWidget extends StatelessWidget {
  final DiseaseDetails diseaseDetails;
  const DiseaseDetailsWidget({
    super.key,
    required this.diseaseDetails,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    diseaseDetails.plantName.tr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: 'Disease: '.tr(),
                    style:  TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Provider.of<ModeProvider>(context).darkModeEnable ?Colors.white : Colors.black

                    ),
                    children: [
                      if (diseaseDetails.diseaseName.toLowerCase().contains("healthy"))
                        TextSpan(
                          text: "Plant is healthy".tr(),
                          style: const TextStyle(color: Colors.green),
                        )
                      else
                        TextSpan(
                          text: diseaseDetails.diseaseName,
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "${"Accuracy".tr()}: ${(diseaseDetails.accuracy * 100).toStringAsFixed(2)}%",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 10),

                if (diseaseDetails.link != null && diseaseDetails.link!.isNotEmpty)
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(diseaseDetails.link!);
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch ${diseaseDetails.link}');
                      }
                    },
                    child: Text(
                      "🌐 More info".tr(),
                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),

                const SizedBox(height: 20),
                Text("🌿 Remedies:".tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(thickness: 1.2),
                ...diseaseDetails.remedies.map((text) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text("• $text", style: const TextStyle(fontSize: 16)),
                )),
                const SizedBox(height: 20),
                Text("🛡️ Prevention:".tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(thickness: 1.2),
                ...diseaseDetails.prevention.map((text) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text("• $text", style: const TextStyle(fontSize: 16)),
                )),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final archived = await Provider.of<DiseaseProvider>(context, listen: false).saveArchivedAnalysisResult(
                        diseaseDetails.plantName,
                        diseaseDetails.diseaseName,
                        diseaseDetails.accuracy,
                      );

                      if (archived) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("✅ Result archived successfully.".tr())),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("⚠️ This result is already archived.".tr())),
                        );
                      }
                    },
                    icon: const Icon(Icons.archive),
                    label: Text("Archive this result".tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
