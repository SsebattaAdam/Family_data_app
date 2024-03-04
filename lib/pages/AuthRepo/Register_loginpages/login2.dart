import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginScren extends StatefulWidget {
  LoginScren({super.key});
  static const  String tag= '/app_dairylogin_screen';

  @override
  State<LoginScren> createState() => _LoginScrenState();
}

class _LoginScrenState extends State<LoginScren> {
  final _formKey = GlobalKey<FormBuilderState>();

  String username = "";
  String error_message ="";
  String password = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      
        body:  SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: FormBuilder(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
          
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        name: 'username',
                        onChanged: (x){
                          username = x.toString();
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.required(),
                        decoration: InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(
          
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
          
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        name: 'password',
                        onChanged: (x){
                          password = x.toString();
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(6),
                        ]),
                        decoration: InputDecoration(
                          labelText: "password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
          
                      SizedBox(
                        height: 10,
                      ),
                      error_message.isEmpty?
                      const SizedBox():
                      Container(
                        child: Text(error_message ,
                            style: TextStyle(
                                color: Colors.white
                            )),
                        color: Colors.red,
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
          
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              child: Text(
                                "Loggin",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.green,
                              onPressed: (){},
                              // onPressed: () async {
                              //   error_message = "";
                              //   setState(() {
                              //
                              //   });
                              //   // if (!_formKey.currentState!.validate()) {
                              //   //   Fluttertoast.showToast(
                              //   //       msg: "Failed",
                              //   //       toastLength: Toast.LENGTH_LONG,
                              //   //       gravity: ToastGravity.CENTER,
                              //   //       timeInSecForIosWeb: 1,
                              //   //       backgroundColor: Colors.red,
                              //   //       textColor: Colors.white,
                              //   //       fontSize: 16.0);
                              //   //   return;
                              //   // }
                              //   // List<UserRegisreModlel> user2 =  await UserRegisreModlel.get_user_regisre(
                              //   //     where: "username = '$username'"
                              //   // );
                              //   // if(user2.isEmpty){
                              //   //   error_message = "User Account is not found";
                              //   //   setState(() {
                              //   //
                              //   //   });
                              //   //   Fluttertoast.showToast(
                              //   //       msg: "account not found",
                              //   //       toastLength: Toast.LENGTH_LONG,
                              //   //       gravity: ToastGravity.CENTER,
                              //   //       timeInSecForIosWeb: 1,
                              //   //       backgroundColor: Colors.blue.shade800,
                              //   //       textColor: Colors.white,
                              //   //       fontSize: 16.0);
                              //   // }
                              //   // if(user2.first.password != password){
                              //   //   error_message = "invalid password";
                              //   //   setState(() {
                              //   //
                              //   //   });
                              //   //   Fluttertoast.showToast(
                              //   //       msg: "incorect password",
                              //   //       toastLength: Toast.LENGTH_LONG,
                              //   //       gravity: ToastGravity.CENTER,
                              //   //       timeInSecForIosWeb: 1,
                              //   //       backgroundColor: Colors.blue.shade800,
                              //   //       textColor: Colors.white,
                              //   //       fontSize: 16.0);
                              //   //   return;
                              //   // }
                              //   LoggedInUserModel loadedinUser = LoggedInUserModel();
                              //   loadedinUser.id = user2.first.id;
                              //   loadedinUser.name = user2.first.name;
                              //   loadedinUser.username = user2.first.username;
                              //   loadedinUser.password = user2.first.password;
                              //   loadedinUser.email = user2.first.email;
                              //   String  results = await loadedinUser.saveLogeedUser();
                              //   if(results.isNotEmpty){
                              //
                              //     setState(() {
                              //       error_message = results;
                              //     });
                              //   }
                              //
                              //
                              //   Navigator.push(context,
                              //       MaterialPageRoute(builder: (context) =>  const app_dairy_Home_Screen()));
                              //
                              //   return;
                              // },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // Expanded(
                          //   child: MaterialButton(
                          //     color: Colors.green,
                          //     onPressed: () {
                          //       Navigator.push(context,
                          //           MaterialPageRoute(builder: (context) =>  const app_dairy_RegisterScreen()));
                          //     },
                          //     child: Text(
                          //       "Register",
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ));

  }
}

