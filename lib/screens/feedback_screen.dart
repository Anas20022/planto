import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:test_1/main_screens.dart';

class FeedbackFormPage extends StatelessWidget {
  const FeedbackFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    return Scaffold(
      appBar: AppBar(
        title: Text('feedback'.tr()),
        backgroundColor: const Color(0xFF508776),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  'feedback_form'.tr(),
                  style: TextStyle(
                    fontSize: 24,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            _buildInputField(
              icon: Icons.person,
              hintText: 'name'.tr(),
              context: context,
            ),
            const SizedBox(height: 30),

            _buildInputField(
              icon: Icons.email,
              hintText: 'email'.tr(),
              context: context,
            ),
            const SizedBox(height: 30),

            _buildInputField(
              icon: Icons.phone,
              hintText: 'mobile_number'.tr(),
              context: context,
            ),
            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor ??
                    Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF508776)),
              ),
              height: 250,
              child: TextField(
                maxLines: null,
                style: TextStyle(color: textColor),
                decoration: InputDecoration.collapsed(
                  hintText: 'your_feedback'.tr(),
                  hintStyle: TextStyle(color: textColor?.withOpacity(0.6)),
                ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: ElevatedButton(

                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: const Color(0xFF508776), width: 3),
                        ),
                        elevation: 24,
                        backgroundColor: Colors.white,
                        title: Center(
                          child: Text(
                            'sent'.tr(),
                            style: TextStyle(
                              color: const Color(0xFF508776),
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        content: Text(
                          'thank_you_feedback'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 16,
                          ),
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),(Route<dynamic> route) => false,
                              );
                            } ,
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF508776),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: Text(
                              'ok'.tr(),
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },


                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF508776),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'submit'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hintText,
    required BuildContext context,
  }) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor ??
            Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          icon: Icon(icon, color: textColor),
          hintText: hintText,
          hintStyle: TextStyle(color: textColor?.withOpacity(0.6)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
//
// class FeedbackFormPage extends StatelessWidget {
//   const FeedbackFormPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Feedback'),
//         backgroundColor: const Color(0xFF508776),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               // color: const Color(0xFF2E7D6D), // أخضر مثل الهيدر
//               padding: const EdgeInsets.symmetric(vertical: 30),
//               child: const Center(
//                 child: Text(
//                   'FEEDBACK FORM',
//                   style: TextStyle(
//                     fontSize: 24,
//                     // color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//
//             // حقل الاسم
//             _buildInputField(
//               icon: Icons.person,
//               hintText: 'Name',
//             ),
//             const SizedBox(height: 30),
//
//             // حقل الإيميل
//             _buildInputField(
//               icon: Icons.email,
//               hintText: 'mail Id',
//             ),
//             const SizedBox(height: 30),
//
//             // حقل رقم الموبايل
//             _buildInputField(
//               icon: Icons.phone,
//               hintText: 'Mobile Number',
//             ),
//             const SizedBox(height: 40),
//
//             // مربع نص كبير للتعليق
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: const Color(0xFF508776)),
//               ),
//               height: 250,
//               child: const TextField(
//                 maxLines: null,
//                 decoration: InputDecoration.collapsed(
//                   hintText: 'Your feedback',
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//
//             // زر الإرسال
//             SizedBox(
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const  Color(0xFF508776),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Submit',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white
//
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputField({required IconData icon, required String hintText}) {
//     return Container(
//       // height: 50,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade300,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           icon: Icon(icon),
//           hintText: hintText,
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
//
// }
//
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// //
// // class FeedbackScreen extends StatelessWidget {
// //   const FeedbackScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Feedback'),
// //         backgroundColor: const Color(0xFF508776),
// //
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.end,
// //           children: [
// //             const Text(
// //               "We'd love to hear from you!",
// //               style: TextStyle(fontSize: 18),
// //             ),
// //             const SizedBox(height: 30),
// //             Stack(
// //               children: [
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     color: Colors.grey[200],
// //                     borderRadius: BorderRadius.circular(35),
// //                   ),
// //                   padding:
// //                   const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
// //                   child: const TextField(
// //                     maxLines: 5,
// //                     decoration: InputDecoration(
// //                       border: InputBorder.none,
// //                       hintText: 'Enter your feedback',
// //                     ),
// //                   ),
// //                 ),
// //                 Positioned(
// //                   right: 10,
// //                   bottom: 10,
// //                   child: Container(
// //                     decoration: const BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       color: Colors.blueGrey,
// //                     ),
// //                     child: IconButton(
// //                       icon: const Icon(Icons.send, color: Colors.white),
// //                       onPressed: () {
// //                         // Handle send action
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
