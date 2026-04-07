
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';

Widget buildTextField(String hint,IconData icon, {required TextEditingController controller,String? errorText,bool isObscure = false,VoidCallback? onToggle,}) {
  return TextField(
    
    obscureText: isObscure,
    controller: controller,
    
    decoration: InputDecoration(
      hintText: hint,
      errorText: errorText,
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon, color: secondary.withValues(alpha: 0.6)), 
      suffixIcon: hint == "Password" 
          ? IconButton(
              icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
              onPressed: onToggle, // This triggers the toggle logic
            )
          : null,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondary.withValues(alpha:0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondary.withValues(alpha:0.5)),
      ),
            focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondary),
      ),
    ),
  );
}