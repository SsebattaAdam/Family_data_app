import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../Authentications4app/authetication_service_Repo.dart';
import 'login.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({Key? key}) : super(key: key);

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {

  String? email;
  String? name;
  String? password;
  String? error_message = "";
  String? phone_number;
  final GlobalKey<FormState> _registerformkey = GlobalKey<FormState>();
  Authentication_repositry? _authrticatedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authrticatedUser =GetIt.instance.get<Authentication_repositry>();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _titleWidget(),
                _RegisterForm(),
                _RegisterButton(),
                _loginpageLink()

              ],
            ),
          )
        ),
      ),
    );
  }

  Widget _titleWidget(){
    return Container(
      child: Text(
        "Register to Family App",
        style: TextStyle(
          color: Colors.green,
          fontSize: 30,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _RegisterForm(){
    return Container(
      height: 350,
      child: Form(
        key: _registerformkey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _nameTextField(),
              SizedBox(height: 20,),
              _emailTextField(),
              SizedBox(height: 20,),
              _phone_numberTextField(),
              SizedBox(height: 20,),
              _passwordTextField(),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
  Widget _nameTextField(){
    return TextFormField(
        decoration: InputDecoration(
          labelText: "Name",
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
          name = value;
        },
        validator:(value) => value!.length> 0? null : "Please enter  name"
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
          email = value;
        },
        validator:(value){
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
        password = value;
      },
      validator: (value) =>
      value!.length > 6 ? null : "Please enter a password with at least six characters",
      enableInteractiveSelection: true,
    );
  }

 Widget _RegisterButton(){
    return MaterialButton(
        onPressed: _registerUser,
        minWidth: double.infinity,
      height: 60,
      color: Colors.green,
      child: Text(
        "Register",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
 }
  Widget _loginpageLink(){
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Login_page()));
      },
      child: Text(
        "Already have an account? Login",
        style: TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.w600,

        ),
      ),
    );
  }
  void _registerUser() async {
    if (_registerformkey.currentState!.validate()){
      _registerformkey.currentState!.save();
      bool _result =await _authrticatedUser!.registerUser(name:name!, password:password!, email:email!, phone_number:phone_number!);
      if (_result) Navigator.pop(context);
    }
  }
}
