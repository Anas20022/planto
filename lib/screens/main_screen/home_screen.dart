import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../common/image_picker.dart';
import '../../components/menu_item.dart';
import '../../model/plant.dart';
import '../../providers/disease_provider.dart';
import '../../providers/plant_selection_provider.dart';
import '../../providers/tip_provider.dart';
import '../camera_screen.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Plant> vegetables = [
      Plant(name: "Corn", imagePath: 'assets/image/corn.png'), // كان "corn"
      Plant(name: "Papper_bell", imagePath: 'assets/image/pepper.png'), // كان "Pepper"
      Plant(name: "Potato", imagePath: 'assets/image/potato.png'), // كان "potato"
      Plant(name: "Tomato", imagePath: 'assets/image/tomato.png'), // كان "tomato"
    ];

    final List<Plant> fruits = [
      Plant(name: "Apple", imagePath: 'assets/image/apple.png'),
      Plant(name: "Banana", imagePath: 'assets/image/banana.png'), // هذا النبات ليس له نموذج حاليا
      Plant(name: "Cherry", imagePath: 'assets/image/cherry.png'),
      Plant(name: "Peach", imagePath: 'assets/image/peach.png'),
      Plant(name: "Strawberry", imagePath: 'assets/image/strawberry.png'), // كان "strawberry"
    ];
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80, // توسيع حجم الصورة لتناسب التصميم
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle, // يجعل الصورة دائرة
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // ظل ناعم
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 3), // تغيير مكان الظل
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
                        color: Color(0xFF438853),
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10,),

                buildPlantTipCard(context),
                SizedBox(height: 20,),

                buildMenu1(context),
                const SizedBox(height: 20),
                // Selector<DiseaseProvider, bool>(
                //   selector: (_, provider) => provider.offline,
                //   builder: (_, offline, __) =>
                //   !offline ? buildMenu2(context) : const SizedBox(),
                // ),
                Text(
                  "Vegetables",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF438853)),
                ),

                const SizedBox(height: 10),
                buildPlantSelection(context, vegetables),

                const SizedBox(height: 20),

                Text(
                  "Fruits",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF438853)),
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

  // Widget buildSwitchIcon(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 20),
  //     child: ElevatedButton(
  //       onPressed: () {
  //         context.read<DiseaseProvider>().toggleServer();
  //       },
  //       style: ElevatedButton.styleFrom(
  //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         backgroundColor: const Color(0xFF438853),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //       ),
  //       child: Selector<DiseaseProvider, bool>(
  //         selector: (_, provider) => provider.offline,
  //         builder: (_, offline, __) => Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(
  //               offline ? Icons.cloud_off_rounded : Icons.cloud_outlined,
  //               color: Colors.white,
  //             ),
  //             const SizedBox(width: 10),
  //             Text(
  //               offline ? "Offline" : "Cloud",
  //               style: const TextStyle(color: Colors.white),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Padding buildHeading() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 20, bottom: 20),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [],
  //     ),
  //   );
  // }

  SizedBox buildMenu1(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MenuItem(
              text: "Upload Image",
              icon: Icons.upload_file_rounded,
              onPressed: () {
                // تحقق إذا كان قد تم تحديد نبتة
                final selectedPlant = context.read<PlantSelectionProvider>().selectedPlant;
                if (selectedPlant == null || selectedPlant.isEmpty) {
                  // إظهار رسالة تنبيه للمستخدم
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please select a plant first!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // إذا تم تحديد نبتة، يمكن اختيار صورة
                  chooseImageFromGallery();
                }
              }),
          const SizedBox(width: 20),
          MenuItem(
              text: "Scan for Disease",
              icon: Icons.camera_enhance_rounded,
              onPressed: () {
                // تحقق إذا كان قد تم تحديد نبتة
                final selectedPlant = context.read<PlantSelectionProvider>().selectedPlant;
                if (selectedPlant == null || selectedPlant.isEmpty) {
                  // إظهار رسالة تنبيه للمستخدم
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please select a plant first!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // إذا تم تحديد نبتة، انتقل إلى شاشة الكاميرا
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CameraScreen(),
                    ),
                  );
                }
              }),
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
                padding: EdgeInsets.all(20),
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF438853) : Colors.white, // تغيير اللون عند التحديد
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  plant.imagePath,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                plant.name,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Color(0xFF438853), // تغيير النص حسب التحديد
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


  // SizedBox buildMenu2(BuildContext context) {
  //   return SizedBox(
  //     height: 180,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         MenuItem(
  //             text: "Latest Fertilizers",
  //             icon: Icons.newspaper,
  //             onPressed: () {
  //               Navigator.of(context).push(
  //                 MaterialPageRoute(
  //                   builder: (context) => const ArchiveScreen(),
  //                 ),
  //               );
  //             }),
  //         const SizedBox(width: 20),
  //         MenuItem(
  //             text: "Feedback",
  //             icon: Icons.question_answer_rounded,
  //             onPressed: () {
  //               Navigator.of(context).push(
  //                 MaterialPageRoute(
  //                   builder: (context) => const   FeedbackScreen(),
  //                 ),
  //               );
  //             }),
  //       ],
  //     ),
  //   );
  // }

  Widget buildPlantTipCard(BuildContext context) {
    final randomTip = context.watch<TipProvider>().randomTip;

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