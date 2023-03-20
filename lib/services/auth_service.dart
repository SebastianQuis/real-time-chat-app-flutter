import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:real_time_chat_app/global/environment.dart';
import 'package:real_time_chat_app/models/login_response.dart';
import 'package:real_time_chat_app/models/usuario.dart';


class AuthService with ChangeNotifier{

  late Usuario usuario;

  Future login( String email, String password ) async {
    
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
    // print(resp.body);

    if ( resp.statusCode == 200 ) { // success
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      print(usuario.uid);
    }
  }


}