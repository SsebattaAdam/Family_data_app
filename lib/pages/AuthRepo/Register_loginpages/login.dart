


import 'package:family_data/pages/AuthRepo/Register_loginpages/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';


import '../../homepage.dart';
import '../Authentications4app/authetication_service_Repo.dart';

class Login_page extends StatefulWidget {
   Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pageState();


}

class _Login_pageState extends State<Login_page> {
  final GlobalKey<FormState> _loginformkey = GlobalKey<FormState>();
  Authentication_repositry? _authrticatedUser;
  String? _email;

  String? _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authrticatedUser = GetIt.instance.get<Authentication_repositry>();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
     body: SafeArea(
       child: Container(

         child: Center(
           child: Column(
             mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
             mainAxisSize: MainAxisSize.max,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               _titleWidget(),
               login_Form(),
               _registerpageLink(),


             ],
           )
         )
       ),
     )
    );

  }

  Widget login_Form(){
    return Container(
      height: 300,
      child: Form(
        key: _loginformkey,
        child: Column(

          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _emailTextField(),
            SizedBox(height: 20,),
            _passwordTextField(),

            SizedBox(height: 30,),
            loginButton(),
          ],
        )
      ),
    );
  }

  Widget _emailTextField(){
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
    onSaved: (value){
        _email = value;
    },
        validator:(value){
         bool _results = value!.contains(
        RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'));
         return _results ? null : "Please enter a valid email";
        }
    );
  }

   Widget _passwordTextField() {
     return TextFormField(
       obscureText: true,
       decoration: InputDecoration(
         labelText: "Password",
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
         _password = value;
       },
       validator: (value) =>
       value!.length > 6 ? null : "Please enter a password with at least six characters",
       enableInteractiveSelection: true,
     );
   }

   Widget _titleWidget(){
    return Text(
      "Login to The Family App",
      style: TextStyle(
        color: Colors.green,
        fontSize: 26,
        fontWeight: FontWeight.w600,

      ),
    );
  }

  Widget loginButton(){
    return MaterialButton(
      onPressed: loginUser,
      child: Text("Login", style: TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.w600,

      ),),
      color: Colors.green,
      minWidth: double.infinity,
      height: 50,
    );
  }

  Widget _registerpageLink(){
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Registerpage()));
      },
      child: Text(
        "Don't have an account? Register",
        style: TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.w600,

        ),
      ),
    );
  }

  bool isAdmin = false; // Initialize as false initially

  void loginUser() async {
    if (_loginformkey.currentState!.validate()) {
      _loginformkey.currentState!.save();

      // Assuming you are using _authrticatedUser to track the user's authentication status
      bool isAuthenticated = await _authrticatedUser!.loginUser(email: _email!, password: _password!);

      if (isAuthenticated) {
        isAdmin = _email == "admin1@gmail.com" && _password == "Admin1234";

        if (isAdmin) {
          // Admin login
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
        } else {
          // Regular user login
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
        }
      } else {
        // Handle invalid login
        print("Invalid login credentials");
        // You can show an error message or take other actions here
      }
    }
  }


}
