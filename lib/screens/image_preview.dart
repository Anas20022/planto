import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:typed_data'; // إضافة هذا الاستيراد

import '../providers/disease_details.dart';
import '../providers/disease_provider.dart';
import '../providers/plant_selection_provider.dart';
import '../utils/TfliteModel.dart';
import 'disease_result_screen.dart';

class ImagePreview extends StatelessWidget {
  final String imagePath;
  const ImagePreview({super.key, required this.imagePath});


  // جديد: دالة لقراءة الملف كبايتات
  Future<Uint8List?> _readImageBytes() async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      } else {
        print("Error: Image file does not exist at path: $imagePath");
        return null;
      }
    } catch (e) {
      print("Error reading image bytes: $e");
      return null;
    }
  }


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
                  child: FutureBuilder<Uint8List?>( // استخدم FutureBuilder لقراءة البايتات
                    future: _readImageBytes(), // استدعاء الدالة الجديدة
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData && snapshot.data != null) {
                          // إذا كانت البيانات موجودة، اعرض الصورة باستخدام Image.memory
                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        } else if (snapshot.hasError) {
                          // إذا حدث خطأ في قراءة البايتات
                          print("FutureBuilder error: ${snapshot.error}");
                          return const Center(child: Text('Failed to load image.'));
                        } else {
                          // إذا لم تكن هناك بيانات (مثلاً الملف غير موجود أو فارغ)
                          print("FutureBuilder: No data or empty data.");
                          return const Center(child: Text('Image data not available.'));
                        }
                      }
                      // أثناء التحميل
                      return const Center(child: CircularProgressIndicator());
                    },
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
                    // في ملف: screens/image_preview.dart
// ... (الجزء العلوي من كلاس ImagePreview)

// زر تأكيد الصورة
                    ElevatedButton(
                      onPressed: () async {
                        // 1. التحقق من اختيار النبتة وقراءة الصورة
                        final selectedPlant = context.read<PlantSelectionProvider>().selectedPlant;

                        if (selectedPlant == null || selectedPlant.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please select a plant first!")),
                          );
                          return;
                        }

                        Uint8List? imageBytes = await _readImageBytes();
                        if (imageBytes == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Error: Image data not available for analysis.")),
                          );
                          return;
                        }

                        // 2. بدء عملية التحليل وعرض مؤشر تحميل
                        try {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Row(
                                children: [
                                  CircularProgressIndicator(color: Colors.white),
                                  SizedBox(width: 16),
                                  Text("Analyzing image..."),
                                ],
                              ),
                              duration: Duration(seconds: 10), // Adjust as needed
                            ),
                          );

                          // 3. الحصول على كائن DiseaseProvider واستدعاء دالة detectDisease
                          final diseaseProvider = context.read<DiseaseProvider>();
                          final DiseaseDetails detectedDetails =
                          await diseaseProvider.detectDisease(selectedPlant, imageBytes);

                          // 4. إخفاء مؤشر التحميل بعد الانتهاء
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          // 5. الانتقال إلى شاشة عرض النتائج (DiseaseResultScreen)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiseaseResultScreen(diseaseDetails: detectedDetails),
                            ),
                          );

                        } catch (e) {
                          // 6. التعامل مع الأخطاء: إخفاء التحميل وعرض رسالة خطأ
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          print("Error during analysis: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Analysis failed: ${e.toString()}")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                        shadowColor: Colors.green.withOpacity(0.3),
                      ),
                      child: const Text(
                        "Confirm and Analyze",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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




