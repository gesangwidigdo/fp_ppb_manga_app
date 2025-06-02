import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fp_ppb_manga_app/components/auth_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String _errorCode = "";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void navigateLogin() {
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, 'login');
  }

  void register() async {
    setState(() {
      _isLoading = true;
      _errorCode = "";
    });

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorCode = "Password does not match";
      });
      _isLoading = false;
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      final uid = userCredential.user!.uid;

      // Save username to Firebase
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': _emailController.text.trim(),
        'username': _usernameController.text.trim(),
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'profilePicture': '', // Placeholder for profile picture URL
      });

      navigateLogin();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorCode = e.code;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202939),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(Icons.image, size: 80, color: Colors.white54),
              ),
              const SizedBox(height: 48.0),
              AuthInput(
                inputController: _emailController,
                labelText: 'Email',
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              AuthInput(
                inputController: _usernameController,
                labelText: 'Username',
                inputType: TextInputType.text,
              ),
              const SizedBox(height: 16.0),
              AuthInput(
                inputController: _passwordController,
                labelText: 'Password',
                inputType: TextInputType.visiblePassword,
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              AuthInput(
                inputController: _confirmPasswordController,
                labelText: 'Confirm Password',
                inputType: TextInputType.visiblePassword,
                obscureText: !_isConfirmPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24.0),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D4ED7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ),
              if (_errorCode.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Error: $_errorCode',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      navigateLogin();
                    },
                    child: Text(
                      'Login here',
                      style: TextStyle(
                        color: const Color(0xFF1D4ED7),
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
