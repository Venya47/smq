
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'ProfilePage.dart';
import 'ProgressPage.dart';
import 'HomePage.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int pageIndex=0;
  late List<Widget> pages;
  late Widget curPage;
  late ProgressPage progressPage; //part
  late ProfilePage profilePage;  //part
  late HomePage homePage;    //part
  @override
  void initState()
  {
    profilePage=ProfilePage();
    progressPage=ProgressPage();
    homePage=HomePage();

    pages=[homePage,progressPage,profilePage];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Center(child: Text('My Modules',style: TextStyle(color: Color.fromRGBO(166, 123, 91, 1.0),fontWeight:FontWeight.bold),textAlign:TextAlign.center,)),
        backgroundColor: Color.fromRGBO(255, 135, 135,1.0),
      ),
      body: pages[pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
            height: 65,
            backgroundColor: Colors.black12,
            color: Colors.green,
            animationDuration: Duration(milliseconds: 500),
            onTap: (int index)
            {
              setState(() {
                pageIndex=index;
              });
            },
            items: [
              Icon(
                Icons.home_filled,
                color: Colors.white,
              ),
              Icon(
                Icons.ac_unit_sharp,
                color: Colors.white,
              ),
              Icon(
                Icons.account_circle,
                color: Colors.white,),
            ]
        ),
    );
  }
}
