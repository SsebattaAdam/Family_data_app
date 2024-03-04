import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'AuthRepo/Authentications4app/authetication_service_Repo.dart';
import 'AuthRepo/Register_loginpages/login.dart';
import 'add_people/add_Family_Member.dart';
import 'add_people/display_family_memberData.dart';
import 'add_people/homepage2Main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Authentication_repositry? _authrticatedUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authrticatedUser = GetIt.instance.get<Authentication_repositry>();
  }
  int _currentPage = 0;
  final List<Widget> _pages = [
    Ladingpage_forUser(),
    Add_fimally_member(),
    Display_family_MemberData(),

  ];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.green,
        title: Center(child: const Text('Family Data', style:
        TextStyle(color: Colors.white, fontSize: 26,fontWeight: FontWeight.w600, ))),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              showLogoutConfirmationDialog();
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),

      bottomNavigationBar: _bottomNvBar(),

      body: _pages[_currentPage],
    );
  }

  Widget _bottomNvBar(){
    return BottomNavigationBar(
      backgroundColor: Colors.green,
      currentIndex: _currentPage,
      onTap: (_index) {
        setState(() {
          _currentPage = _index;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.white),
          label: 'Home',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, color: Colors.white),
          label: 'Add',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.white),
          label: 'Profile',
          backgroundColor: Colors.white,
        ),
      ],
    );
  }

  void showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout", style: TextStyle(
              color: Colors.green,
              fontSize: 35,
              fontWeight: FontWeight.w600
          )),
          content: Text("Are you sure you want to logout?", style: TextStyle(
              color: Colors.green,
              fontSize: 15,
              fontWeight: FontWeight.w600

          )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No", style: TextStyle(
                  color: Colors.green
              )),
            ),
            TextButton(
              onPressed: () {
                _authrticatedUser!.logout();
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login_page()));
              },
              child: Text("Yes", style: TextStyle(
                color: Colors.red,
              )),
            ),
          ],
        );
      },
    );
  }
}


