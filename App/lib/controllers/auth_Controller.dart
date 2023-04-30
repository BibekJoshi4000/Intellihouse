import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:web_app/dashboard.dart';
import 'package:web_app/homePage.dart';
import 'package:web_app/sigInPage.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('students');

class AuthController extends GetxController{
  final _googleSignin = GoogleSignIn();
  var per = 1.obs;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            print("##########################################");
            return DashBoard();
          } else {
            print("+++++++++++++++++++++++++++++++++++++++++");
            return  SignInPage();
          }
        });
  }
  // var googleSignInAccount = Rx<GoogleSignInAccount?>(null);
  //  var googleSignInAccount;
  var isLogedIn = false.obs;
  login2 () async {
     try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
         if(googleUser  ==  null){
         }
         else{
          firebaseAuth.signOut();
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        // var db = Db("mongodb+srv://rajricky4477:y8omIMO7eP01SpfH@cluster0.znufwxy.mongodb.net/?retryWrites=true&w=majority");
        // db.open();
        // var collection = db.collection('students');
        // await collection.insert({
        //   "email" : FirebaseAuth.instance.currentUser!.email,
        //   "name" :FirebaseAuth.instance.currentUser!.displayName,
        //   "location" :"",
        //   "dob" :"",
        //   "gender" :"",
        //   });
        checkIfDocExists(FirebaseAuth.instance.currentUser!.email).then((value)  {
          if(value == false){
             _mainCollection.doc(FirebaseAuth.instance.currentUser!.email).set({
            "email" : FirebaseAuth.instance.currentUser!.email,
          "name" :FirebaseAuth.instance.currentUser!.displayName,
          "location" :"",
          "dob" :"",
          "gender" :"",
          });
            print("--->>False");
          }
          else if (value == true){
            print("--->>True");
          }
        });
          if(checkIfDocExists(FirebaseAuth.instance.currentUser!.email) == false){
             _mainCollection.doc(FirebaseAuth.instance.currentUser!.email).set({
            "email" : FirebaseAuth.instance.currentUser!.email,
          "name" :FirebaseAuth.instance.currentUser!.displayName,
          "location" :"",
          "dob" :"",
          "gender" :"",
          });
          }
              // _mainCollection.doc(FirebaseAuth.instance.currentUser!.email).set({
              //   "email" : FirebaseAuth.instance.currentUser!.email,
              // "name" :FirebaseAuth.instance.currentUser!.displayName,
              // "location" :"",
              // "dob" :"",
              // "gender" :"",
              // });
          } 
    }
   
     catch(e){
      Get.snackbar(e.toString(), e.toString(),duration: const Duration(seconds: 5));
     }
  }
  Future<bool> checkIfDocExists(String? docId) async {
  try {
    

    var doc = await _mainCollection.doc(docId!).get();
    print("----------------->>>>>>>>>>>>${doc.exists}");
    return doc.exists;
  } catch (e) {
    Get.snackbar(e.toString(), e.toString(),duration: const Duration(seconds: 5));
    throw e;
  }
}
  login  () async {
    // googleSignInAccount.value = await _googleSignin.signIn();

    try
    {
      var googleSignInAccount =  await _googleSignin.signIn().then((value) {
        print("////////////////////////////////////////////////////////");
        print(value!.email);
        print("////////////////////////////////////////////////////////");
        // print(googleSignInAccount.email);
        print("////////////////////////////////////////////////////////");
        print(value.toString());
      });
    }
    catch(e){
      print('...............RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR.....................');
      print(e.toString());

      Get.showSnackbar(GetSnackBar(title: "tile",message: e.toString(),));
    }
    // if(googleSignInAccount != null){
    // Get.snackbar("title", googleSignInAccount.email ?? "Hello");
    // print("---------->");
    // print(googleSignInAccount?.email);
    //   Future.delayed(Duration(seconds: 3),(){
    //     isLogedIn.value = true;
    //   });
    // }
    // else{
    //   isLogedIn.value = false;
    // }
  }

  logout() async{
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
    // googleSignInAccount = await _googleSignin.signOut();
    // if(googleSignInAccount == null){
    //   Future.delayed(Duration(seconds: 3),(){
    //     isLogedIn.value = false;
    //   });
    // }
    // else{
    //   isLogedIn.value = true;
    // }
  }
  updateDb(email,location,dob,gender) async{

    _mainCollection.doc(email).update({
      "location" :location,
      "dob" : dob,
      "gender" : gender
    });
    
  }
  getDataofStudent(String? email)async {
   DocumentSnapshot<Object?> data = await _mainCollection.doc(email!).get();
   print("==============================");
   print(data.get("location"));
   print(data.data());
   List list = [
    data.get("location"),
    data.get("dob"),
    data.get("gender"),
   ];
   return list;
  }
  Data(email){
    return StreamBuilder(
      stream: _mainCollection.doc(email!).snapshots(),
      builder: (_,snapshot){
        return Text("data");
    });
  }
}