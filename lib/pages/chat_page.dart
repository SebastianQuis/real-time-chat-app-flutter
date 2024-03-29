import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:real_time_chat_app/models/mensajes_response.dart';

import 'package:real_time_chat_app/services/auth_service.dart';
import 'package:real_time_chat_app/services/chat_service.dart';
import 'package:real_time_chat_app/services/socket_service.dart';
import 'package:real_time_chat_app/widgets/chat_message.dart';
 
class ChatPage extends StatefulWidget {
 
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin { // vsync this
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late AuthService authService;
  late SocketService socketService;

  List<ChatMessage> _messages =  [];
  bool _isWriting = false;

  @override
  void initState() {
    super.initState();
    chatService   = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService   = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarMensajes(chatService.usuarioPara.uid);
  }

  void _cargarMensajes( String usuarioID ) async {
    

    List<Mensaje> chat = await chatService.getChat(usuarioID);
    print(chat);

    final history = chat.map((m) => ChatMessage(
      uid: m.de, 
      text: m.mensaje, 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward(), 
      time: m.createdAt.minute.toString().length == 1
        ? '${m.createdAt.hour}:0${m.createdAt.minute}'
        : '${m.createdAt.hour}:${m.createdAt.minute}',
    ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje( dynamic payload ) {
    print( payload['mensaje'] ); // escuchando el mensaje que emite el servidor

    ChatMessage message = ChatMessage(
      uid: payload['de'], 
      text: payload['mensaje'], 
      animationController: AnimationController(vsync: this, duration: Duration( milliseconds: 400 )),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();

  }

  @override
  Widget build(BuildContext context) {
    // final chatService = Provider.of<ChatService>(context);
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
              child: Text(usuarioPara.nombre.substring(0,2), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(width: 10),

            Text(usuarioPara.nombre, style: const TextStyle(fontSize: 17, color: Colors.black54)),

          ],
        ),
        elevation: 1,
      ),

      body: Container(
        child: Column(
          children: [

            Flexible( // flexibilidad, si no error con listview.builder
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (context, i) => _messages[i], // retorna un widget mymessage - mynotmessage
                reverse: true, // scroll de abajo hacia arriba
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
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            
            Flexible( // extienda todo lo necesario
              child: TextField(
                controller: _textController,
                autocorrect: false,
                onSubmitted: _handleSubmit, // enviar entrega
                onChanged: (text) {
                  setState(() {
                    text.trim().isNotEmpty ? _isWriting = true : _isWriting = false;
                  });
                },
                decoration: InputDecoration.collapsed( // no incluye borde por defecto
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              )
            ),

            Container(
              margin: const EdgeInsets.symmetric( horizontal: 4 ),
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
    _focusNode.requestFocus(); // no se baje el teclado una vez envie el texto

    final newMessage = ChatMessage( // nuevo mensaje
      uid: authService.usuario.uid, // usuario que crea el mensaje
      text: texto, 
      animationController: AnimationController(
        vsync: this,
        duration: Duration( milliseconds: 500 ),
      ),
    );

    _messages.insert(0, newMessage ); // insertando en la pos[0] el nuevo mensaje

    newMessage.animationController.forward(); // play a la animation

    setState(() { _isWriting = false; });

    socketService.emit('mensaje-personal',{
      'de'     : authService.usuario.uid,
      'para'   : chatService.usuarioPara.uid,
      'mensaje': texto
    });
  
  }

  @override
  void dispose() {
    // TODO: cancelar listen del socket

    // TODO: limpiar instancias que se tiene en el arreglo de mensajes
    for( ChatMessage message in _messages ) {
      message.animationController.dispose();
    }

    socketService.socket.off('mensaje-personal');
    
    super.dispose();
  }
}