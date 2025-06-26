
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/disease_result_screen.dart';
import '../providers/disease_model.dart';

class DiseaseResultScreen extends StatelessWidget {
  // هذه الشاشة ستستقبل كائن DiseaseDetails كاملاً
  final DiseaseDetails diseaseDetails;
  const DiseaseResultScreen({super.key, required this.diseaseDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Details'), // عنوان مناسب
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      // هنا نقوم بعرض الـ Widget الذي يعرض التفاصيل، ونمرر له البيانات الجاهزة
      body: DiseaseDetailsWidget(diseaseDetails: diseaseDetails),
    );
  }
}
// --- نهاية الشاشة الجديدة ---