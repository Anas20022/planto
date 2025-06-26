import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart'; // *** جديد: لاستخدام Provider

import '../../providers/fetch_fertilizer.dart';
import '../../providers/disease_provider.dart'; // *** جديد: لاستخدام DiseaseProvider

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Archive"), // عنوان أوضح
        backgroundColor: Color(0xFF508776),
      ),
      body: SingleChildScrollView( // *** مهم: لجعل المحتوى قابلاً للتمرير
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // لجعل النصوص تبدأ من اليسار
          children: [
            // --- قسم عرض آخر نتيجة تحليل نبات ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<Map<String, dynamic>?>(
                    // *** جديد: جلب آخر نتيجة تحليل من DiseaseProvider
                    future: context.read<DiseaseProvider>().getLastAnalysisResult(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        log('Error loading last analysis result: ${snapshot.error}');
                        return Center(child: Text('Error loading analysis: ${snapshot.error}'));
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final result = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Last Plant Analysis:",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF438853)),
                            ),
                            const SizedBox(height: 10),
                            Text("Plant: ${result['plantName']}", style: const TextStyle(fontSize: 16)),
                            // عرض اسم المرض مع لون مناسب
                            Text(
                              "Disease: ${result['diseaseName']}",
                              style: TextStyle(
                                fontSize: 16,
                                color: result['diseaseName'].toString().toLowerCase().contains("healthy")
                                    ? Colors.green // إذا كانت النتيجة صحية
                                    : Colors.red, // إذا كان هناك مرض
                              ),
                            ),
                            Text(
                              "Analyzed On: ${DateTime.parse(result['timestamp']).toLocal().toShortDateString()}",
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        );
                      } else {
                        // لا توجد نتائج سابقة
                        return const Center(
                          child: Text("No previous plant analysis found.", style: TextStyle(fontSize: 16)),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- قسم عرض الأسمدة ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Fertilizers:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF438853)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: Fertilizer.getFertilizers(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) { // لا تستخدم !(snapshot.hasData) بل !snapshot.hasData
                  log("Fertilizers snapshot data: ${snapshot.data.toString()}");
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  log('Error loading fertilizers: ${snapshot.error}');
                  return Center(child: Text('Error loading fertilizers: ${snapshot.error}'));
                } else {
                  final fertilizers = snapshot.data!;
                  // GridView.builder يحتاج إلى shrinkWrap و NeverScrollableScrollPhysics عندما يكون داخل SingleChildScrollView
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .6,
                      crossAxisSpacing: 10, // مسافات بين العناصر أفقياً
                      mainAxisSpacing: 10,  // مسافات بين العناصر عمودياً
                    ),
                    itemCount: fertilizers.length,
                    itemBuilder: (context, index) {
                      final fertilizer = fertilizers[index];
                      return buildFertilizerItem(context,fertilizer);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFertilizerItem(BuildContext context,Fertilizer fertilizer) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(fertilizer.link);
        if (!await launchUrl(url)) {
          // يمكنك عرض رسالة خطأ هنا للمستخدم
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Could not open link for ${fertilizer.name}")),
          );
          log('Could not launch $url'); // تسجيل الخطأ
          // لا ترمي Exception هنا لأنه قد يوقف التطبيق إذا لم يتم التعامل معه
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(5), // تقليل الهامش لعدم تكرار padding
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                fertilizer.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // لمنع تجاوز العنوان
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(15), // زوايا مستديرة للصورة
                child: Image.network(
                  fertilizer.image,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // *** جديد: معالج الأخطاء لصور الشبكة ***
                  errorBuilder: (context, error, stackTrace) {
                    log("Error loading fertilizer image: ${fertilizer.image}, Error: $error");
                    return Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.grey[200], // لون خلفية رمادي
                      child: const Icon(Icons.broken_image, size: 40, color: Colors.grey), // أيقونة صورة مكسورة
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Text(
                fertilizer.description,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 3, // حد أقصى 3 أسطر للوصف
                overflow: TextOverflow.ellipsis, // إضافة نقاط (...) إذا كان النص أطول
              ),
              const SizedBox(height: 5),
              Text(
                fertilizer.price,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// *** جديد: إضافة دالة مساعدة لتنسيق التاريخ (يمكن وضعها في ملف utility خاص بك)
extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return '${year}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}