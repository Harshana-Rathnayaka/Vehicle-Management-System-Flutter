import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vehicle_management_system/constants/images.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/screens/LoginPage.dart';
import 'package:vehicle_management_system/services/NetworkHelper.dart';
import 'package:vehicle_management_system/widgets/MyTextField.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  double width;
  double height;
  bool visible = false;
  bool _loading = false;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<http.Response> _register() async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().postData({
      'username': _usernameController.text,
      'email': _emailController.text,
      'password': _passwordController.text
    }, '/registerUser.php');

    print(jsonDecode(response.body));

    setState(() {
      _loading = false;
    });

    return response;
  }

  String validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);

    if (value.isEmpty) {
      return 'Email address is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'REGISTER',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28),
                          ),
                          SvgPicture.asset(
                            login_image,
                            height: width * 0.50,
                          ),
                          SizedBox(height: 20),
                          // // username field

                          // // email field
                          // Container(
                          //   width: width * 0.85,
                          //   padding: const EdgeInsets.symmetric(horizontal: 20),
                          //   margin: const EdgeInsets.symmetric(
                          //       horizontal: 20, vertical: 10),
                          //   decoration: BoxDecoration(
                          //       color: Colors.teal[100],
                          //       borderRadius: BorderRadius.circular(20)),
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.emailAddress,
                          //     validator: (val) {
                          //       return validateEmail(val);
                          //     },
                          //     cursorColor: Colors.teal,
                          //     controller: _emailController,
                          //     decoration: InputDecoration(
                          //       icon: Icon(
                          //         Icons.email,
                          //         color: Colors.teal,
                          //       ),
                          //       hintText: 'Email',
                          //       hintStyle:
                          //           TextStyle(color: Colors.blueGrey[700]),
                          //       border: InputBorder.none,
                          //     ),
                          //   ),
                          // ),

                          // // password field
                          // Container(
                          //   width: width * 0.85,
                          //   padding: const EdgeInsets.symmetric(horizontal: 20),
                          //   margin: const EdgeInsets.symmetric(
                          //       horizontal: 20, vertical: 10),
                          //   decoration: BoxDecoration(
                          //       color: Colors.teal[100],
                          //       borderRadius: BorderRadius.circular(20)),
                          //   child: TextFormField(
                          //     validator: (val) {
                          //       if (val.isEmpty) {
                          //         return 'Password is required';
                          //       }
                          //       return null;
                          //     },
                          //     cursorColor: Colors.teal,
                          //     controller: _passwordController,
                          //     obscureText: visible ? false : true,
                          //     decoration: InputDecoration(
                          //       suffixIcon: GestureDetector(
                          //         onTap: () {
                          //           setState(() {
                          //             visible = !visible;
                          //           });
                          //         },
                          //         child: Icon(
                          //           visible
                          //               ? Icons.visibility
                          //               : Icons.visibility_off,
                          //           color: Colors.teal,
                          //         ),
                          //       ),
                          //       icon: Icon(
                          //         Icons.lock,
                          //         color: Colors.teal,
                          //       ),
                          //       hintText: 'Password',
                          //       hintStyle:
                          //           TextStyle(color: Colors.blueGrey[700]),
                          //       border: InputBorder.none,
                          //     ),
                          //   ),
                          // ),

                          // username
                          MyTextField(
                            controller: _usernameController,
                            hint: "Username",
                            width: width,
                            icon: Icons.person,
                            validation: (val) {
                              if (val.isEmpty) {
                                return "Username is required";
                              }
                              return null;
                            },
                          ),

                          // email
                          MyTextField(
                            controller: _emailController,
                            hint: "Email",
                            width: width,
                            isEmail: true,
                            icon: Icons.email,
                            validation: (val) {
                              return validateEmail(val);
                            },
                          ),

                          // password
                          MyTextField(
                            controller: _passwordController,
                            hint: "Password",
                            width: width,
                            isPassword: true,
                            isSecure: true,
                            icon: Icons.lock,
                            validation: (val) {
                              if (val.isEmpty) {
                                return "Password is required";
                              }
                              return null;
                            },
                          ),

                          // login button
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                _register().then((value) {
                                  var res = jsonDecode(value.body);

                                  if (res['error'] == true) {
                                    Fluttertoast.showToast(
                                        msg: res['message'],
                                        backgroundColor: Colors.red[600],
                                        textColor: Colors.white,
                                        toastLength: Toast.LENGTH_LONG);
                                  } else if (res['error'] == false) {
                                    Fluttertoast.showToast(
                                        msg: res['message'],
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        toastLength: Toast.LENGTH_LONG);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LoginPage()));
                                  }
                                });
                              }
                            },
                            child: Container(
                              width: width * 0.85,
                              height: 45,
                              child: Text(
                                'SIGNUP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),

                          // link to sign up page
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style:
                                    TextStyle(color: Colors.teal, fontSize: 16),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => LoginPage()));
                                },
                                child: Text(
                                  'Log in',
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
