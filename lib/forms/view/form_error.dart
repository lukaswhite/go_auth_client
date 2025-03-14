import 'package:flutter/material.dart';

class FormError extends StatelessWidget {
  
  final String message;

  const FormError({super.key, required this.message,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0,),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16.0,),
        ),
        padding: const EdgeInsets.all(12.0,),
        child: Center(
          child: Text(message, style: const TextStyle(color: Colors.white,)),
        ),
      ),
    );
  }
}