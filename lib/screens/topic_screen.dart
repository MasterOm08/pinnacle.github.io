import 'package:flutter/material.dart';
import 'package:flutter_test1/screens/question_screen.dart';

class TopicScreen extends StatelessWidget {
  final String category;

  const TopicScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // List of topics for Mathematics
    final List<Map<String, dynamic>> topics = [
      {'name': 'Arithmetic', 'icon': Icons.add_rounded, 'color': Colors.blue},
      {'name': 'Geometry', 'icon': Icons.category_rounded, 'color': Colors.purple},
      {'name': 'Fractions', 'icon': Icons.pie_chart_rounded, 'color': Colors.orange},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text("$category Topics", style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select a Challenge",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Choose a topic to start your practice",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 25),
            
            // --- TOPIC GRID ---
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.85, // Adjusts the height/width of cards
                ),
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return _buildTopicCard(
                    context,
                    title: topics[index]['name'],
                    icon: topics[index]['icon'],
                    color: topics[index]['color'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, 
      {required String title, required IconData icon, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuestionScreen(
                  category: category,
                  topic: title,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Circle
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 40),
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "5 Questions",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}