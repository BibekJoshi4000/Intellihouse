import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_app/controllers/auth_Controller.dart';
import 'package:web_app/dashboard.dart';

class Homepage extends StatelessWidget {
  final controller = Get.put(AuthController(),tag: "AuthController");
   Homepage({super.key});

  @override
  Widget build(BuildContext context) {
   
    return controller.handleAuthState();
  }

 }