import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vehicle_management_system/constants/images.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double width;
  double height;
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LOGIN',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.teal[100],
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Colors.teal,
                      ),
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.blueGrey[700]),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                // password field
                Container(
                  width: width * 0.85,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.teal[100],
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    obscureText: visible ? false : true,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            visible = !visible;
                          });
                        },
                        child: Icon(
                          visible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.teal,
                        ),
                      ),
                      icon: Icon(
                        Icons.lock,
                        color: Colors.teal,
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.blueGrey[700]),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                // login button
                GestureDetector(
                  child: Container(
                    width: width * 0.85,
                    height: 45,
                    child: Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.white),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                      style: TextStyle(color: Colors.teal),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
