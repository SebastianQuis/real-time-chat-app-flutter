import 'package:flutter/material.dart';


class CustomInput extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final TextEditingController textController;
  final TextInputType? keyboardType;
  final bool? isPassword;

  CustomInput({ 
    required this.hintText, 
    required this.icon, 
    required this.textController,
    this.keyboardType = TextInputType.text, 
    this.isPassword = false, 
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only( right: 20),
      margin: EdgeInsets.only( bottom: 20 ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow( color: Colors.black45, offset: Offset(0, 2), blurRadius: 3)
        ]
      ),
      child: TextField(
        controller: textController,
        autocorrect: false,
        keyboardType: keyboardType,
        obscureText: isPassword!,
        decoration: InputDecoration(
          prefixIcon: icon,
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: hintText,
        ),
      )
    );
  }
}