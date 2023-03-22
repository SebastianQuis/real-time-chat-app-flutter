import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:real_time_chat_app/helpers/mostrar_alerta.dart';
import 'package:real_time_chat_app/services/auth_service.dart';
import 'package:real_time_chat_app/services/socket_service.dart';
import 'package:real_time_chat_app/widgets/widgets.dart';


class LoginPage extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Logo(
                nameImage: 'login',
              ),
              
              _Form(),
              
              Labels(
                routeNavigator: 'register', 
                text: '¿No tienes una cuenta?', 
                blueText: 'Crear cuenta',
              ),
              
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: const Text('Terminos y condiciones de uso', 
                  style: TextStyle( 
                    color: Colors.black45, 
                    fontWeight: FontWeight.w500),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}

class _Form extends StatefulWidget {

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      // margin: EdgeInsets.only( top: 30 ),
      padding: EdgeInsets.symmetric(horizontal: 40 ),
      width: double.infinity,
      height: 200,
      // color: Colors.red,
      child: Column(
        children: [

          CustomInput(
            hintText: 'Email', 
            icon: Icon(Icons.email_outlined), 
            keyboardType: TextInputType.emailAddress, 
            textController: emailController,
          ),

          CustomInput(
            hintText: 'Password',  
            icon: Icon(Icons.lock_outlined),  
            isPassword: true, 
            textController: passwordController,
          ),
          
          ButtonBlue(
            text: 'Ingresar',
            onPressed: authService.autenticando 
              ? null // bloqueando el button
              : () async { 
                FocusScope.of(context).unfocus(); 
                final isLogged = await authService.login(emailController.text.trim(), passwordController.text.trim()); 

                if ( isLogged ) {
                  socketService.connect();
                  Navigator.pushReplacementNamed(context, 'users'); 
                } else {
                  mostrarAlerta(context, 'Login incorrecto', 'Verificar sus credenciales de ingreso.'); 
                }
              }
          ),

        ]
      ),
    );
  }
}

