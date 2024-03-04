import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../AuthRepo/Authentications4app/authetication_service_Repo.dart';
import '../homepage.dart';

class Family_MeberCategory extends StatefulWidget {
  const Family_MeberCategory({super.key});

  @override
  State<Family_MeberCategory> createState() => _Family_MeberCategoryState();
}

class _Family_MeberCategoryState extends State<Family_MeberCategory> {
  Authentication_repositry? _authrticatedUser;
  @override
  void initState() {
    super.initState();

    _authrticatedUser =GetIt.instance.get<Authentication_repositry>();



  }
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
                _authrticatedUser!.logout();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
              },
              icon: const Icon(Icons.home, color: Colors.white)
          ),
        ],
      ),
      body: Container(
        child: Family_MeberListView(),
      ),
    );
  }

  Widget Family_MeberListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _authrticatedUser!.getFamilyIMeber(),
      builder: (BuildContext context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          List _familyImage =
          _snapshot.data!.docs.map((e) => e.data()).toList();

          return ListView.builder(
            itemCount: _familyImage.length,
            itemBuilder: (BuildContext context, int index) {
              Map _familyImageData = _familyImage[index];

              return ListTile(
                leading: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_familyImageData["image"]),
                    ),
                  ),
                ),
                title: Text(_familyImageData["category"]),
                subtitle: Text(
                  '${_familyImageData["First_Name"]} ${_familyImageData["Last_Name"]}',
                ),
                onTap: null,
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}
