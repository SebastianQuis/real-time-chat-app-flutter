import 'package:flutter/material.dart';
import 'package:real_time_chat_app/global/environment.dart';
import 'package:real_time_chat_app/services/auth_service.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;



// TODO: estado de la comunicación online-offline-connecting

enum ServerStatus { // enumeracion de propiedades
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() async { // package socket io client - example
    
    final token = await AuthService.getToken(); // obtener token
    
    _socket = IO.io( Environment.socketUrl,{
      'transports'   : ['websocket'],
      'autoConnect'  : true,
      'forceNew'     : true,
      'extraHeaders' : {
        'x-token' : token // enviar token
      }
    });
    _socket.on( 'connect' , (_) {
      _serverStatus = ServerStatus.Online;
      print(_serverStatus);

      notifyListeners();
      // socket.emit('msg', 'test');
    });
    // socket.on('event', (data) => print(data));

    _socket.on( 'disconnect' , (_) {
      // print('disconnect');
      _serverStatus = ServerStatus.Offline;
      print(_serverStatus);
      notifyListeners();
    });
    // socket.on('fromServer', (_) => print(_));
  }

  void disconnect(){ // salir del servidor
    _socket.disconnect();
  }

}