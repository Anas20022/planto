import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/disease_model.dart';

class DiseaseDetailsWidget extends StatelessWidget {
  // *** تعديل: لم تعد تحتاج imagePath، بل تحتاج diseaseDetails
  final DiseaseDetails diseaseDetails; // الأن تستقبل كائن DiseaseDetails كاملاً
  const DiseaseDetailsWidget({
    super.key,
    required this.diseaseDetails,
  });

  // حذف هذا السطر لأنه لم يعد مطلوباً
  // final String imagePath; // <--- قم بحذف هذا السطر

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                diseaseDetails.plantName, // استخدام البيانات مباشرة من diseaseDetails
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: 'Disease: ',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                children: [
                  // استخدام toLowerCase() لجعل التحقق أكثر مرونة
                  if (diseaseDetails.diseaseName.toLowerCase().contains("healthy"))
                    const TextSpan(
                      text: "Plant is healthy",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    )
                  else
                    TextSpan(
                      text: diseaseDetails.diseaseName,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Remedies:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // استخدام البيانات مباشرة من diseaseDetails
            ...diseaseDetails.remedies
                .map((text) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("• $text"),
            ))
            ,

            const SizedBox(height: 15),
            const Text(
              "Prevention:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // استخدام البيانات مباشرة من diseaseDetails
            ...diseaseDetails.prevention
                .map((text) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("• $text"),
            ))
            ,
            const SizedBox(height: 15),
            const Text(
              "Fertilizers: ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // استخدام البيانات مباشرة من diseaseDetails
            ...diseaseDetails.fertilizer.entries
                .map(
                  (entry) => GestureDetector(
                onTap: () async {
                  final url = Uri.parse(entry.value);
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
            ,
            // TODO: Add fertilizer and pesticide recommendation
          ],
        ),
      ),
    );
  }
}