import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:real_time_chat_app/global/environment.dart';

import 'package:real_time_chat_app/models/login_response.dart';
import 'package:real_time_chat_app/models/usuario.dart';


class AuthService with ChangeNotifier{

  late Usuario usuario;
  bool _autenticando = false;
  final _storage = FlutterSecureStorage();

  Usuario get getUsuario => this.usuario;

  bool get autenticando => _autenticando;
  set autenticando( bool value ) {
    _autenticando = value;
    notifyListeners();
  }

  // leer el token
  static Future<String> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token!;
  } 
  
  // eliminar el token
  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  } 

  Future<bool> login( String email, String password ) async {
    autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final login = Uri.parse( '${Environment.apiUrl}/login' );
    final resp = await http.post( login,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    print(resp.body);
    autenticando = false;

    if ( resp.statusCode == 200 ) { // success
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      // print(usuario.uid);

      // TODO: save token jwt
      await guardarToken( loginResponse.token );
      
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> register( String nombre, String email, String password ) async {
    this.autenticando = true;

    final data = {
      'nombre'   : nombre,
      'email'    : email,
      'password' : password,
    };
    
    final register = Uri.parse( '${Environment.apiUrl}/login/new' );
    
    final resp = await http.post( register,
      body: jsonEncode(data),
      headers: { 'Content-Type': 'application/json' }
    );

    print(resp.body);
    this.autenticando = false;

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await guardarToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['message'] ?? respBody['ok'];
      // return false;
    }

  }

  Future<bool> isLoggedIn() async{
    final token = await _storage.read(key: 'token');
    final renew = Uri.parse( '${Environment.apiUrl}/login/renew' );
    
    final resp = await http.get( renew,
      headers: { 
        'Content-Type': 'application/json',
        'x-token': token ?? 'no token'
      }
    );

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }  
  
  Future guardarToken( String token ) async { // escribiendo el token
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }

}
