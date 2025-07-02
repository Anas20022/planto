import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../../model/fetch_fertilizer_model.dart';
import '../../providers/disease_provider.dart';

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
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                title: Text(
                                  "🌱 Plant: ${result['plantName']}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          "🦠 Disease: ${result['diseaseName']}",
                                          style: TextStyle(
                                            color: result['diseaseName'].toString().toLowerCase().contains("healthy")
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.w500,
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
                                      "📅 Date: ${_parseTimestamp(result['timestamp'])}",
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
                                            "🌐 View More",
                                            style: TextStyle(color: Colors.blue[700], decoration: TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                                  onPressed: () async {
                                    await diseaseProvider.deleteArchivedResult(index);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Deleted from archive".tr())),
                                    );
                                  },
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
                ]
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: Fertilizer.getFertilizers(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('${"Error loading fertilizers:".tr()} ${snapshot.error}'));
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
        return "Invalid timestamp";
      }
    } catch (e) {
      return "Error parsing date";
    }
  }

  Widget buildFertilizerItem(BuildContext context, Fertilizer fertilizer) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(fertilizer.link);
        if (!await launchUrl(url)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${"Could not open link for".tr()} ${fertilizer.name}')),
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
