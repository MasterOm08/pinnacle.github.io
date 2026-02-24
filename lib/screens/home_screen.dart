import 'package:flutter/material.dart';
import 'package:flutter_test1/screens/math_screen.dart';
import 'package:flutter_test1/screens/science_screen.dart';
import 'package:flutter_test1/screens/english_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "PadhoPlay",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Choose a Subject",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              children: [

                SubjectCard(
                  title: "Math",
                  icon: Icons.calculate,
                  gradient: const [
                    Color(0xFF4FACFE),
                    Color(0xFF00F2FE)
                  ],
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MathScreen(),
                      ),
                    );
                  },
                ),

                SubjectCard(
                  title: "Science",
                  icon: Icons.science,
                  gradient: const [
                    Color(0xFF43E97B),
                    Color(0xFF38F9D7)
                  ],
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScienceScreen(),
                      ),
                    );
                  },
                ),

                SubjectCard(
                  title: "English",
                  icon: Icons.menu_book,
                  gradient: const [
                    Color(0xFFFF758C),
                    Color(0xFFFF7EB3)
                  ],
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EnglishScreen(),
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// ULTRA MODERN SUBJECT CARD
////////////////////////////////////////////////////////////

class SubjectCard extends StatefulWidget {

  final String title;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const SubjectCard({
    super.key,
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {

  double scale = 1.0;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),

        child: Material(
          borderRadius: BorderRadius.circular(24),
          elevation: 6,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),

            onTap: widget.onTap,

            onHighlightChanged: (value) {
              setState(() {
                scale = value ? 0.96 : 1.0;
              });
            },

            child: Ink(
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: widget.gradient,
                ),
              ),

              child: Row(
                children: [

                  const SizedBox(width: 20),

                  Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 32,
                  ),

                  const SizedBox(width: 20),

                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}