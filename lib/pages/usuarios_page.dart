import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:real_time_chat_app/models/usuario.dart';
import 'package:real_time_chat_app/pages/login_page.dart';
import 'package:real_time_chat_app/services/auth_service.dart';
import 'package:real_time_chat_app/services/socket_service.dart';
import 'package:real_time_chat_app/services/usuarios_service.dart';
 
class UsuariosPage extends StatefulWidget {

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuarioService = UsuariosService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  
  List<Usuario> usuarios = [];

  // final usuarios = [
  //   Usuario(uid: '1', nombre: 'Sebastian', email: 'test1@gmail.com', online: true),
  //   Usuario(uid: '2', nombre: 'Susana', email: 'test2@gmail.com', online: false),
  //   Usuario(uid: '3', nombre: 'Frances', email: 'test3@gmail.com', online: true),
  // ];

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<AuthService>(context).getUsuario;
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(usuario.nombre, style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Color(0xffc1121f),), 
          onPressed: ()  { 
            socketService.disconnect();

            AuthService.deleteToken(); // sin provider porque es metodo estatico
            Navigator.pushReplacement(context, 
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoginPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
                  return FadeTransition(
                    opacity: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 300)
              )
            );
            
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ( socketService.socket.connected)
              ? Icon(Icons.check_circle, color: Colors.blue[600],)
              : Icon(Icons.offline_bolt, color: Colors.red)
          )
        ],
      ),

      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(
          complete: Icon( Icons.check_circle, color: Colors.blue[600],),
          waterDropColor: Colors.blue,
        ),
        onRefresh: _loadUsers,
        child: _listViewUsers(),
      )
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _UserListTile(usuario: usuarios[i]), 
      separatorBuilder: (_, i) => Divider(), 
      itemCount: usuarios.length, 
    );
  }

  _loadUsers() async {
    
    this.usuarios = await usuarioService.getUsuarios();
    setState(() {});
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    
    _refreshController.refreshCompleted();
  }

}

class _UserListTile extends StatelessWidget {
  final Usuario usuario;

  const _UserListTile({ required this.usuario});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0,2)),
        backgroundColor: Colors.blue[100],
      ),
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: usuario.online ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}