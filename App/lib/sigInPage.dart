import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_app/controllers/auth_Controller.dart';

import 'mydrawer.dart';

class SignInPage extends StatelessWidget {
  
  SignInPage({super.key});
  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
     Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Web App Demo "),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          // Material(
          //   elevation: 5.0,
          //   child: Image.asset("assets/logo.jpg")),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(40),
            child: InkWell(
              onTap: (){
              controller.login2();
            }, child: Container(
              height: 100,
              width: _size.width*0.75,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
              // padding: EdgeInsets.all(_size.width*0.55/10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Image.asset("assets/google_logo.png",height: 50,width: 50,),
              Padding(
                padding: const EdgeInsets.only(left : 8.0),
                child: Text("Sign In With Google",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              )
                      ],),)),
          )
        ],),
      ),
      drawer: _size.width >600? null: Drawer()

    );
      }
}



