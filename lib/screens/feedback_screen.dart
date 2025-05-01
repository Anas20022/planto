import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              "We'd love to hear from you!",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(35),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: const TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your feedback',
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        // Handle send action
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
