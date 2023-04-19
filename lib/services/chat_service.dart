import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:real_time_chat_app/global/environment.dart';
import 'package:real_time_chat_app/models/mensajes_response.dart';
import 'package:real_time_chat_app/models/usuario.dart';
import 'package:real_time_chat_app/services/auth_service.dart';

class ChatService with ChangeNotifier {

  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat( String usuarioID ) async {
    try {
      final mensajes = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID');
    
      final response = await http.get(mensajes, 
        headers: {
          'x-token': await AuthService.getToken()
        }
      );
      final mensajesResponse = mensajesResponseFromJson(response.body);
      return mensajesResponse.mensajes;
    } catch (e) {
      return [];
    }    
  }
}
