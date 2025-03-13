import 'package:flutter/material.dart';
import 'package:go_auth_client/http/responses/responses.dart';
import 'form_validation_error.dart';

class FormValidationErrors extends StatelessWidget {

  final List<ValidationError> errors;

  const FormValidationErrors({super.key, required this.errors,});

  @override
  Widget build(BuildContext context) {
    if(errors.isEmpty) {
      return const SizedBox();
    }
    return Column(children: errors.map((error) => FormValidationError(error: error)).toList());
  }
}
