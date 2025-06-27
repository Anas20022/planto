import 'dart:convert';
import 'dart:developer';
import 'dart:io'; // ممكن ما نحتاجها بعد التعديل بس خليها احتياط
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart'; // ما بنحتاجها لأي اتصال بالإنترنت
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // ما زلنا نحتاجها لفحص الاتصال فقط
import 'package:flutter/services.dart' show rootBundle; // لإحضار الملف

import '../model/fetch_fertilizer_model.dart';
import 'disease_details.dart';
import '../utils/TfliteModel.dart'; // ** جديد: لاستخدام runModelTest المحلي **


import 'dart:developer' as dev;


class DiseaseProvider with ChangeNotifier {
  bool _offline = false;
  List<Map<String, dynamic>>? _archivedResults; // ✅ تخزين النتائج المؤرشفة مؤقتًا
  List<Map<String, dynamic>>? get archivedResults => _archivedResults; // ✅ getter للوصول من الخارج

  bool get offline => _offline;

  Future<void> loadArchivedResults() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> rawList = prefs.getStringList('archived_results') ?? [];

    _archivedResults = rawList
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();

    notifyListeners(); // ✅ إعلام المستمعين (الواجهة) إنه صار تحديث
  }

  Future<Map<String, dynamic>> loadDiseaseData(String diseaseName) async {
    final String jsonString = await rootBundle.loadString('assets/diseases_data.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    if (jsonMap.containsKey(diseaseName)) {
      return jsonMap[diseaseName];
    } else {
      throw Exception("Disease not found in JSON: $diseaseName");
    }
  }

  Future<void> deleteArchivedResult(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> results = prefs.getStringList('archived_results') ?? [];

    if (index >= 0 && index < results.length) {
      results.removeAt(index);
      await prefs.setStringList('archived_results', results);
      await loadArchivedResults(); // ✅ إعادة تحميل النتائج بعد الحذف
    }
  }




  Future<void> saveLastAnalysisResult(String plantName, String diseaseName) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> lastResult = {
      'plantName': plantName,
      'diseaseName': diseaseName,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString('lastAnalysisResult', jsonEncode(lastResult));
    dev.log("Last analysis result saved: $lastResult");
  }

  Future<Map<String, dynamic>?> getLastAnalysisResult() async {
    final prefs = await SharedPreferences.getInstance();
    final String? resultString = prefs.getString('lastAnalysisResult');
    if (resultString != null) {
      return jsonDecode(resultString);
    }
    return null;
  }

  // لتخزين نتيجة مؤرشفة دائمًا
  Future<void> saveArchivedAnalysisResult(String plantName, String diseaseName) async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ توحيد اسم المفتاح هنا
    final List<String> archivedList = prefs.getStringList('archived_results') ?? [];

    final Map<String, dynamic> newResult = {
      'plantName': plantName,
      'diseaseName': diseaseName,
      'timestamp': DateTime.now().toIso8601String(),
    };

    archivedList.add(jsonEncode(newResult));

    await prefs.setStringList('archived_results', archivedList); // ✅ نفس الاسم الموحد
    await loadArchivedResults(); // ✅ تحديث القائمة المحلية داخل الـ provider
    notifyListeners();
  }

// لجلب النتيجة المؤرشفة
  Future<List<Map<String, dynamic>>> getArchivedAnalysisResult() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> archivedList = prefs.getStringList('archivedResults') ?? [];

    return archivedList.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }


  Future<DiseaseDetails> detectDisease(String plantName, Uint8List imageBytes) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    dev.log("Connectivity result: $connectivityResult");

    // Load all fertilizers and pick 4 random suggestions
    final allFertilizers = await Fertilizer.getFertilizers();
    allFertilizers.shuffle(Random());
    final randomSuggestions = allFertilizers.take(4).toList();

    if (connectivityResult == ConnectivityResult.none) {
      _offline = true;
      notifyListeners();

      dev.log("No internet connection. Returning the last saved analysis result.");
      final lastResult = await getLastAnalysisResult();
      if (lastResult != null) {
        return DiseaseDetails(
          plantName: lastResult['plantName'],
          diseaseName: lastResult['diseaseName'],
          remedies: ["علاج الأوفلاين: راجع النصائح المحفوظة.", "علاج الأوفلاين: تأكد من أن نبتتك لا تزال موجودة."],
          prevention: ["وقاية الأوفلاين: استشر خبيرًا عندما يتوفر الاتصال."],
          suggestions: randomSuggestions, fertilizer: {},
        );
      } else {
        dev.log("No internet and no previous analysis saved. Throwing error.");
        throw Exception("لا يوجد اتصال بالإنترنت ولا توجد نتائج تحليل سابقة محفوظة.");
      }
    } else {
      _offline = false;
      notifyListeners();

      dev.log("Internet connection detected. Running local TFLite model.");

      try {
        String? detectedDiseaseName = await runModelTest(plantName, imageBytes);

        if (detectedDiseaseName != null) {
          await saveLastAnalysisResult(plantName, detectedDiseaseName);

          final diseaseInfo = await loadDiseaseData(detectedDiseaseName); // 🔄 اقرأ من JSON

          return DiseaseDetails(
            plantName: plantName,
            diseaseName: detectedDiseaseName,
            remedies: List<String>.from(diseaseInfo['remedies'] ?? []),
            prevention: List<String>.from(diseaseInfo['prevention'] ?? []),
            suggestions: randomSuggestions,
            fertilizer: {}, // إذا بدنا نضيف روابط لاحقاً من نفس json
          );
        } else {
          dev.log("Local TFLite model failed to detect disease.");
          throw Exception("فشل التحليل بواسطة النموذج المحلي.");
        }
      } catch (e) {
        dev.log("Error running local TFLite model: $e");
        throw Exception("حدث خطأ أثناء تشغيل النموذج المحلي: ${e.toString()}");
      }
    }
  }
}
