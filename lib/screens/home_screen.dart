import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test1/screens/topic_screen.dart';
import 'package:flutter_test1/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? "Student";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text("PadhoPlay", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.blueAccent, size: 30),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, $displayName!", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text("What would you like to learn today?", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 30),

            const Text("Subjects", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            _buildSubjectCard(
              context,
              title: "Mathematics",
              subtitle: "Algebra, Geometry & Arithmetic",
              icon: Icons.calculate_rounded,
              color: Colors.orange,
            ),
            const SizedBox(height: 15),
            
            _buildSubjectCard(
              context,
              title: "Science",
              subtitle: "Biology, Physics & Chemistry",
              icon: Icons.science_rounded,
              color: Colors.green,
            ),
            const SizedBox(height: 15),

            // ENGLISH IS BACK
            _buildSubjectCard(
              context,
              title: "English",
              subtitle: "Grammar, Vocab & Literature",
              icon: Icons.menu_book_rounded,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, {
    required String title, 
    required String subtitle, 
    required IconData icon, 
    required Color color
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
        onTap: () {
          // This passes the "title" (e.g. "English") to the TopicScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TopicScreen(category: title)),
          );
        },
      ),
    );
  }
}