import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/fetch_fertilizer.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ArchiveScreen"),
        backgroundColor: Color(0xFF508776),
      ),
      body: FutureBuilder(
        future: Fertilizer.getFertilizers(),
        builder: (_, snapshot) {
          if (!(snapshot.hasData)) {
            log(snapshot.data.toString());
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final fertilizers = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .6,
              ),
              itemCount: fertilizers.length,
              itemBuilder: (context, index) {
                final fertilizer = fertilizers[index];
                return buildFertilizerItem(fertilizer);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildFertilizerItem(Fertilizer fertilizer) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(fertilizer.link);
        if (!await launchUrl(url)) {
          throw Exception('Could not launch $url');
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                fertilizer.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  fertilizer.image,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                fertilizer.description,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                fertilizer.price,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
