import 'package:flutter/material.dart';
import 'package:go_auth_client/http/responses/responses.dart';

class FormValidationError extends StatelessWidget {
  
  final ValidationError error;
  
  const FormValidationError({super.key, required this.error,});

  @override
  Widget build(BuildContext context) {
    return Text(error.errorDescription);
  }
}