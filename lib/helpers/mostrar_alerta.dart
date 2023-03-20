import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


mostrarAlerta( BuildContext context, String titulo, String descripcion){

  if( !Platform.isAndroid ) {
    return showDialog(
      context: context, 
      builder: (context) => 
        AlertDialog(
          title: Text(titulo),
          content: Text(descripcion),
          // backgroundColor: Colors.grey,
          actions: [
            MaterialButton(
              child: Text('Ok'),
              onPressed: () => Navigator.pop(context),
              elevation: 5,
              textColor: Colors.blue,
            )
          ],
        )
    );
  } 
    
  showCupertinoDialog(
    context: context, 
    builder: (context) {
      return CupertinoAlertDialog(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(titulo)),
        content: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric( vertical: 8 ),
            child: Text(descripcion, style: TextStyle( fontSize: 14),),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            textStyle: TextStyle(color: Colors.lightBlue),
            onPressed: () => Navigator.pop(context),
            isDefaultAction: true,
            child: Text('Ok'),
          )
        ],
      );
    },
  );
  

}