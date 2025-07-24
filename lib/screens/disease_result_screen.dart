
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_1/common/image_picker.dart';

import '../common/disease_result_screen.dart';
import '../providers/disease_details.dart';

class DiseaseResultScreen extends StatelessWidget {
  // هذه الشاشة ستستقبل كائن DiseaseDetails كاملاً
  final DiseaseDetails diseaseDetails;
  const DiseaseResultScreen({super.key, required this.diseaseDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Disease Details'.tr()), // عنوان مناسب
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      // هنا نقوم بعرض الـ Widget الذي يعرض التفاصيل، ونمرر له البيانات الجاهزة
      body: DiseaseDetailsWidget(diseaseDetails: diseaseDetails),
    );
  }
}
// --- نهاية الشاشة الجديدة ---