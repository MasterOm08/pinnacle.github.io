import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test1/screens/auth_screen.dart'; // Make sure this import is correct

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text("My Progress"), 
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // --- HEADER SECTION ---
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 35, 
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 40, color: Colors.white)
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? "Student", 
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                    ),
                    Text(
                      user?.email ?? "", 
                      style: TextStyle(color: Colors.grey[600])
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft, 
              child: Text("Recent Quizzes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ),
          ),

          // --- QUIZ HISTORY LIST ---
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user_stats')
                  .where('userId', isEqualTo: user?.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No quiz history yet."));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          child: Text("${data['percentage']}%", style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(data['topic'] ?? "Quiz"),
                        subtitle: Text(data['category'] ?? ""),
                        trailing: Text("${data['score']}/${data['total']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // --- LOGOUT BUTTON SECTION ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  // This clears the navigation stack so the user can't "Go Back" into the app
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}