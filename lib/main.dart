// ignore_for_file: prefer_const_constructors


import 'package:fire_chatapp/pages/home_page.dart';
import 'package:fire_chatapp/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  var auth = FirebaseAuth.instance;
  bool isLogin = false;

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:isLogin? HomePage() : LoginPage(),
    );
  }
}

























































// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   User? currentUser = FirebaseAuth.instance.currentUser;

//   if (currentUser != null) {
//     // Logged In

//     UserModel? thisUserModel =
//         await FirebaseHelper.getUserById(currentUser.uid);

//     if (thisUserModel != null) {
//       runApp(
//         MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser),
//       );
//     } else {
//       runApp(MyApp());
//     }
//   } else {
//     runApp(MyApp());
//   }
// }

// // Not Log In
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: LoginPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// // Already Logged In
// class MyAppLoggedIn extends StatelessWidget {
//   final UserModel userModel;
//   final User firebaseUser;

//   const MyAppLoggedIn(
//       {super.key, required this.userModel, required this.firebaseUser});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(
//         userModel: userModel,
//         firebaseUser: firebaseUser,
//       ),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
