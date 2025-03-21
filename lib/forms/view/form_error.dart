import 'package:flutter/material.dart';

typedef FormErrorFooterBuilder = Widget Function();

class FormError extends StatelessWidget {
  
  final String message;
  final FormErrorFooterBuilder? footerBuilder;
  
  const FormError({
    super.key, 
    required this.message,
    this.footerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0,),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(12.0,),
        ),
        padding: const EdgeInsets.all(12.0,),
        child: Center(
          child: Column(
            children: [
              Text(message, style: TextStyle(color: Theme.of(context).colorScheme.onError,)),
              if (footerBuilder != null) ...[
                const SizedBox(height: 10.0,),
                footerBuilder!(),
              ]
            ],
          ),
        ),
      ),
    );
  }
}