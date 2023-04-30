import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_app/homePage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: "AIzaSyDpLAtwvSMYVFhcYHdzIcCuRgrEGWDJtLc",
      authDomain: "web-app-ff302.firebaseapp.com",
      projectId: "web-app-ff302",
      storageBucket: "web-app-ff302.appspot.com",
      messagingSenderId: "930614140987",
      appId: "1:930614140987:web:26e732ada67f3193997c1e")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        
      ),
      home: Homepage()
    );
  }
}

