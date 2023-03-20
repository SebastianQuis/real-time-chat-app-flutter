import 'package:flutter/material.dart';

class ButtonBlue extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const ButtonBlue({
    required this.onPressed, 
    required this.text
  });


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom( 
        shape: StadiumBorder(), 
        minimumSize: Size(double.infinity, 45)
      ),
      child: Text(text, style: const TextStyle(fontSize: 16),),
    );
  }
}