

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chatapp/modals/user_model.dart';

class FirebaseHelper {
 static Future<UserModel?> getUserById(String uid) async {
    UserModel? userModel;

    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection("üsers").doc(uid).get();

    if (docSnapshot.data() != null) {
      userModel = UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
    }
    return userModel;
  }
}
