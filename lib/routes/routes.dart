import 'package:flutter/material.dart';

import 'package:real_time_chat_app/pages/pages.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {

  'users'   : (_) => UsuariosPage(),
  'register': (_) => RegisterPage(),
  'login'   : (_) => LoginPage(),
  'loading' : (_) => LoadingPage(),
  'chat'    : (_) => ChatPage(),

};