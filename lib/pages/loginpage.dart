import 'package:final_project/pages/signuppage.dart';
import 'package:flutter/material.dart';
import '../services/service_functions.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: new Color(0xFFF1F8E9),
                gradient: LinearGradient(
                    colors: [(new Color(0xFFA5D6A7)), (new Color(0xFFC8E6C9))],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          Container(
            margin: EdgeInsets.only(right: 20, top: 30),
            /* insert image */

            alignment: Alignment.center,
            child: Text(
              "LOGIN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0xFF1B5E20),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 60),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[200],
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _emailController,
              cursorColor: Color(0xFF1B5E20),
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.email,
                    color: Color(0xFF1B5E20),
                  ),
                  hintText: "E-mail Address",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[200],
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              cursorColor: Color(0xFF1B5E20),
              decoration: InputDecoration(
                icon: Icon(
                  Icons.vpn_key,
                  color: Color(0xFF1B5E20),
                ),
                hintText: "Password",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF1B5E20),
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {
              login(_emailController.text, _passwordController.text, context)
            },
            child: Container(
              margin: EdgeInsets.only(left: 35, right: 35, top: 60),
              alignment: Alignment.center,
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [(new Color(0xFFA5D6A7)), (new Color(0xFFC8E6C9))],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xFFF1F8E9))
                ],
              ),
              child: Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an Account?"),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()))
                  },
                  child: Text(
                    " Register here",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
