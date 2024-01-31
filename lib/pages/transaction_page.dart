import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import '../services/service_functions.dart';

class TransactionPage extends StatefulWidget {
  final Function refreshCallback;
  TransactionPage({required this.refreshCallback});
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final phone_number = TextEditingController();
  final amount = TextEditingController();

  User? user;
  @override
  void dispose() {
    phone_number.dispose();
    amount.dispose();
    super.dispose();
  }

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
        title: const Text('Send Money'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: phone_number,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone numbera';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: amount,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    String? token = await getToken(); // Get the token
                    if (token != null && phone_number.text.isNotEmpty) {
                      bool success = await sendMoney(
                          token, phone_number.text, double.parse(amount.text));
                      if (success) {
                        await widget.refreshCallback();
                        Navigator.pop(context);
                        print('Money sent successfully');
                        // Add any additional actions on success, like navigating to another page
                      }
                    } else {
                      print('Token, phone_number or amount is null');
                    }
                  } catch (e) {
                    // Handle the error here
                    print('Failed to send money: $e');
                  }
                },
                child: const Text('Send Money'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
