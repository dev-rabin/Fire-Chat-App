// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fire_chatapp/pages/login_page.dart';
import 'package:fire_chatapp/pages/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modals/user_model.dart';

class HomePage extends StatefulWidget {
  final UserModel? userModel;
  final User? firebaseUser;

  const HomePage({super.key, this.userModel, this.firebaseUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return LoginPage();
              }));
            });
          },
          icon: Icon(Icons.logout),
        ),
        title: Text("Fire Chat"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) {
                return SearchPage();
              },
            ),
          );
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
