import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:public_transportation_tracker/login_screen.dart';
import 'package:public_transportation_tracker/model/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _fnameController = new TextEditingController();
  TextEditingController _lnameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  bool obscureText = true;

  var passwordIcon = Icons.visibility_off;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final signupButton = SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          signUp(_emailController.text, _passwordController.text);
        },
        key: Key("register"),
        child: Text(
          "SIGN UP",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 26),
        ),
        style: ElevatedButton.styleFrom(
          primary: Color(0xff3099EC),
          shadowColor: Color(0xff3099EC),
          elevation: 5,
          // padding: EdgeInsets.symmetric(horizontal: 115, vertical: 8),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30),
          ),
          textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 90,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Image(
                      image: AssetImage("assets/images/signup.png"),
                      width: 230,
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 28.0, right: 28, top: 0),
                        child: TextFormField(
                          controller: _emailController,
                          // onSaved: (value) {
                          //   email = value!;
                          //   print(email);
                          // },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            labelText: "Email",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff3099EC)),
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Color(0xff3099EC),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(111, 161, 161, 161)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(111, 161, 161, 161)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 28.0, right: 28, top: 18),
                        child: TextFormField(
                          controller: _fnameController,
                          // onSaved: (value) {
                          //   fname = value!;
                          //   print(fname);
                          // },
                          key: Key("fname"),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            labelText: "First Name",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff3099EC)),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color(0xff3099EC),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(111, 161, 161, 161)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(111, 161, 161, 161)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 28.0, right: 28, top: 18),
                        child: TextFormField(
                          controller: _lnameController,
                          // onSaved: (value) {
                          //   lname = value!;
                          //   print(lname);
                          // },
                          key: Key("lname"),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            labelText: "Last Name",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff3099EC)),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color(0xff3099EC),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(111, 161, 161, 161)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(111, 161, 161, 161)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 28.0, right: 28, top: 18),
                        child: TextFormField(
                          controller: _passwordController,
                          // onSaved: (value) {
                          //   password = value!;
                          //   print(password);
                          // },
                          key: Key("password"),
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            labelText: "Password",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff3099EC)),
                            prefixIcon: Icon(
                              Icons.vpn_key_sharp,
                              color: Color(0xff3099EC),
                            ),
                            suffixIcon: InkWell(
                              splashColor: Colors.transparent,
                              onTap: _hideUnhidePassword,
                              child: Icon(
                                passwordIcon,
                                color: Color(0xff3099EC),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(111, 161, 161, 161)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(111, 161, 161, 161)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 28.0, right: 28, top: 28, bottom: 20),
                        child: signupButton,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _hideUnhidePassword() async {
    setState(() {
      obscureText = !obscureText;
      if (obscureText == true) {
        passwordIcon = Icons.visibility_off;
      } else {
        passwordIcon = Icons.visibility;
      }
    });
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message, backgroundColor: Colors.red);
          print(e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = _fnameController.text;
    userModel.secondName = _lnameController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(
        msg: "Account created successfully :) ", backgroundColor: Colors.green);

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }
}
