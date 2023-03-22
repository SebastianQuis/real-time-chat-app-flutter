import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:real_time_chat_app/pages/login_page.dart';
import 'package:real_time_chat_app/pages/usuarios_page.dart';
import 'package:real_time_chat_app/services/auth_service.dart';
import 'package:real_time_chat_app/services/socket_service.dart';
 
class LoadingPage extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: FutureBuilder(
        future: checkLogginState(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
            child: Text('Cargando...'),
          );
        },
      ),
    );
  }

  Future checkLogginState( BuildContext context ) async{
    final authService = Provider.of<AuthService>(context, listen:  false);
    final socketService = Provider.of<SocketService>(context, listen:  false);
    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      socketService.connect();
      
      // Navigator.pushReplacementNamed(context, 'users');
      
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UsuariosPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
            return FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 1000)
        )
      );
    
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOut);
            return FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 1000)
        )
      );
    }
  }
}