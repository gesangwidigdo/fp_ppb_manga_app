import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthInput extends StatelessWidget {
  const AuthInput({
    super.key,
    required TextEditingController inputController,
    required String labelText,
    TextInputType? inputType,
    Widget? suffixIcon,
    bool obscureText = false,
  }) : _inputType = inputType,
       _labelText = labelText,
       _inputController = inputController,
       _suffixIcon = suffixIcon,
       _obscureText = obscureText;

  final TextEditingController _inputController;
  final String _labelText;
  final TextInputType? _inputType;
  final Widget? _suffixIcon;
  final bool _obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _inputController,
      obscureText: _obscureText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      decoration: InputDecoration(
        labelText: _labelText,
        labelStyle: TextStyle(
          color: Colors.white70,
          fontFamily: GoogleFonts.montserrat().fontFamily,
        ),
        filled: true,
        fillColor: const Color(0xFF2A2E3D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF1D4ED7), width: 2.0),
        ),
        suffixIcon: _suffixIcon,
      ),
      keyboardType: _inputType,
    );
  }
}
