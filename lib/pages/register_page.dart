import 'package:flutter/material.dart';

import 'package:real_time_chat_app/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
 
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
                nameImage: 'register',
              ),
              
              _Form(),
              
              Labels(
                routeNavigator: 'login', 
                text: '¿Ya tienes una cuenta?', 
                blueText: 'Ingresar cuenta',
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only( top: 30 ),
      padding: EdgeInsets.symmetric(horizontal: 40 ),
      width: double.infinity,
      height: 260,
      // color: Colors.red,
      child: Column(
        children: [

          CustomInput(
            hintText: 'Email', 
            icon: Icon(Icons.perm_identity), 
            keyboardType: TextInputType.text, 
            textController: nameController,
          ),
          
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
            text: 'Registrar',
            onPressed: (){
              print(this.emailController.text);
              print(this.passwordController.text);
            }, 
          ),

        ]
      ),
    );
  }
}

