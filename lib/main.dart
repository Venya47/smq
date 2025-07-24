import 'SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async{
    // WidgetsFlutterBinding.ensureInitialized();
    if(kIsWeb) {
      await Firebase.initializeApp(options: const FirebaseOptions(
            apiKey: "AIzaSyCFyX6W4zzEx89eRtUdvTHUT5kzPAllFzs",
            authDomain: "quiz-database-b58d1.firebaseapp.com",
            projectId: "quiz-database-b58d1",
            storageBucket: "quiz-database-b58d1.firebasestorage.app",
            messagingSenderId: "484558689993",
            appId: "1:484558689993:web:8d3eabd40f1b3ea5191f18",
            measurementId: "G-25GGSDT3ST"));
    }
    else{
        await Firebase.initializeApp();
      }
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pink App',
      theme: ThemeData(
        primaryColor: Colors.pink[300],
        scaffoldBackgroundColor: Colors.grey[100],
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.pinkAccent),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

