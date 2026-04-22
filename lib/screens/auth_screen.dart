import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test1/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  String _email = '';
  String _password = '';
  String _username = ''; 

  Future<void> _submitAuthForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: _email.trim(),
          password: _password.trim(),
        );
      } else {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email.trim(),
          password: _password.trim(),
        );
        await userCredential.user!.updateDisplayName(_username.trim());
      }
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication failed'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.auto_stories_rounded, size: 80, color: Colors.blueAccent),
                const SizedBox(height: 10),
                const Text("PadhoPlay", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(height: 40),

                if (!_isLogin) ...[
                  TextFormField(
                    key: const ValueKey('username'),
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    validator: (val) => val!.isEmpty ? "Please enter your name" : null,
                    onSaved: (val) => _username = val!,
                  ),
                  const SizedBox(height: 20),
                ],

                TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  validator: (val) => !val!.contains('@') ? "Invalid email" : null,
                  onSaved: (val) => _email = val!,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  key: const ValueKey('password'),
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  validator: (val) => val!.length < 6 ? "Minimum 6 characters" : null,
                  onSaved: (val) => _password = val!,
                ),
                const SizedBox(height: 30),

                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submitAuthForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(_isLogin ? "Login" : "Create Account", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),

                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin ? "New student? Sign Up" : "Already registered? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}