import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import 'variable.dart';
import '../models/api_model.dart';
import '../models/user_model.dart';

Future<ApiResponse> register(
    String name, String email, String password, BuildContext context) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse('$ipaddress/users'), headers: {
      'Accept': 'application/json'
    }, body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['response'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Successful'),
              content: Text('User registered successfully'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        break;
      // handle other status codes...
    }
  } catch (e) {
    apiResponse.error = e.toString();
  }

  return apiResponse;
}

Future<void> login(String email, String password, BuildContext context) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse('$ipaddress/users/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      apiResponse.data = User.fromJson(jsonDecode(response.body));

      // Navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );

      // Login Message
      final responseData = jsonDecode(response.body);
      print('Response data: $responseData');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseData['token']);
      print({responseData['token']});
    } else {
      throw Exception(
          'Failed to login with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to login: $e');
    // Handle the exception
  }
}

Future<void> logout(BuildContext context) async {
  bool confirm = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirm'),
      content: Text('Are you sure you want to logout?'),
      actions: <Widget>[
        TextButton(
          child: Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text('Yes'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );

  if (confirm) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}

Future<User> getUserData(String token) async {
  final response = await http.get(
    Uri.parse('$ipaddress/users/me'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    throw Exception('User not found');
  } else {
    throw Exception(
        'Failed to load user data with status code: ${response.statusCode}');
  }
}

Future<bool> depositMoney(String token, double amount) async {
  final response = await http.post(
    Uri.parse('$ipaddress/users/depositMoney'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(
      <String, double>{
        'amount': amount,
      },
    ),
  );

  if (response.statusCode == 200) {
    getUserData(token);
    print('Money deposited successfully');
    return true;
  } else {
    throw Exception('Failed to deposit money');
  }
}

Future<bool> sendMoney(String token, String receiver_id, double amount) async {
  final response = await http.post(
    Uri.parse('$ipaddress/users/sendMoney'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(
      <String, dynamic>{
        'receiver_id': receiver_id,
        'amount': amount,
      },
    ),
  );
  if (response.statusCode == 200) {
    print('Money sent successfully');
    return true;
  } else {
    print(
        'Failed to send money. Status code: ${response.statusCode}, Response body: ${response.body}');
    throw Exception('Failed to send money');
  }
}

Future<List<dynamic>> fetchTransactionHistory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    throw Exception('No token found');
  }

  final response = await http.get(
    Uri.parse('http://192.168.31.97/api/users/transactions'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    // Replace 'transactions' with the actual key of the transaction logs in the JSON response
    return jsonResponse['transactions'];
  } else {
    throw Exception('Failed to fetch transaction history');
  }
}
