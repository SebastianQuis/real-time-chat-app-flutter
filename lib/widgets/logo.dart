import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String nameImage;

  const Logo({required this.nameImage}); 
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: size.height * 0.35,
        child: Image(
          image: AssetImage('assets/img/$nameImage.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}