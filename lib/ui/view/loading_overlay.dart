import 'package:flutter/material.dart';
import 'package:animated_visibility/animated_visibility.dart';

class LoadingOverlay extends StatelessWidget {
  
  final Widget child;
  final bool visible;
  
  const LoadingOverlay({
    super.key, 
    required this.child,
    this.visible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: AnimatedVisibility(
            visible: visible,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(100, 0, 0, 0),
                borderRadius: BorderRadius.circular(12.0,),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}