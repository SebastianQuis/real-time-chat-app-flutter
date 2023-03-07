import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:real_time_chat_app/models/usuario.dart';
 
class UsuariosPage extends StatefulWidget {

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  
  final usuarios = [
    Usuario(uid: '1', name: 'Sebastian', email: 'test1@gmail.com', online: true),
    Usuario(uid: '2', name: 'Susana', email: 'test2@gmail.com', online: false),
    Usuario(uid: '3', name: 'Frances', email: 'test3@gmail.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Sebastian', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54,), 
          onPressed: () { 
            // TODO: Cerrar sesión
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[600],),
            // child: Icon(Icons.offline_bolt, color: Colors.red),
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
    await Future.delayed(Duration(milliseconds: 1000));
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
        child: Text(usuario.name!.substring(0,2)),
        backgroundColor: Colors.blue[100],
      ),
      title: Text(usuario.name!),
      subtitle: Text(usuario.email!),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: usuario.online! ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}