import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smq/firebase_options.dart';
import 'SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async{
    // WidgetsFlutterBinding.ensureInitialized();
    if(kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
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

