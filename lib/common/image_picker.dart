import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


import '../providers/disease_provider.dart';
import '../screens/image_preview.dart';
import 'global_context.dart';

Future<void> chooseImageFromGallery() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    final String imagePath = result.files.single.path ?? "";
    if (imagePath.isEmpty) {
      log("No file selected");
      return;  // إضافة شرط للتحقق من الصورة قبل المتابعة
    }

    log("imagePath =  $imagePath");

    DiseaseProvider.detectDisease(imagePath).then((value) {
      log("value : $value");
    });

    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => ImagePreview(imagePath: imagePath),
      ),
    );
  } else {
    log("User canceled the picker");
  }
}
