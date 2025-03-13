import 'package:flutter/material.dart';

class FormElementWrapper extends StatelessWidget {

  final Widget child;

  const FormElementWrapper({super.key, required this.child,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0,),
      child: child,
    );
  }
}