import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:public_transportation_tracker/main.dart';
import 'package:public_transportation_tracker/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late Box hiveBox;

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  bool isChecked = false;

  @override
  void initState() {
    createOpenBox();
    super.initState();
  }

  void createOpenBox() async {
    hiveBox = await Hive.openBox("rememberMe");
    getRememberMe();
  }

  void getRememberMe() async {
    if (hiveBox.get("email") != null) {
      emailController.text = hiveBox.get("email");
      isChecked = true;
      setState(() {});
      print(email);
    }
    if (hiveBox.get("password") != null) {
      passwordController.text = hiveBox.get("password");
      isChecked = true;
      setState(() {});
      print(password);
    }
  }

  bool obscureText = true;

  var passwordIcon = Icons.visibility_off;

  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color.fromARGB(255, 255, 109, 99);
      }
      return Color(0xff3099EC);
    }

    final emailField = Material(
      shadowColor: Theme.of(context).shadowColor,
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: TextFormField(
        onSaved: (value) {
          email = value!;
        },
        validator: (value) {
          if (value!.isEmpty) {
            Fluttertoast.showToast(msg: "Please enter your email.");
          }

          // Reg Exp for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            Fluttertoast.showToast(msg: "Please enter a valid email.");
          }
          return null;
        },
        key: Key("email"),
        controller: emailController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).cardColor,
          // hintText: "Email",
          labelText: "Email",
          labelStyle: TextStyle(
            color: Color(0xff3099EC),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.mail,
            color: Color(0xff3099EC),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );

    final passwordField = Material(
      shadowColor: Theme.of(context).shadowColor,
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      child: TextFormField(
        onSaved: (value) {
          password = value!;
        },
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter a valid password (min 6 chars)");
          }
          return null;
        },
        key: Key("password"),
        controller: passwordController,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).cardColor,
          // hintText: "Password",
          labelText: "Password",
          labelStyle: TextStyle(
            color: Color(0xff3099EC),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.vpn_key,
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
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );

    final loginButton = SizedBox(
      width: double.infinity, // <-- match_parent
      height: 50, // <-- match-parent
      child: ElevatedButton(
        key: Key("login"),
        onPressed: () {
          _formKey.currentState!.save();
          if (isChecked) {
            hiveBox.put("email", email);
            hiveBox.put("password", password);
          } else {
            hiveBox.delete("email");
            hiveBox.delete("password");
          }
          signIn(emailController.text, passwordController.text);
        },
        child: Text(
          "LOGIN",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 26),
        ),
        style: ElevatedButton.styleFrom(
          primary: Color(0xff3099EC),
          shadowColor: Color(0xff3099EC),
          elevation: 5,
          // padding: EdgeInsets.symmetric(horizontal: 130, vertical: 14),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30),
          ),
          textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                  ),
                  Image(
                    image: AssetImage("assets/images/logo.png"),
                    width: 250,
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 28.0, right: 28, top: 0),
                    child: emailField,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 28.0, right: 28, top: 18),
                    child: passwordField,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 27),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Remember Me",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff3099EC),
                          ),
                        ),
                        Checkbox(
                          value: isChecked,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          onChanged: (value) {
                            // print("clicked");
                            isChecked = !isChecked;
                            setState(
                              () {
                                isChecked = value!;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 28.0, right: 28, top: 28),
                    child: loginButton,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          "Don't Have an Account ? ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ));
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Color(0xff3099EC),
                                fontWeight: FontWeight.w400,
                                fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
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

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(
                      msg: "Login Successful",
                      backgroundColor: Color.fromARGB(255, 0, 202, 104),
                      gravity: ToastGravity.TOP),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MyApp())),
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
        Fluttertoast.showToast(msg: errorMessage!, backgroundColor: Colors.red);
        print(error.code);
      }
    }
  }
}
