import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../components/menu_item.dart';
import '../../model/plant_model.dart';
import '../../providers/plant_selection_provider.dart';
import '../../providers/tip_provider.dart';
import '../camera_screen.dart';
import '../../common/image_picker.dart';  // تأكد من وجود هذا الملف والدالة فيه

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Plant> vegetables = [
      Plant(name: "corn", imagePath: 'assets/image/corn.png'),
      Plant(name: "pepper", imagePath: 'assets/image/pepper.png'),
      Plant(name: "potato", imagePath: 'assets/image/potato.png'),
      Plant(name: "tomato", imagePath: 'assets/image/tomato.png'),
    ];

    final List<Plant> fruits = [
      Plant(name: "apple", imagePath: 'assets/image/apple.png'),
      Plant(name: "banana", imagePath: 'assets/image/banana.png'),
      Plant(name: "cherry", imagePath: 'assets/image/cherry.png'),
      Plant(name: "peach", imagePath: 'assets/image/peach.png'),
      Plant(name: "strawberry", imagePath: 'assets/image/strawberry.png'),
    ];

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icon/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "Planto",
                      style: GoogleFonts.aclonica(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF438853),
                        shadows: [
                          Shadow(
                            offset: const Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                buildPlantTipCard(context),
                const SizedBox(height: 20),
                buildMenu1(context),
                const SizedBox(height: 20),
                Text(
                  "vegetables".tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF438853),
                  ),
                ),
                const SizedBox(height: 10),
                buildPlantSelection(context, vegetables),
                const SizedBox(height: 20),
                Text(
                  "fruits".tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF438853),
                  ),
                ),
                const SizedBox(height: 10),
                buildPlantSelection(context, fruits),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildMenu1(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MenuItem(
            text: "upload_image".tr(),
            icon: Icons.upload_file_rounded,
            onPressed: () {
              final selectedPlant = context.read<PlantSelectionProvider>().selectedPlant;
              if (selectedPlant == null || selectedPlant.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("select_plant_first".tr()),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                chooseImageFromGallery();
              }
            },
          ),
          const SizedBox(width: 20),
          MenuItem(
            text: "scan_disease".tr(),
            icon: Icons.camera_enhance_rounded,
            onPressed: () {
              final selectedPlant = context.read<PlantSelectionProvider>().selectedPlant;
              if (selectedPlant == null || selectedPlant.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("select_plant_first".tr()),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CameraScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildPlantSelection(BuildContext context, List<Plant> plants) {
    final selectedPlant = context.watch<PlantSelectionProvider>().selectedPlant;

    return Wrap(
      spacing: 10,
      runSpacing: 20,
      children: plants.map((plant) {
        final isSelected = selectedPlant == plant.name;
        return GestureDetector(
          onTap: () {
            context.read<PlantSelectionProvider>().selectPlant(plant.name);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF438853) : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(plant.imagePath),
              ),
              const SizedBox(height: 5),
              Text(
                plant.name.tr(),
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : const Color(0xFF438853),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildPlantTipCard(BuildContext context) {
    final randomTip = context.watch<TipProvider>().randomTipKey.tr();

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFE8F5E9),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const Icon(Icons.tips_and_updates, color: Color(0xFF438853), size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                randomTip,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF438853),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
