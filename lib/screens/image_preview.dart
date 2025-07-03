import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/disease_details.dart';
import '../providers/disease_provider.dart';
import '../providers/plant_selection_provider.dart';
import 'disease_result_screen.dart';

class ImagePreview extends StatelessWidget {
  final String imagePath;
  const ImagePreview({super.key, required this.imagePath});

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
        title: Text('About'.tr()),
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
                  child: FutureBuilder<Uint8List?>(
                    future: _readImageBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        } else if (snapshot.hasError) {
                          print("FutureBuilder error: ${snapshot.error}");
                          return Center(child: Text('Failed to load image.'.tr()));
                        } else {
                          print("FutureBuilder: No data or empty data.");
                          return Center(child: Text('Image data not available.'.tr()));
                        }
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final selectedPlant = context.read<PlantSelectionProvider>().selectedPlant;

                        if (selectedPlant == null || selectedPlant.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please select a plant first!".tr())),
                          );
                          return;
                        }

                        Uint8List? imageBytes = await _readImageBytes();
                        if (imageBytes == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: Image data not available for analysis.".tr())),
                          );
                          return;
                        }

                        try {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const CircularProgressIndicator(color: Colors.white),
                                  const SizedBox(width: 16),
                                  Text("Analyzing image...".tr()),
                                ],
                              ),
                              duration: const Duration(seconds: 10),
                            ),
                          );

                          final diseaseProvider = context.read<DiseaseProvider>();
                          final DiseaseDetails detectedDetails =
                          await diseaseProvider.detectDisease(selectedPlant, imageBytes);

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiseaseResultScreen(diseaseDetails: detectedDetails),
                            ),
                          );

                        } catch (e) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          print("Error during analysis: $e");
                          log("Error during analysis: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${'Analysis failed:'.tr()} ${e.toString()}")),
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
                      child: Text(
                        "Confirm and Analyze".tr(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Cancel".tr(),
                        style: const TextStyle(color: Colors.red),
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
