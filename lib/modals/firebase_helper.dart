import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chatapp/modals/user_model.dart';


class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;

    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docSnap.data() != null) {
      userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return userModel;
  }

  // static String readTimestamp(int timestamp) {
  //   var now = new DateTime.now();
  //   var format = DateFormat('HH:mm a');
  //   var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  //   var diff = date.difference(now);
  //   var time = '';

  //   if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
  //     time = format.format(date);
  //   } else {
  //     if (diff.inDays == 1) {
  //       time = diff.inDays.toString() + 'DAY AGO';
  //     } else {
  //       time = diff.inDays.toString() + 'DAYS AGO';
  //     }
  //   }

  //   return time;
  // }
}
