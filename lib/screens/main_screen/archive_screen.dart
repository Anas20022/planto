import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../../model/fetch_fertilizer_model.dart';
import '../../providers/disease_details.dart';
import '../../providers/disease_provider.dart';
import '../disease_result_screen.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final diseaseProvider = Provider.of<DiseaseProvider>(context, listen: false);
    if (diseaseProvider.archivedResults == null) {
      diseaseProvider.loadArchivedResults();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Archive".tr()),
        backgroundColor: const Color(0xFF508776),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- قسم التحاليل المؤرشفة ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<DiseaseProvider>(
                    builder: (context, diseaseProvider, _) {
                      final results = diseaseProvider.archivedResults;

                      if (results == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (results.isEmpty) {
                        return Center(child: Text("No archived analyses found.".tr(), style: const TextStyle(fontSize: 16)));
                      } else {
                        return Column(
                          children: results.asMap().entries.map((entry) {
                            final index = entry.key;
                            final result = entry.value;

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9), // ✅ أخضر فاتح
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                                ],
                              ),
                              child: ListTile(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                    ),
                                    builder: (_) {
                                      return Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading: const Icon(Icons.info_outline, color: Colors.blue),
                                              title: Text("View details".tr()),
                                              onTap: () async {
                                                Navigator.pop(context);

                                                final diseaseName = result['diseaseName']?.toString() ?? "";
                                                final accuracy = result['accuracy'] ?? 0.0;

                                                if (diseaseName.toLowerCase() == "unknown" || accuracy < 0.8) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text("❗ No details available for unknown disease.".tr()),
                                                    ),
                                                  );
                                                  return;
                                                }

                                                try {
                                                  final diseaseInfo = await diseaseProvider.loadDiseaseData(diseaseName);
                                                  final allFertilizers = await Fertilizer.getFertilizers();
                                                  allFertilizers.shuffle();
                                                  final randomSuggestions = allFertilizers.take(4).toList();

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => DiseaseResultScreen(
                                                        diseaseDetails: DiseaseDetails(
                                                          plantName: result['plantName'],
                                                          diseaseName: diseaseName,
                                                          accuracy: accuracy,
                                                          remedies: List<String>.from(diseaseInfo['remedies'] ?? []),
                                                          prevention: List<String>.from(diseaseInfo['prevention'] ?? []),
                                                          link: diseaseInfo['link'],
                                                          fertilizer: {},
                                                          suggestions: randomSuggestions,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text("Error loading disease details: $e")),
                                                  );
                                                }
                                              },
                                            ),

                                            ListTile(
                                              leading: const Icon(Icons.delete_forever, color: Colors.red),
                                              title: Text("Delete from archive".tr()),
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await diseaseProvider.deleteArchivedResult(index);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("Deleted from archive".tr())),
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.cancel, color: Colors.grey),
                                              title: Text("Cancel".tr()),
                                              onTap: () => Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                contentPadding: const EdgeInsets.all(12),
                                title: Row(
                                  children: [
                                    Text(
                                      "🌱 ${"Plant".tr()}: ",
                                      style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                    ),
                                    Text(
                                      "${result['plantName']}".tr(),
                                      style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                "🦠 ${"Disease".tr()}: ",
                                                style: TextStyle(
                                                  color: result['diseaseName'].toString().toLowerCase().contains("healthy")
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                "${result['diseaseName']}".tr(),
                                                style: TextStyle(
                                                  color: result['diseaseName'].toString().toLowerCase().contains("healthy")
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        if (result.containsKey('accuracy'))
                                          Text(
                                            "(${(result['accuracy'] * 100).toStringAsFixed(1)}%)",
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                          ),
                                      ],
                                    ),

                                    const SizedBox(height: 4),
                                    Text(
                                      "📅 ${"Date".tr()}: ${_parseTimestamp(result['timestamp'])}",
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    if (result.containsKey('link') && result['link'].toString().isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: GestureDetector(
                                          onTap: () async {
                                            final url = Uri.parse(result['link']);
                                            if (await canLaunchUrl(url)) {
                                              await launchUrl(url);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Could not open link.".tr())),
                                              );
                                            }
                                          },
                                          child: Text(
                                            "🌐 View More".tr(),
                                            style: TextStyle(color: Colors.blue[700], decoration: TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    "Fertilizers:".tr(),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF438853)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: Fertilizer.getFertilizers(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading fertilizers: ${snapshot.error}'));
                } else {
                  final fertilizers = (snapshot.data!..shuffle()).take(4).toList();
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: fertilizers.length,
                    itemBuilder: (context, index) {
                      final fertilizer = fertilizers[index];
                      return buildFertilizerItem(context, fertilizer);
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

  static String _parseTimestamp(dynamic timestamp) {
    try {
      if (timestamp is String) {
        return DateTime.parse(timestamp).toLocal().toShortDateString();
      } else if (timestamp is int) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal().toShortDateString();
      } else {
        return "Invalid timestamp".tr();
      }
    } catch (e) {
      return "Error parsing date".tr();
    }
  }

  Widget buildFertilizerItem(BuildContext context, Fertilizer fertilizer) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(fertilizer.link);
        if (!await launchUrl(url)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Could not open link for ${fertilizer.name}".tr())),
          );
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                fertilizer.name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  fertilizer.image,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Text(
                fertilizer.description,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                fertilizer.price,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return '${year}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
