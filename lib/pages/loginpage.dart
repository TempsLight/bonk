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
            decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: Color(0xFFF1F8E9),
                gradient: LinearGradient(
                    colors: [(Color(0xFFA5D6A7)), (Color(0xFFC8E6C9))],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          Container(
            margin: const EdgeInsets.only(right: 20, top: 30),
            alignment: Alignment.center,
            child: const Text(
              "LOGIN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0xFF1B5E20),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 60),
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[200],
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _emailController,
              cursorColor: const Color(0xFF1B5E20),
              decoration: const InputDecoration(
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
            margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[200],
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              cursorColor: const Color(0xFF1B5E20),
              decoration: InputDecoration(
                icon: const Icon(
                  Icons.vpn_key,
                  color: Color(0xFF1B5E20),
                ),
                hintText: "Password",
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF1B5E20),
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => {
              login(_emailController.text, _passwordController.text, context)
            },
            child: Container(
              margin: const EdgeInsets.only(left: 35, right: 35, top: 60),
              alignment: Alignment.center,
              height: 54,
              
              decoration: BoxDecoration(
                
                gradient: const LinearGradient(
                    colors: [(Color(0xFFA5D6A7)), (Color(0xFFC8E6C9))],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Color(0xFFF1F8E9),
                  )
                ],
              ),
              child: const Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an Account?"),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()))
                  },
                  child: const Text(
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
