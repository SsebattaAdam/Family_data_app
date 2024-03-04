import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../AuthRepo/Authentications4app/authetication_service_Repo.dart';

class FamilyMemberDetailsPage extends StatefulWidget {
  final String category;
  final String firstName;
  final String lastName;
  final String imageUrl;
  final String fathers_name;
  final String mothers_name;
  final String age;
  final String email;

  FamilyMemberDetailsPage({
    required this.category,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.fathers_name,
    required this.mothers_name,
    required this.age,
    required this.email,
  });

  @override
  State<FamilyMemberDetailsPage> createState() => _FamilyMemberDetailsPageState();
}

class _FamilyMemberDetailsPageState extends State<FamilyMemberDetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Authentication_repositry? _authrticatedUser;
  @override
  void initState() {
    super.initState();
    _authrticatedUser =GetIt.instance.get<Authentication_repositry>();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        backgroundColor: Colors.green,
        title: Text('${widget.firstName} ${widget.lastName} Details', style:TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w600,
        )),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white,),
            onPressed: () {
              // Implement edit logic here
              _editFamilyMember(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white,),
            onPressed: () async {
              // Show a confirmation dialog
              bool confirmDeletion = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Deletion'),
                    content: Text('Are you sure you want to delete this family member?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // User confirmed
                        },
                        child: Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // User canceled
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  );
                },
              );

              // Check the user's response
              if (confirmDeletion == true) {
                try {
                  bool deletionResult = await deleteFamilyMember(
                    widget.category,
                    widget.firstName,
                    widget.lastName,
                    // Add more parameters as needed for unique identification
                  );

                  if (deletionResult) {
                    print('Family member deleted successfully');

                    // Show a SnackBar with a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Family member deleted successfully', style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pop(context); // Navigate back to the previous page
                  } else {
                    print('Error deleting family member, login agian');

                    // Show a SnackBar with an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting family member, login agian'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  print('Error deleting family member: $e');
                }
              }
            },
          ),



        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.imageUrl != null
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl),
                  radius: 50.0,
                )
                    : Icon(Icons.person, size: 50.0),
                SizedBox(height: 16.0),
                buildDetailCard('First Name:', widget.firstName),
                buildDetailCard('Last Name:', widget.lastName),
                buildDetailCard('Age:', widget.age),
                buildDetailCard('Email:', widget.email),
                buildDetailCard('Father Name:', widget.fathers_name),
                buildDetailCard('Mother Name:', widget.mothers_name),
                // Add more details as needed
              ],
            ),
          ),
        ),

      ),
    );
  }

  void _editFamilyMember(BuildContext context) {
    // Implement logic to navigate to the edit page
    // You can pass the necessary data to the edit page if needed
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => EditFamilyMemberPage(data: yourData)));
  }

  // Function to build a styled detail card
  Widget buildDetailCard(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8.0), // Add some spacing between label and value
          Text(
            value,
            style: TextStyle(
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }


  Future<bool> deleteFamilyMember(
      String category,
      String firstName,
      String lastName,
      // Add more parameters as needed for unique identification
      ) async {
    try {
      // Get the current user
      User? currentUser = _auth.currentUser;

      // Check if there is a currently authenticated user
      if (currentUser != null) {
        String userId = currentUser.uid;

        // Perform a query to find the document ID of the family member to delete
        QuerySnapshot querySnapshot = await _db
            .collection('Family_Members')
            .where('userId', isEqualTo: userId)
            .where('category', isEqualTo: category)
            .where('First_Name', isEqualTo: firstName)
            .where('Last_Name', isEqualTo: lastName)
        // Add more conditions as needed for unique identification
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Assuming there is only one matching document, get its ID
          String documentId = querySnapshot.docs.first.id;

          // Delete the document
          await _db.collection('Family_Members').doc(documentId).delete();
          print('Family member deleted successfully');
          return true;
        } else {
          // Handle the case where no matching document is found
          print('Family member not found for deletion');
          return false;
        }
      } else {
        // Handle the case where there is no authenticated user
        print('Error deleting family member: No authenticated user');
        return false;
      }
    } catch (e) {
      // Check for FirebaseAuthException and specific error codes
      if (e is FirebaseAuthException &&
          (e.code == 'user-not-found' || e.code == 'user-token-expired')) {
        // Handle the case where the user is not authenticated or the token is expired
        print('Error deleting family member: No authenticated user');
        return false;
      }

      // Handle other errors
      print('Error deleting family member: $e');
      return false;
    }
  }




}

