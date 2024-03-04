import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

import '../AuthRepo/Add_Member_repo/category.dart';
import '../AuthRepo/Authentications4app/authetication_service_Repo.dart';
import '../homepage.dart';
import 'homepage2Main.dart';

class Add_fimally_member extends StatefulWidget {
  const Add_fimally_member({super.key});

  @override
  State<Add_fimally_member> createState() => _Add_fimally_memberState();
}

class _Add_fimally_memberState extends State<Add_fimally_member> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Map? currentUser;

  bool isLoading =false;
  String? email;
  String? fname;
  String? lname;
  String?  fathers_name;
  String?  mothers_name;
  String? error_message = "";
  String? phone_number;
  String? category;
  String? age;
  final GlobalKey<FormState> _addUser = GlobalKey<FormState>();
  Category _category = Category();
  Authentication_repositry? _authrticatedUser;
  File? _image;

  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categryDropDown = <DropdownMenuItem<String>>[];

 String? _currentCategory;

  @override
  void initState() {
    super.initState();

    _authrticatedUser =GetIt.instance.get<Authentication_repositry>();
    _getCategories();
    categryDropDown = getCatgoryDropdown();


  }
  List<DropdownMenuItem<String>> getCatgoryDropdown() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < categories.length; i++) {
      items.add(
        DropdownMenuItem(
          child: Text((categories[i].data() as Map<String, dynamic>)['category'] ?? ''),
            value: (categories[i].data() as Map<String, dynamic>)['categoryName'] ?? '',
            
        ),
      );
    }
    // Print items for debugging
    print('Dropdown items: $items');
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _titleWidget(),
                  _userImage(),
                  _RegisterForm(),


                ],
              ),
            )
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      height: 40,
      child: Text(
        "Add a Family Memeber",
        style: TextStyle(
          color: Colors.green,
          fontSize: 30,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _RegisterForm() {
    return Container(
      height: 300,
      child: Form(
        key: _addUser,
        child: isLoading?CircularProgressIndicator():SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _fnameTextField(),
              SizedBox(height: 20,),
              _lnameTextField(),
              SizedBox(height: 20,),
              _ageTextField(),
              SizedBox(height: 20,),
              _emailTextField(),
              SizedBox(height: 20,),
              _phone_numberTextField(),
              SizedBox(height: 20,),
              _fathnameTextField(),
              SizedBox(height: 20,),
              _mothernameTextField(),

              SizedBox(height: 20,),
              _buildCategoryRow(),
              SizedBox(height: 10,),
              _RegisterButton(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _fnameTextField() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.green, // Set the border color to green on focus
            ),
          ),
        ),
        onSaved: (value) {
          fname = value;
        },
        validator: (value) => value!.length > 0 ? null : "Please enter  name"
    );
  }

  Widget _lnameTextField() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: "Last Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.green, // Set the border color to green on focus
            ),
          ),
        ),
        onSaved: (value) {
          lname = value;
        },
        validator: (value) => value!.length > 0 ? null : "Please enter  name"
    );
  }

  Widget _emailTextField() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.green, // Set the border color to green on focus
            ),
          ),
        ),
        onSaved: (value) {
          email = value;
        },
        validator: (value) {
          bool _results = value!.contains(
              RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'));
          return _results ? null : "Please enter a valid email";
        }
    );
  }

  Widget _phone_numberTextField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "+256...", // Add your desired country code hint
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.green, // Set the border color to green on focus
          ),
        ),
      ),
      onSaved: (value) {
        phone_number = value;
      },
      validator: (value) {
        // You can add validation for phone number if needed
        return value!.isEmpty ? "Please enter a phone number" : null;
      },
    );
  }

  Widget _fathnameTextField() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: "Fathers Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.green, // Set the border color to green on focus
            ),
          ),
        ),
        onSaved: (value) {
          fathers_name = value;
        },
        validator: (value) => value!.length > 0 ? null : "Please enter  name"
    );
  }

  Widget _mothernameTextField() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: "Mothers Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.green, // Set the border color to green on focus
            ),
          ),
        ),
        onSaved: (value) {
          mothers_name = value;
        },
        validator: (value) => value!.length > 0 ? null : "Please enter  name"
    );
  }

  Widget _ageTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: "Age",
        hintText: "Enter your age",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.green, // Set the border color to green on focus
          ),
        ),
      ),
      onSaved: (value) {
        age = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your age";
        } else if (value.length > 3) {
          return "Age should be at most three characters";
        }
        return null;
      },
    );
  }


  Future<void> uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    File _image = File(result!.files.first.path!);
  }

  Widget _userImage() {
    var _imageprovider = _image != null
        ? FileImage(_image!)
        : const NetworkImage(
        "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png");

    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(
          type: FileType.image,
        ).then((_value) {
          setState(() {
            _image = File(_value!.files.first.path!);
          });
        });
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          image: DecorationImage(

            image: _imageprovider as ImageProvider,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(50),
          color: Colors.green,
        ),

      ),
    );
  }

  Widget _RegisterButton() {
    return MaterialButton(
      onPressed: _adfamily_member,
      minWidth: double.infinity,
      height: 50,
      color: Colors.green,
      child: Text(
        "Add",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
  Widget _buildCategoryRow() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Category',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          TextFormField(
            readOnly: true,
            onTap: () {
              _showCategoryPicker();
            },
            onSaved: (value) {
              category = value;
            },
            controller: TextEditingController(text: _currentCategory),
            decoration: InputDecoration(
              hintText: 'Select Category',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.green, // Set the border color to green on focus
                ),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Category is required';
              }
            },
          ),
        ],
      ),
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              String category = (categories[index].data() as Map<String, dynamic>)['categoryName'] ?? '';
              return ListTile(
                title: Text(category),
                onTap: () {
                  setState(() {
                    _currentCategory = (categories[index].data() as Map<String, dynamic>)['categoryName'] ?? '';

                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  void _adfamily_member() async {
    if (_addUser.currentState!.validate() && _image != null) {
      _addUser.currentState!.save();

      try {
        if (_authrticatedUser != null) {
          // Refresh the authentication token
          await _auth.currentUser!.reload();

          // Add the family member
          await _authrticatedUser!.addFamily_Member(
            fname: fname!,
            lname: lname!,
            email: email!,
            age: age!,
            phone: phone_number!,
            fathers_name: fathers_name!,
            mothers_name: mothers_name!,
            category: category!,
            image: _image!,
          );

          Fluttertoast.showToast(
            msg: "Family Member Added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else {
          print('Authentication user is null');
        }
      } catch (e) {
        print('Error adding family member: $e');
      }
    } else {
      print('Form is not valid or user is not authenticated');
    }
  }








  _getCategories() async {
    List<DocumentSnapshot> data = await _category.getCategory();
    print(data.length);
    setState(() {
      categories = data;
      if (categories.isNotEmpty) {
        //_currentCategory = (categories[0].data() as Map<String, dynamic>?)?['category'];
        _currentCategory = (categories[0].data() as Map<String, dynamic>?)?['category'] ?? '';

      }else{
        print("category is not updated");
      }

    });
  }
}
