// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("User Name")),
        body: Center(
          child: Column(
            children: [
              Expanded(child: Container()),
              Container(
                color: Color.fromARGB(255, 240, 240, 240),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Enter Message",
                            border: InputBorder.none),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
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
