import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';


import '../model/user_model.dart';
import '../services/service_functions.dart';

class DepositPage extends StatefulWidget {
  final Function refreshCallback;

  DepositPage({required this.refreshCallback});
  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final _formKey = GlobalKey<FormState>();
  double? amount;

  User? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  Future<void> refreshUserData() async {
    await _loadUserData();
    setState(() {});
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      User userData = await getUserData(token);
      setState(() {
        user = userData;
      });
    } else {
      // Handle the case when the token is null.
      print('No token found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  amount = double.parse(value);
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      String? token = await getToken(); // Get the token
                      if (token != null && amount != null) {
                        bool success = await depositMoney(token, amount!);
                        if (success) {
                          widget.refreshCallback();
                          Navigator.pop(context); // Navigate back to the previous page
                        }
                      } else {
                        print('Token or amount is null');
                      }
                    } catch (e) {
                      // Handle the error here
                      print('Failed to deposit money: $e');
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}