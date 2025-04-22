import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class AprenderScreen extends StatelessWidget {
  const AprenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aprender')),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text('Elige la palabra correcta', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var word in ['feliz', 'triste', 'enfadada', 'cansada'])
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(150, 50)),
                  onPressed: () {},
                  child: Text(word),
                ),
            ],
          ),
        ],
      ),
    );
  }
}