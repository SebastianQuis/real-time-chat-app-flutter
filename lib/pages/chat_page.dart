import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 
class ChatPage extends StatefulWidget {
 
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

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
                itemBuilder: (context, i) => Text('$i'),
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
                onChanged: (value) {
                  // TODO: verificar valor por enviar
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
                  child: Text('Enviar'), 
                  onPressed: () {
                    
                  }
                )
                : IconButton(
                  icon: Icon(Icons.send, color: Colors.blue,),
                  onPressed: () {},
                ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit( String texto) { // enviar entrega
    print(texto);
    _textController.clear(); // borrar el textController cada vez que se envie
    _focusNode.requestFocus(); // no se baje el teclado
  }
}