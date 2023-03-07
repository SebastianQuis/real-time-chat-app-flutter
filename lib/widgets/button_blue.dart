import 'package:flutter/material.dart';

class ButtonBlue extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ButtonBlue({
    required this.onPressed, 
    required this.text
  });


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPressed,
      child: Text(this.text, style: TextStyle(fontSize: 16),),
      style: ElevatedButton.styleFrom( 
        shape: StadiumBorder(), 
        minimumSize: Size(double.infinity, 45)
      ),
    );
  }
}