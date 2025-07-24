import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  String? user_name;
  String? user_email;
  bool isLoading = true;
  String? uid ;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  void deleteAccount(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to permanently delete your account?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    try {
      if (uid != null) {
        await dbService.deleteUser();
      }
      // Try deleting the Firebase Auth account
      await currentUser.delete();

      // Navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // Ask user to reauthenticate
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please log in again to delete your account."),
          ),
        );

        // Redirect to login page for reauthentication
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LogIn()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete account: ${e.message}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    }
  }

  void _showUpdateNameDialog() {
    TextEditingController controller = TextEditingController(text: user_name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter new Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  String newname=controller.text.trim();
                  user_name=newname;
                  dbService.updateUser(newname);
                });
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> loadUserDetails() async {
    uid = await AuthMethods().getCurrentUserID();
    if (uid != null) {
      AppUser? fetchedUser = await dbService.getUserDetails(uid!);
      setState(() {
        user=fetchedUser;
        user_name = fetchedUser?.u_name;
        user_email= fetchedUser?.email;
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
    if (isLoading || user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(
                    child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.asset('assets/images/user_icon.png', height: 200, // in logical pixels
                                    width: 200, ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0,5),
                                          color: Colors.pink.shade50,
                                          spreadRadius: 4,
                                          blurRadius: 20,
                                        )
                                      ]
                                  ),
                                  child: ListTile(
                                    title: Text("Name"),
                                    subtitle: Text(user_name!),
                                    leading: Icon(CupertinoIcons.person),
                                    trailing:IconButton(
                                        icon: Icon(Icons.arrow_forward, color: Colors.grey),
                                        onPressed: () {
                                          _showUpdateNameDialog();
                                        }
                                    ),
                                    //tileColor:Colors.white
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0,5),
                                          color: Colors.pink.shade50,
                                          spreadRadius: 4,
                                          blurRadius: 20,
                                        )
                                      ]
                                  ),
                                  child: ListTile(
                                    title: Text("Email"),
                                    subtitle: Text(user_email!),
                                    leading: Icon(CupertinoIcons.mail)
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () => logout(context),
                                    icon: const Icon(Icons.logout,color: Colors.white,),
                                    label: const Text("Log Out",style: TextStyle(color:Colors.white),),
                                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[200],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: ()
                                    {
                                      deleteAccount(context);
                                    },
                                    icon: const Icon(Icons.delete_forever,color: Colors.white,),
                                    label: const Text("Delete Account",style: TextStyle(color:Colors.white),),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[200],
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                    ),
                                  ),
                                ),

                              ],
                    ),
                  ),
              );
  }

}
