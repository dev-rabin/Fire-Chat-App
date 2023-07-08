// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chatapp/modals/ui_helper.dart';
import 'package:fire_chatapp/modals/user_model.dart';
import 'package:fire_chatapp/pages/comp_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void checkValues() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email == "" || password == "" || confirmPassword == "") {
      UIHelper.showAlertDialog(
          context, "Please fill all the fields", "Incomplete Data");
    } else if (password != confirmPassword) {
      UIHelper.showAlertDialog(
          context,
          "Password you entered do not match! Please fill correct password ",
          "Wrong Password");
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;
    UIHelper.showLoadingDialog(context, "Creating new account...");
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      UIHelper.showAlertDialog(context, "Error", e.message!);
    }

    if (credential != null) {
      String uid = credential.user!.uid;

      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: "",
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => CompleteProfile(
                userModel: newUser, firebaseUser: credential!.user!),
          ),
        );
      });
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
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Confirm Password", labelText: "Password"),
                ),
                SizedBox(
                  height: 18,
                ),
                CupertinoButton(
                  onPressed: () {
                    checkValues();
                  },
                  color: Theme.of(context).colorScheme.secondary,
                  child: Text("Signup"),
                )
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already Have An Account?"),
                CupertinoButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  child: Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
