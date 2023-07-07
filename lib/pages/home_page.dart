// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chatapp/modals/chatroom_model.dart';
import 'package:fire_chatapp/modals/firebase_helper.dart';
import 'package:fire_chatapp/pages/chatroom_page.dart';
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
        title: Text("Fire Chat"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(context,
                  CupertinoPageRoute(builder: (context) {
                return LoginPage();
              }));
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(2),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .where("participants.${widget.userModel.uid}",
                      isEqualTo: true)

                  // .orderBy("sendtime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot chatroomSnapshot =
                        snapshot.data as QuerySnapshot;

                    return ListView.builder(
                      itemCount: chatroomSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        // ChatroomModel for Accessing Participants
                        ChatroomModel chatroomModel = ChatroomModel.fromMap(
                            chatroomSnapshot.docs[index].data()
                                as Map<String, dynamic>);

                        Map<String, dynamic> participants =
                            chatroomModel.participants!;

                        List<String> participantKeys =
                            participants.keys.toList();

                        participantKeys.remove(widget.userModel.uid);

                        return FutureBuilder(
                          future: FirebaseHelper.getUserModelById(
                              participantKeys[0]),
                          builder: (context, userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              if (userData.data != null) {
                                UserModel targetUser =
                                    userData.data as UserModel;

                                return ListTile(
                                  onTap: () {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return ChatRoomPage(
                                          targetUser: targetUser,
                                          chatRoom: chatroomModel,
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser);
                                    }));
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        targetUser.profilepic.toString()),
                                  ),
                                  title: Text(targetUser.fullname.toString()),
                                  subtitle: (chatroomModel.lastMessage
                                              .toString() !=
                                          "")
                                      ? Text(
                                          chatroomModel.lastMessage.toString())
                                      : Text(
                                          "Say hi to your new friend!",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                  trailing:
                                      Text(chatroomModel.sendTime.toString()),
                                );
                              } else {
                                return Text("Some Value Occurs Null");
                              }
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return Center(
                      child:
                          Text("No Chats Available, Say Hi to your new friend"),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )),
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
