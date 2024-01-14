import 'package:flutter/material.dart';

import '../services/service_functions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
        body: SingleChildScrollView(
      key: _formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              /* insert image */
              height: 90,
              width: 90,
            ),
            Container(
              margin: EdgeInsets.only(top: 60),
              alignment: Alignment.center,
              child: Text(
                "ACCOUNT REGISTRATION",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 50),
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _nameController,
                cursorColor: Color(0xFF1B5E20),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Color(0xFF1B5E20),
                    ),
                    hintText: "Full Name",
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
                controller: _emailController,
                cursorColor: Color(0xFF1B5E20),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Color(0xFF1B5E20),
                    ),
                    hintText: "Enter E-mail",
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
                controller: _phoneNumberController,
                cursorColor: Color(0xFF1B5E20),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.phone,
                      color: Color(0xFF1B5E20),
                    ),
                    hintText: "Phone Number",
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
                obscureText: true,
                cursorColor: Color(0xFF1B5E20),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.vpn_key,
                      color: Color(0xFF1B5E20),
                    ),
                    hintText: "Password",
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            GestureDetector(
              onTap: () async {
                bool registrationSuccessful = await register(
                  _nameController.text,
                  _emailController.text,
                  _passwordController.text,
                  _phoneNumberController.text,
                  context,
                );
                if (registrationSuccessful) {
                  _nameController.clear();
                  _emailController.clear();
                  _passwordController.clear();
                  _phoneNumberController.clear();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Registration Successful'),
                        content: const Text('Registered Successfully'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  Navigator.pop(context);
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 35, right: 35, top: 60),
                alignment: Alignment.center,
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    (new Color(0xFFA5D6A7)),
                    (new Color(0xFFC8E6C9))
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xFFF1F8E9))
                  ],
                ),
                child: Text(
                  "REGISTER",
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
                  Text("Already a Member?"),
                  GestureDetector(
                    onTap: () => {Navigator.pop(context)},
                    child: Text(
                      " Login Here",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
