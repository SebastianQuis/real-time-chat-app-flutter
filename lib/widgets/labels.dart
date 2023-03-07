import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String routeNavigator;
  final String text;
  final String blueText;

  const Labels({
    required this.routeNavigator, 
    required this.text, 
    required this.blueText
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(this.text, 
            style: TextStyle( color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w400),
          ),
          SizedBox( height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, routeNavigator);
            },
            child: Text(blueText, 
              style: TextStyle( color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ]
      ),
    );
  }
}