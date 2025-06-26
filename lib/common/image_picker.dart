import 'dart:developer';
import 'dart:io'; // أضف هذا الاستيراد
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // أضف هذا الاستيراد

import '../providers/disease_provider.dart';
import '../screens/image_preview.dart';
import 'global_context.dart'; // تأكد من وجود هذا إن كنت تستخدمه

Future<void> chooseImageFromGallery() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image, // حدد النوع ليتناسب مع الصور فقط
    allowMultiple: false, // اختر صورة واحدة فقط
  );

  if (result != null && result.files.single.path != null) {
    final String originalPath = result.files.single.path!; // المسار الأصلي من file_picker
    log("Original picked image path: $originalPath");

    try {
      // الحصول على دليل المستندات الخاص بالتطبيق (مكان آمن ودائم)
      final appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;

      // إنشاء اسم فريد للملف الجديد للحفاظ على الاسم الأصلي
      final String fileName = result.files.single.name;
      final String newPath = '$appDocPath/$fileName';

      // نسخ الملف من المسار المؤقت/الخارجي إلى مسار التطبيق الداخلي
      final File newImageFile = await File(originalPath).copy(newPath);
      final String imagePathForPreview = newImageFile.path;

      log("Copied image to: $imagePathForPreview");

      // اختياري: تحقق من حجم الملف المنسوخ
      final fileLength = await newImageFile.length();
      log("Copied file size: $fileLength bytes");
      if (fileLength == 0) {
        log("Copied image file is empty!");
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text("Selected image is empty or corrupted.")),
        );
        return;
      }

      // لا تستدعي DiseaseProvider.detectDisease هنا بشكل مباشر
      // لأنه سيتم استدعاؤه لاحقًا في ImagePreview بعد التأكيد

      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => ImagePreview(imagePath: imagePathForPreview),
        ),
      );
    } catch (e) {
      log("Error copying image or processing: $e");
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text("Error processing image: ${e.toString()}")),
      );
    }
  } else {
    log("User canceled the picker or no file selected.");
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(content: Text("No image selected.")),
    );
  }
}