// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chatapp/modals/chatroom_model.dart';
import 'package:fire_chatapp/modals/firebase_helper.dart';
import 'package:fire_chatapp/pages/login_page.dart';
import 'package:fire_chatapp/pages/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modals/user_model.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage(
      {super.key, required this.userModel, required this.firebaseUser});

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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("participants${widget.userModel.uid}", isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatroomSnapshot = snapshot.data as QuerySnapshot;

                return ListView.builder(
                  itemCount: chatroomSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    ChatroomModel chatroomModel = ChatroomModel.fromMap(
                        chatroomSnapshot.docs[index].data()
                            as Map<String, dynamic>);

                    Map<String, dynamic> participants =
                        chatroomModel.participants!;

                    List<String> participantsKeys = participants.keys.toList();

                    participantsKeys.remove(widget.userModel.uid);

                    return FutureBuilder(
                      future:
                          FirebaseHelper.getUserModelById(participantsKeys[0]),
                      builder: (context, snapshot) {
                        UserModel targetUser = snapshot.data as UserModel;

                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListTile(
                            onTap: () {},
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  targetUser.profilepic.toString()),
                            ),
                            title: Text(targetUser.fullname.toString()),
                            subtitle:
                                Text(chatroomModel.lastMessage.toString()),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Center(child: Text("No Chats"));
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) {
                return SearchPage(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser,
                );
              },
            ),
          );
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
