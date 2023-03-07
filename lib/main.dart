import 'package:flutter/material.dart';

import 'package:real_time_chat_app/routes/routes.dart';

void main() => runApp( MyApp() );

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      initialRoute: 'users',
      routes: appRoutes,
    );
  }
}