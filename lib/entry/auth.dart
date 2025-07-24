
import 'package:firebase_auth/firebase_auth.dart';

// class AuthMethods {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   getCurrentUserID() async {
//     return await auth.currentUser?.uid;
//   }
//
// }

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? getCurrentUserID() => auth.currentUser?.uid;
}
