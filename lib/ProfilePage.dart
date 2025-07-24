import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Model/User.dart';
import 'database_services.dart';
import 'entry/auth.dart';
import 'entry/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DatabaseServices dbService = DatabaseServices();
  AppUser? user;
  bool isLoading = true;
  String? uid ;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    uid = await AuthMethods().getCurrentUserID();
    if (uid != null) {
      AppUser? fetchedUser = await dbService.getUserDetails(uid!);
      setState(() {
        user = fetchedUser;
        isLoading = false;
      });
    }
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? const Center(child: Text("User data not found."))
          : Padding(
                  padding: const EdgeInsets.all(140.0),
                  child: Center(
                    child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.blue,
                                  child: Icon(Icons.person, size: 50, color: Colors.white),
                                ),
                                const SizedBox(height: 20),
                                Text("User Name: ${user!.u_name}",
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(height: 20),
                                Text("Email: ${user!.email}",
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(height: 40),
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () => logout(context),
                                    icon: const Icon(Icons.logout,color: Colors.black,),
                                    label: const Text("Log Out",style: TextStyle(color:Colors.black),),
                                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[200],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                                    ),
                                  ),
                                )
                              ],
                    ),
                  ),
              );
  }
}

// import 'package:flutter/material.dart';
// import 'bottomnav.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         child:Text("Profile Page"),
//       ),
//     );;
//   }
// }
