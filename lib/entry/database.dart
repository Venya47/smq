import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  addUser(String userId, Map<String, dynamic>  userInfoMap){
    return FirebaseFirestore.instance.collection("finalUser").doc(userId).set(userInfoMap);
  }

}

