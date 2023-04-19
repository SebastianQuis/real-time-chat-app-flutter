import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:real_time_chat_app/services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  
  final String uid;
  final String text;
  final String? time;
  final AnimationController animationController;

  ChatMessage({
    required this.uid,
    required this.text, 
    required this.animationController, 
    this.time, 
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition( // animation with opacity
      opacity: animationController,
      child: SizeTransition( // transformar tamaño del widget
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.bounceIn),
        child: Container(
          child: uid == authService.usuario.uid // usuario logeado  
            ? _myMessage()
            : _myNotMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only( top: 5, right: 5, left: 50, bottom: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(20)
            ),
            child: Text(this.text,)
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            // color: Colors.red,
            child: Text(time?? 'cargando..', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
          )
        ],
      ),
    );
  }

  Widget _myNotMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only( top: 5, right: 50, left: 5, bottom: 5 ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.circular(20)
            ),
            child: Text(this.text)
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            // color: Colors.red,
            child: Text(time ?? 'cargando..', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
          ),
        ],
      ),
    );
  }
}