import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vehicle_management_system/constants/images.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_management_system/screens/AdminHome.dart';
import 'package:vehicle_management_system/screens/UserHome.dart';
import 'package:vehicle_management_system/services/NetworkHelper.dart';

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
                          // username field
                          Container(
                            width: width * 0.85,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.teal[100],
                                borderRadius: BorderRadius.circular(20)),
                            child: TextFormField(
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              cursorColor: Colors.teal,
                              controller: _usernameController,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.teal,
                                ),
                                hintText: 'Username',
                                hintStyle:
                                    TextStyle(color: Colors.blueGrey[700]),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          // password field
                          Container(
                            width: width * 0.85,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.teal[100],
                                borderRadius: BorderRadius.circular(20)),
                            child: TextFormField(
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              cursorColor: Colors.teal,
                              controller: _passwordController,
                              obscureText: visible ? false : true,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      visible = !visible;
                                    });
                                  },
                                  child: Icon(
                                    visible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.teal,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.teal,
                                ),
                                hintText: 'Password',
                                hintStyle:
                                    TextStyle(color: Colors.blueGrey[700]),
                                border: InputBorder.none,
                              ),
                            ),
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
                            child: Container(
                              width: width * 0.85,
                              height: 45,
                              child: Text(
                                'LOGIN',
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
                                'Don\'t have an account?',
                                style:
                                    TextStyle(color: Colors.teal, fontSize: 16),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
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
