// ignore_for_file: prefer_const_constructors,

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chatapp/modals/user_model.dart';
import 'package:fire_chatapp/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      print("Please Fill Email & Password");
    } else {
      login(email, password);
    }
  }

  void login(String email, String password) async {
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
    }

    if (userCredential != null) {
      String uid = userCredential.user!.uid;

      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);

      print("Login Successful!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Fire Chat",
                  style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailController,
                  decoration:
                      InputDecoration(hintText: "Email", labelText: "Email"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password", labelText: "Password"),
                ),
                SizedBox(
                  height: 18,
                ),
                CupertinoButton(
                  onPressed: () {
                    checkValues();
                  },
                  color: Theme.of(context).colorScheme.secondary,
                  child: Text("Login"),
                )
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't Have An Account?"),
                CupertinoButton(
                  onPressed: (() {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: ((context) => SignUpPage())));
                  }),
                  child: Text("Signup"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}