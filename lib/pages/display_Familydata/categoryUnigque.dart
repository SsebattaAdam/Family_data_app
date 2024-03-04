import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../AuthRepo/Authentications4app/authetication_service_Repo.dart';

import '../homepage.dart';
import 'family_meber_details.dart';

class UniqueCategory extends StatefulWidget {
  const UniqueCategory({super.key});

  @override
  State<UniqueCategory> createState() => _UniqueCategoryState();
}

class _UniqueCategoryState extends State<UniqueCategory> {
  // Create a StreamController to trigger a rebuild when data changes
  final StreamController<void> _streamController = StreamController<void>();

  @override
  void initState() {
    super.initState();

    _authrticatedUser = GetIt.instance.get<Authentication_repositry>();

    // Listen for changes in the database and add an event to the StreamController
    _authrticatedUser!.getFamilyIMeber().listen((_) {
      _streamController.add(null);
    });
  }

  @override
  void dispose() {
    // Close the StreamController when the widget is disposed
    _streamController.close();
    super.dispose();
  }

  Authentication_repositry? _authrticatedUser;

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
      body: StreamBuilder<void>(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          // Your existing build logic for FamilyMemberListView
          return FamilyMemberListView();
        },
      ),
    );
  }

  Widget FamilyMemberListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _authrticatedUser!.getFamilyIMeber(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<QueryDocumentSnapshot> familyMembers = snapshot.data!.docs;

        // Use a Set to store unique categories
        Set<String> uniqueCategories = Set<String>();

        // Iterate through family members to collect unique categories
        familyMembers.forEach((familyMember) {
          Map<String, dynamic> data = familyMember.data() as Map<String, dynamic>;
          if (data.containsKey("category")) {
            uniqueCategories.add(data["category"]);
          }
        });

        // Convert the Set back to a List for display
        List<String> categoriesList = uniqueCategories.toList();

        return ListView.builder(
          itemCount: categoriesList.length,
          itemBuilder: (BuildContext context, int index) {
            String category = categoriesList[index];

            return ListTile(
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.green, // Background color
                  borderRadius: BorderRadius.all(Radius.circular(8.0)), // Border radius
                  border: Border.all(color: Colors.white), // Border color
                ),
                padding: EdgeInsets.all(8.0),
                child: Text(
                  category,
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
              ),
              onTap: () {
                // Handle tap action, for example, display names under the selected category
                showDialog(

                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Family Members under $category', style: TextStyle(
                        color: Colors.green,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                      ),),
                      content: Container(
                        width: 300.0,
                        height: 300.0,
                        child: FamilyMemberNamesWidget(
                          category: category,
                        ),
                      ),
                    );
                  },
                );
              },
            );

          },
        );
      },
    );
  }



  Widget FamilyMemberNamesWidget({
    required String category,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Family_Members')
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> familyMember =
            documents[index].data() as Map<String, dynamic>;

            String firstName = familyMember["First_Name"];
            String lastName = familyMember["Last_Name"];
            String fathers_name = familyMember["fathers_name"];
            String mothers_name = familyMember["mothers_name"];
            String email = familyMember["email"];
            String age = familyMember["age"];
            String phone = familyMember["phone_number"];
            String imageUrl = familyMember["image"];

            return ListTile(
              leading: imageUrl != null
                  ? CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              )
                  : Icon(Icons.person),
              title: Text('$firstName $lastName'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FamilyMemberDetailsPage(
                      category: category,
                      firstName: firstName,
                      lastName: lastName,
                      imageUrl: imageUrl,
                      mothers_name: mothers_name,
                      fathers_name: fathers_name,
                      age: age,
                      email: email,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }






}
