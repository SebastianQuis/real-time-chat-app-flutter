import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';


// TODO: estado de la comunicación online-offline-connecting

enum ServerStatus { // enumeracion de propiedades
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;

  get serverStatus => this._serverStatus;

  SocketService(){
    this._initConfig();
  }

  void _initConfig() { // package socket io client - example
    IO.Socket socket = IO.io('http://192.168.1.10:3000/',{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.onConnect( (_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
      // socket.emit('msg', 'test');
    });
    // socket.on('event', (data) => print(data));

    socket.onDisconnect( (_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    // socket.on('fromServer', (_) => print(_));
  }

}