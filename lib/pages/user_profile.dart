import 'package:fire_chatapp/modals/user_model.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final UserModel userModel;

  const UserProfile({super.key, required this.userModel});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage(widget.userModel.profilepic.toString()),
            ),
            Text(" Fullname: ${widget.userModel.fullname.toString()}"),
            Text(" Email: ${widget.userModel.email.toString()}"),
            Text(" Status: ${widget.userModel.status.toString()}")
          ],
        ),
      ),
    );
  }
}
