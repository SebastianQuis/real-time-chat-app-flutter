import 'package:http/http.dart' as http;

import 'package:real_time_chat_app/global/environment.dart';
import 'package:real_time_chat_app/models/usuario.dart';
import 'package:real_time_chat_app/models/usuarios_response.dart';
import 'package:real_time_chat_app/services/auth_service.dart';

class UsuariosService {

  Future<List<Usuario>> getUsuarios() async {
    try {
      final usuarios = Uri.parse( '${Environment.apiUrl}/usuarios' );
      final resp = await http.get( usuarios,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );

      // print(resp.body);
      final usuarioResponse = usuariosResponseFromJson(resp.body);
      return usuarioResponse.usuarios;
      
    } catch (e) {
      
      return [];
    }
  }

}