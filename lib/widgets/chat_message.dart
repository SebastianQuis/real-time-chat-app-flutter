import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  
  final String uid;
  final String text;
  final AnimationController animationController;

  ChatMessage({
    required this.uid,
    required this.text, 
    required this.animationController, 
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition( // animation with opacity
      opacity: animationController,
      child: SizeTransition( // transformar tamaño del widget
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.bounceIn),
        child: Container(
          child: this.uid == '123' 
            ? _myMessage()
            : _myNotMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only( top: 5, right: 5, left: 50, bottom: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text(this.text,)
      ),
    );
  }

  Widget _myNotMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only( top: 5, right: 50, left: 5, bottom: 5 ),
        padding: EdgeInsets.all(10),
        child: Text(this.text),
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(20)
        )
      ),
    );
  }
}