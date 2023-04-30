import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_Controller.dart';

class MyDrawer extends StatelessWidget {
   final controller = Get.put(AuthController());
  final accountName,accountEmail,imageUrl;
   MyDrawer({super.key,required this.accountEmail,required this.accountName,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
     Size _size = MediaQuery.of(context).size;
    return Drawer(
      width: _size.width>600 ? _size.width *0.21: _size.width*0.4,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(child: Image.network(imageUrl)),
            accountName: Text(accountName), accountEmail: Text(accountEmail),),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(onPressed: (){
                controller.logout();
              }, child: Text("Log out")),
            )
        ],
      ),
    );
  }
}