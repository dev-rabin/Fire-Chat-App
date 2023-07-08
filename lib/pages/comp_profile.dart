// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chatapp/modals/ui_helper.dart';
import 'package:fire_chatapp/modals/user_model.dart';
import 'package:fire_chatapp/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  TextEditingController fullNameController = TextEditingController();
  File? imageFile;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? imageTemp = File(image.path);
      imageTemp = await _cropImage(imageFile: imageTemp);
      setState(() => imageFile = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 10,
    );

    if (croppedImage == null) {
      return null;
    } else {
      return File(croppedImage.path);
    }
  }

  void checkvalues() {
    String fullName = fullNameController.text.trim();

    if (fullName == "" || imageFile == null) {
      UIHelper.showAlertDialog(
          context,
          "Please fill the details and upload a profile picture",
          "Incomplete Data");
    } else {
      log("uploading data");
      _uploaData();
    }
  }

  void _uploaData() async {
    UIHelper.showLoadingDialog(context, "Imgae Uploading...");
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullName = fullNameController.text.trim();

    widget.userModel.fullname = fullName;
    widget.userModel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      log("data uploaded");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) {
            return HomePage(
                userModel: widget.userModel, firebaseUser: widget.firebaseUser);
          },
        ),
      );
    });
  }

  void showPhotoOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Upload Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.photo_album_sharp),
                title: Text("Select From Gallery"),
              ),
              ListTile(
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.camera_alt),
                title: Text("Take A Photo"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Complete Profile"),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                CupertinoButton(
                  onPressed: () {
                    showPhotoOptions();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        (imageFile != null) ? FileImage(imageFile!) : null,
                    child: (imageFile == null)
                        ? Icon(
                            Icons.person,
                            size: 60,
                          )
                        : null,
                  ),
                ),
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    labelText: "Full Name",
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                CupertinoButton(
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    checkvalues();
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
