import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Authentication_repositry {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Map? currentUser;

  Authentication_repositry();




  Future<bool> registerUser({
    required String name,
    required String password,
    required String email,
    required String phone_number,
   }) async {
    try{
      UserCredential _userCredential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      String _userId = _userCredential.user!.uid;
      await _db.collection("users").doc(_userId).set({
        "name": name,
        "email": email,
        "password": password,
        "phone": phone_number
      });
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> addFamily_Member({
    required String fname,
    required String lname,
    required String email,
    required String  age,
    required String phone,
    required String fathers_name,
    required String mothers_name,
    required String category,
    required File image,
  })async {
    try {
      String userId = _auth.currentUser!.uid;
      String filename = Timestamp.now().millisecondsSinceEpoch.toString() + p.extension(image.path);
      UploadTask taskUser =  _storage.ref('images/$userId/$filename').putFile(image);
      return taskUser.then((_snapshot) async {
        String downloadURL = await  _snapshot.ref.getDownloadURL();
        await _db.collection('Family_Members').add({
          "userId": userId,
          "image": downloadURL,
          "timeStamp": Timestamp.now(),
          "First_Name": fname,
          "Last_Name": lname,
          "age": age,
          "email": email,
          "phone_number": phone,
          "fathers_name": fathers_name,
          "mothers_name": mothers_name,
          "category": category
        });
        return true;
      });

    }catch (e) {
      print(e);
      return false;
    }
  }


  Future<bool> loginUser({ required String email, required String password} ) async {

     try {
       UserCredential _userCredentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
       if (_userCredentials.user != null) {
         currentUser = await getUserData(uid: _userCredentials.user!.uid);
         return true;
       } else {
         return false;
       }
     }catch (e) {
       print(e);
       return false;
     }


    }

    Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot _doc= await _db.collection('users').doc(uid).get();
    return _doc.data() as Map;
    }

  Future<void> logout() async {
    await _auth.signOut();
  }


  Stream<QuerySnapshot> getFamilyIMeber(){
    return _db
        .collection("Family_Members")
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }


  Future<void> deleteFamilyMember(
      String category,
      String firstName,
      String lastName,
      // Add more parameters as needed for unique identification
      ) async {
    try {
      String userId = _auth.currentUser!.uid;

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
      } else {
        // Handle the case where no matching document is found
        print('Family member not found for deletion');
      }
    } catch (e) {
      // Handle errors
      print('Error deleting family member: $e');
      throw e; // Re-throw the exception to be caught in the calling code
    }
  }


}