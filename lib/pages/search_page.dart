// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chatapp/pages/chatroom_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? searchByName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: "Search",
            focusColor: Colors.white,
          ),
          onChanged: (val) {
            setState(() {
              searchByName = val;
            });
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;

                    if (searchByName!.isEmpty) {
                      return ListTile(
                        textColor: Color.fromARGB(255, 156, 156, 156),
                        title: Text(data['fullname']),
                        leading: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 159, 159, 159),
                          backgroundImage: NetworkImage(data['profilepic']),
                        ),
                      );
                    }
                    if (data['fullname']
                        .toString()
                        .toLowerCase()
                        .startsWith(searchByName!.toLowerCase())) {
                      return ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return ChatRoomPage();
                          }));
                        },
                        title: Text(data['fullname']),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data['profilepic']),
                        ),
                        subtitle: Text(data["email"]),
                        trailing: Icon(Icons.arrow_forward),
                      );
                    }
                    return Container();
                  },
                );
        },
      ),
    );
  }
}






// class SearchPage extends StatefulWidget {
//   // final UserModel? userModel;
//   // final User? firebaseUser;

//   // const SearchPage(
//   //     {super.key,  this.userModel,  this.firebaseUser});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   TextEditingController searchController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: TextField(
//             textInputAction: TextInputAction.search,
//             onSubmitted: (value) {
//               print("Search");
//             },
//             controller: searchController,
//             decoration: InputDecoration(
//               hintText: "Search",
//               focusColor: Colors.white,
//             ),
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         body: Container(
//           child: Text('Search Chat'),
//         ));
//   }
// }
