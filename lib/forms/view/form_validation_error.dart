import 'package:flutter/material.dart';
import 'package:go_auth_client/http/responses/responses.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class FormValidationError extends StatelessWidget {
  
  final ValidationError error;
  
  const FormValidationError({super.key, required this.error,});

  @override
  Widget build(BuildContext context) {
    return Text(error.errorDescription, style: TextStyle(color: Theme.of(context).colorScheme.error,));
  }
}