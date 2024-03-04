
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../AuthRepo/Add_Member_repo/category.dart';
import '../display_Familydata/categoryUnigque.dart';
import '../display_Familydata/displayCatogry.dart';
import '../notifications/notifications.dart';

import 'categoryListPage.dart';

class Ladingpage_forUser extends StatefulWidget {
  const Ladingpage_forUser({super.key});

  @override
  State<Ladingpage_forUser> createState() => _Ladingpage_forUserState();
}

class _Ladingpage_forUserState extends State<Ladingpage_forUser> {

  TextEditingController categoryController = TextEditingController();
   Category _category =Category();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _Loadpage(),



    );
  }

  Widget _Loadpage(){
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "Welcome to Family App Dashboad",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.normal,
              color: Colors.green,

            ),
          ),

        ),
        SizedBox(height: 100),
        Expanded(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap:() async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BirthdayForm()),
                    );
                    int membersCount = await _getFamilyMembersCount(); // Fetch the family members count
                    print('Number of family members: $membersCount');
                  },
                  child: Card(
                    child: ListTile(
                      title: TextButton.icon(
                        onPressed: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => BirthdayForm()),
                          );
                          int membersCount = await _getFamilyMembersCount(); // Fetch the family members count
                          print('Number of family members: $membersCount');
                        },
                        icon: Icon(Icons.group, color: Colors.green),
                        label: Text("Set birthday", style: TextStyle(color: Colors.green)),
                      ),
                      subtitle: FutureBuilder<int>(
                        future: _getFamilyMembersCount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text(
                              '',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.green, fontSize: 50.0),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error loading family members count',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red, fontSize: 16.0),
                            );
                          } else {
                            return Text(
                              snapshot.data.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.green, fontSize: 50.0),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Card(
                  child: GestureDetector(
                   onTap:(){
                     Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(builder: (context) => Family_MeberCategory()),
                     );
                   },
                    child: ListTile(
                      title: TextButton.icon(
                        onPressed: () async {
                          int membersCount = await _getFamilyMembersCount(); // Fetch the family members count
                          print(' Number of family members: $membersCount');
                        },
                        icon: Icon(Icons.group, color: Colors.green),
                        label: Text("View Family Members", style: TextStyle(color: Colors.green)),
                      ),
                      subtitle: FutureBuilder<int>(
                        future: _getFamilyMembersCount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text(
                              '',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.green, fontSize: 50.0),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error loading family members count',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red, fontSize: 16.0),
                            );
                          } else {
                            return Text(
                              snapshot.data.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.green, fontSize: 50.0),
                            );
                          }
                        },
                      ),
                    ),


                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: GestureDetector(
                    onTap:(){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UniqueCategory()),
                      );
                    },
                    child: ListTile(
                      title: TextButton.icon(
                        onPressed: () async {
                          int categoryCount = await _getCategoryCount(); // Fetch the category count
                          print('Number of categories: $categoryCount');
                        },
                        icon: Icon(Icons.category, color: Colors.green),
                        label: Text("Category", style: TextStyle(color: Colors.green)),
                      ),
                      subtitle: FutureBuilder<int>(
                        future: _getCategoryCount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text(
                              '',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.green, fontSize: 50.0),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error loading category count',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red, fontSize: 16.0),
                            );
                          } else {
                            return Text(
                              snapshot.data.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.green, fontSize: 50.0),
                            );
                          }
                        },
                      ),
                    ),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: TextButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return ListView(
                              children: <Widget>[

                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.add_circle, color: Colors.green,),
                                  title: Text("Add category", style: TextStyle(color: Colors.green),),
                                  onTap: () {
                                    _categoryAlert();
                                  },
                                ),
                                Divider(),
                                ListTile(

                                  leading: Icon(Icons.category, color: Colors.green),
                                  title: Text("Category list", style: TextStyle(color: Colors.green)),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoryListPage()),
                                    );
                                  },
                                ),
                                Divider(),


                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.manage_accounts,
                        color: Colors.green,
                      ),
                      label: Text(
                        "Manage Categories",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }

  void _categoryAlert() async {
    var alert = AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Category cannot be empty';
            }
            return null; // Return null for no validation error
          },
          decoration: InputDecoration(
            hintText: "Add category",
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (_categoryFormKey.currentState!.validate()) {
              // If the form is valid, check if the category already exists
              bool categoryExists = await _category.checkCategoryExists(categoryController.text);

              if (categoryExists) {
                Fluttertoast.showToast(msg: 'Category already exists');
              } else {
                // If the category doesn't exist, add it
                _category.createCategory(categoryController.text);
                Fluttertoast.showToast(msg: 'Category created');
                Navigator.pop(context);
              }
            }
          },
          child: Text('ADD'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('CANCEL'),
        ),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  Future<int> _getCategoryCount() async {
    try {
      QuerySnapshot categorySnapshot = await FirebaseFirestore.instance.collection('categories').get();
      return categorySnapshot.size;
    } catch (e) {
      print('Error fetching category count: $e');
      return 0; // Return 0 in case of an error
    }
  }
  Future<int> _getFamilyMembersCount() async {
    try {
      QuerySnapshot membersSnapshot = await FirebaseFirestore.instance.collection('Family_Members').get();
      return membersSnapshot.size;
    } catch (e) {
      print('Error fetching family members count: $e');
      return 0; // Return 0 in case of an error
    }
  }

}
