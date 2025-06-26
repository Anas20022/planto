import 'dart:convert';
import 'dart:developer';
import 'dart:io'; // ممكن ما نحتاجها بعد التعديل بس خليها احتياط
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart'; // ما بنحتاجها لأي اتصال بالإنترنت
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // ما زلنا نحتاجها لفحص الاتصال فقط

import 'disease_model.dart';
import '../utils/TfliteModel.dart'; // ** جديد: لاستخدام runModelTest المحلي **

class DiseaseProvider with ChangeNotifier {
  // بنشيل onlineServer و offlineServer بما إننا ما بنستخدمش خوادم خارجية

  bool _offline = false; // رح نستخدمها لتحديد إذا كان في نت ولا لأ

  bool get offline => _offline; // لسه ممكن تستخدمها في الـ UI

  // بنشيل constructor والدوال اللي بتتعامل مع _offline_state يدويًا
  // DiseaseProvider() {}

  // دالة لحفظ آخر نتيجة تحليل
  Future<void> saveLastAnalysisResult(String plantName, String diseaseName) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> lastResult = {
      'plantName': plantName,
      'diseaseName': diseaseName,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString('lastAnalysisResult', jsonEncode(lastResult));
    log("Last analysis result saved: $lastResult");
  }

  // دالة لجلب آخر نتيجة تحليل
  Future<Map<String, dynamic>?> getLastAnalysisResult() async {
    final prefs = await SharedPreferences.getInstance();
    final String? resultString = prefs.getString('lastAnalysisResult');
    if (resultString != null) {
      return jsonDecode(resultString);
    }
    return null;
  }

  // ** التعديل الرئيسي في دالة `detectDisease` **
  Future<DiseaseDetails> detectDisease(String plantName, Uint8List imageBytes) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    log("Connectivity result: $connectivityResult"); // سجل حالة الاتصال

    if (connectivityResult == ConnectivityResult.none) {
      // ** لا يوجد اتصال بالإنترنت (وضع الأوفلاين) **
      _offline = true;
      notifyListeners();

      log("No internet connection. Returning the last saved analysis result.");
      final lastResult = await getLastAnalysisResult();
      if (lastResult != null) {
        // لو في نتيجة سابقة، بنرجعها
        return DiseaseDetails(
          plantName: lastResult['plantName'],
          diseaseName: lastResult['diseaseName'],
          remedies: ["علاج الأوفلاين: راجع النصائح المحفوظة.", "علاج الأوفلاين: تأكد من أن نبتتك لا تزال موجودة."],
          prevention: ["وقاية الأوفلاين: استشر خبيرًا عندما يتوفر الاتصال."],
          fertilizer: {"رابط سماد أوفلاين": "https://example.com/offline_fert_link"},
          // googleSearchLink: "https://www.google.com/search?q=${Uri.encodeComponent('${lastResult['plantName']} ${lastResult['diseaseName']} disease remedies')}",
        );
      } else {
        // لو مفيش إنترنت ومفيش نتائج سابقة محفوظة
        log("No internet and no previous analysis saved. Throwing error.");
        throw Exception("لا يوجد اتصال بالإنترنت ولا توجد نتائج تحليل سابقة محفوظة. يرجى الاتصال بالإنترنت لإجراء أول تحليل.");
      }
    } else {
      // ** يوجد اتصال بالإنترنت (لكننا لن نستخدم خادم خارجي، بل النموذج المحلي) **
      _offline = false;
      notifyListeners();

      log("Internet connection detected. Running local TFLite model.");

      try {
        // ** هنا بنستخدم runModelTest للتحليل المحلي **
        // runModelTest بترجع String?، فلازم نحولها لـ DiseaseDetails
        String? detectedDiseaseName = await runModelTest(plantName, imageBytes);

        if (detectedDiseaseName != null) {
          await saveLastAnalysisResult(plantName, detectedDiseaseName);
          return DiseaseDetails(
            plantName: plantName,
            diseaseName: detectedDiseaseName,
            // بنحط علاجات ووقاية وأسمدة افتراضية أو عامة من مكان تاني
            // لأن النموذج المحلي ما بيوفرش هالمعلومات
            remedies: ["علاج محلي: قم بإزالة الأوراق المصابة.", "علاج محلي: استخدم مبيد فطري عضوي."],
            prevention: ["وقاية محلية: حافظ على المسافة بين النباتات.", "وقاية محلية: قم بالري في الصباح الباكر."],
            fertilizer: {"سماد مقترح": "https://example.com/general_fertilizer"},
            // googleSearchLink: "https://www.google.com/search?q=${Uri.encodeComponent('$plantName $detectedDiseaseName disease remedies')}",
          );
        } else {
          log("Local TFLite model failed to detect disease.");
          throw Exception("فشل التحليل بواسطة النموذج المحلي.");
        }
      } catch (e) {
        log("Error running local TFLite model: $e");
        throw Exception("حدث خطأ أثناء تشغيل النموذج المحلي: ${e.toString()}");
      }
    }
  }
}