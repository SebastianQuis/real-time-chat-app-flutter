import 'package:flutter/material.dart';
import 'package:real_time_chat_app/global/environment.dart';

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

  get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() { // package socket io client - example
    _socket = IO.io( Environment.socketUrl,{
      'transports' : ['websocket'],
      'autoConnect': true,
      'forceNew'   : true
    });
    _socket.on( 'connect' , (_) {
      // print('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
      // socket.emit('msg', 'test');
    });
    // socket.on('event', (data) => print(data));

    _socket.on( 'disconnect' , (_) {
      // print('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    // socket.on('fromServer', (_) => print(_));
  }

  void disconnect(){ // salir del servidor
    _socket.disconnect();
  }

}