// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chatapp/main.dart';
import 'package:fire_chatapp/modals/firebase_helper.dart';
import 'package:fire_chatapp/modals/message_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../modals/chatroom_model.dart';
import '../modals/user_model.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatroomModel chatRoom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage(
      {super.key,
      required this.targetUser,
      required this.chatRoom,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  Map<String, dynamic>? userMap;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendMessage() async {
    String message = messageController.text.trim();
    messageController.clear();

    if (message.isNotEmpty) {
      MessageModel newMessage = MessageModel(
          messageId: uuid.v1(),
          sender: widget.userModel.uid,
          text: message,
          oncreated: DateTime.now(),
          seen: false);
      _firestore
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatRoom.lastMessage = message;
      _firestore
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomId)
          .set(widget.chatRoom.toMap());

      log(widget.chatRoom.lastMessage.toString());
      log("message sent!");
    } else {
      log("Message is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore
              .collection("users")
              .doc(widget.targetUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.targetUser.profilepic.toString()),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.targetUser.fullname.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          (snapshot.data?['status'] == "Online")
                              ? snapshot.data!['status']
                              : "Last Seen at ${widget.targetUser.lastSeen!.hour}:${widget.targetUser.lastSeen!.minute}",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 12),
                        )
                      ],
                    ),
                  ],
                ),
              );
            } else
              return Container();
          },
        )),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream: _firestore
                        .collection("chatrooms")
                        .doc(widget.chatRoom.chatroomId)
                        .collection("messages")
                        .orderBy("oncreated", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot dataSnapshot =
                              snapshot.data as QuerySnapshot;

                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMesage = MessageModel.fromMap(
                                  dataSnapshot.docs[index].data()
                                      as Map<String, dynamic>);

                              return Row(
                                mainAxisAlignment: (currentMesage.sender ==
                                        widget.userModel.uid)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: (currentMesage.sender ==
                                                widget.userModel.uid)
                                            ? const Color.fromARGB(
                                                255, 187, 187, 187)
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      children: [
                                        Text(
                                          currentMesage.text.toString(),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                "Error Occured! Check Your Internet Connection"),
                          );
                        } else {
                          return Center(
                            child: Text("Say Hi to your new friend"),
                          );
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: Color.fromARGB(255, 240, 240, 240),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            hintText: "Enter Message",
                            border: InputBorder.none),
                        maxLines: null,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(Icons.send),
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
