import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_localization/easy_localization.dart'; // تأكد من استيراده

import '../screens/image_preview.dart';
import 'global_context.dart'; // تأكد من وجود هذا إذا كنت تستخدم navigatorKey

Future<void> chooseImageFromGallery() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: false,
  );

  if (result != null && result.files.single.path != null) {
    final String originalPath = result.files.single.path!;
    log("${tr('image.original_picked_path')}: $originalPath");

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;

      final String fileName = result.files.single.name;
      final String newPath = '$appDocPath/$fileName';

      final File newImageFile = await File(originalPath).copy(newPath);
      final String imagePathForPreview = newImageFile.path;

      log("${tr('image.copied_to')}: $imagePathForPreview");

      final fileLength = await newImageFile.length();
      log(tr('image.copied_file_size', namedArgs: {'size': fileLength.toString()}));

      if (fileLength == 0) {
        log("Copied image file is empty!");
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text(tr('image.empty_or_corrupted'))),
        );
        return;
      }

      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => ImagePreview(imagePath: imagePathForPreview),
        ),
      );
    } catch (e) {
      log("Error copying image or processing: $e");
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text(tr('image.error_processing', namedArgs: {'error': e.toString()}))),
      );
    }
  } else {
    log("User canceled the picker or no file selected.");
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(content: Text(tr('image.no_selected'))),
    );
  }
}
