import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/disease_model.dart';
import '../providers/disease_provider.dart';

class ImagePreview extends StatelessWidget {
  final String imagePath;
  const ImagePreview({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: SizedBox(
                height: 400,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),  // مساحة فارغة بين الصورة والأزرار
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,  // جعل الأزرار في الأسفل
                  children: [
                    // زر تأكيد الصورة
                    ElevatedButton(
                      onPressed: () {
                        // إرسال الصورة لتحليلها باستخدام AI
                        DiseaseProvider.detectDisease(imagePath).then((value) {
                          // عرض النتيجة أو الانتقال لصفحة النتائج
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("AI Analysis Result"),
                              content: Text("Detected disease: ${value.diseaseName}"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close"),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green, // لون النص
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5, // إضافة ظل خفيف للزر
                        shadowColor: Colors.green.withOpacity(0.3), // لون الظل
                      ),
                      child: const Text(
                        "Confirm and Analyze",
                        style: TextStyle(
                          fontSize: 16,  // حجم الخط
                          fontWeight: FontWeight.bold,  // جعل النص عريضًا
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    // زر إلغاء
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // العودة للكاميرا
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class DiseaseDetailsWidget extends StatelessWidget {
  const DiseaseDetailsWidget({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: DiseaseProvider.detectDisease(imagePath),
        builder: (context, disease) {
          if (disease.hasData) {
            DiseaseDetails diseaseDetails = disease.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      diseaseDetails.plantName,
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
                        if (diseaseDetails.diseaseName.contains("healthy"))
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
            );
          } else {
            return const Center(
                child: Padding(
                  padding: EdgeInsets.all(50.0),
                  child: CircularProgressIndicator(),
                ));
          }
        },
      ),
    );
  }
}
