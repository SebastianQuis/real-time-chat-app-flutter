import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat_app/widgets/chat_message.dart';
 
class ChatPage extends StatefulWidget {
 
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin { // vsync this


  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWriting = false;

  List<ChatMessage> _messages =  [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              child: Text('Se', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
            ),

            SizedBox(width: 10),

            Text('Sebastian Flores', style: TextStyle(fontSize: 17, color: Colors.black54)),

          ],
        ),
        elevation: 1,
      ),

      body: Container(
        // padding: EdgeInsets.symmetric( horizontal: 10 ),
        child: Column(
          children: [

            Flexible( // flexibilidad, si no error con listview.builder
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (context, i) => _messages[i],
                reverse: true, // de abajo hacia arriba
              ),
            ),

            Divider( height: 2),

            Container(
              color: Colors.white,
              height: 50,
              child: _inputChat(),
            )

          ],
        ),
      ),
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit, // enviar entrega
                onChanged: (text) {
                  setState(() {
                    text.trim().isNotEmpty ? _isWriting = true : _isWriting = false;
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              )
            ),

            Container(
              margin: EdgeInsets.symmetric( horizontal: 4 ),
              child: Platform.isIOS
                ? CupertinoButton(
                  onPressed: _isWriting
                    ? () => _handleSubmit( _textController.text.trim() )
                    : null,
                  child: const Text('Enviar'))
                : IconTheme(
                  data: IconThemeData( color: Colors.blue ),
                  child: IconButton(
                    highlightColor: Colors.transparent, // efecto splash en transparente
                    splashColor: Colors.transparent, // efecto splash en transparente
                    icon: Icon(Icons.send),
                    onPressed: _isWriting
                      ? () => _handleSubmit( _textController.text.trim() ) 
                      : null)
                ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit( String texto) { // enviar entrega
    if( texto.trim().isEmpty ) return;

    // print(texto);
    _textController.clear(); // borrar el textController cada vez que se envie
    _focusNode.requestFocus(); // no se baje el teclado

    final newMessage = ChatMessage(
      uid: '123', 
      text: texto, 
      animationController: AnimationController(
        vsync: this,
        duration: Duration( milliseconds: 500 ),
      ),
    );

    _messages.insert(0, newMessage );

    newMessage.animationController.forward(); // play a la animation

    setState(() {
      _isWriting = false; 
    });
  }

  @override
  void dispose() {
    // TODO: cancelar listen del socket

    // TODO: limpiar instancias que se tiene en el arreglo de mensajes
    for( ChatMessage message in _messages ) {
      message.animationController.dispose();
    }
    
    super.dispose();
  }
}