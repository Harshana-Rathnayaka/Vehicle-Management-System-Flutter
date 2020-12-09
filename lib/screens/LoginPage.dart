import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vehicle_management_system/constants/images.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/screens/AdminHome.dart';
import 'package:vehicle_management_system/screens/SignUp.dart';
import 'package:vehicle_management_system/screens/UserHome.dart';
import 'package:vehicle_management_system/services/NetworkHelper.dart';
import 'package:vehicle_management_system/widgets/MyButton.dart';
import 'package:vehicle_management_system/widgets/MyTextField.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double width;
  double height;
  bool visible = false;
  bool _loading = false;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<http.Response> _login() async {
    setState(() {
      _loading = true;
    });

    final http.Response response = await Network().postData({
      'username': _usernameController.text,
      'password': _passwordController.text
    }, '/userLogin.php');

    print(jsonDecode(response.body));

    setState(() {
      _loading = false;
    });

    return response;
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
                            'LOGIN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28),
                          ),
                          SvgPicture.asset(
                            login_image,
                            height: height * 0.35,
                          ),
                          SizedBox(height: 20),

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
                                _login().then((value) {
                                  var res = jsonDecode(value.body);

                                  if (res['error'] == true) {
                                    Fluttertoast.showToast(
                                        msg: res['message'],
                                        backgroundColor: Colors.red[600],
                                        textColor: Colors.white,
                                        toastLength: Toast.LENGTH_LONG);
                                  } else if (res['error'] == false &&
                                      res['super_user'] == true) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AdminHomePage()));
                                  } else {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UserHomePage()));
                                  }
                                });
                              }
                            },
                            child: MyButton(
                              width: width,
                              text: 'LOGIN',
                              btnColor: Colors.teal,
                              btnRadius: 20,
                            ),
                          ),

                          // link to sign up page
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
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
                                          builder: (BuildContext context) =>
                                              SignUp()));
                                },
                                child: Text(
                                  'Sign up',
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


