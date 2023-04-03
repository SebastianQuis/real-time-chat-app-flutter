import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:real_time_chat_app/routes/routes.dart';
import 'package:real_time_chat_app/services/auth_service.dart';
import 'package:real_time_chat_app/services/chat_service.dart';
import 'package:real_time_chat_app/services/socket_service.dart';

void main() => runApp( MyApp() );

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_) => AuthService() ),
        ChangeNotifierProvider( create: (_) => SocketService() ),
        ChangeNotifierProvider( create: (_) => ChatService() ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Real time chat app - Flutter',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}