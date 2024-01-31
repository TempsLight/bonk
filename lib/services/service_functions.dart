// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:final_project/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/api_model.dart';

import '../model/user_model.dart';

import '../pages/menu.dart';
import 'variable.dart';

Future<bool> register(String name, String email, String password,
    String phone_number, String sex, int age, BuildContext context) async {
  ApiResponse apiResponse = ApiResponse();
  bool registrationSuccessful = false;

  try {
    final response = await http.post(Uri.parse('$ipaddress/users'), headers: {
      'Accept': 'application/json'
    }, body: {
      'name': name,
      'email': email,
      'phone_number': phone_number,
      'password': password,
      'password_confirmation': password,
      'age': age.toString(),
      'sex': sex
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['response'];
        registrationSuccessful = true;
        break;
      default:
        print(
            'Received ${response.statusCode} from the server: ${response.body}');
        break;
    }
  } catch (e) {
    apiResponse.error = e.toString();
    print(e);
  }

  return registrationSuccessful;
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
        MaterialPageRoute(
          builder: (context) => MyBottomNavBar(),
        ),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Successful'),
            content: const Text('You have successfully logged in.'),
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

      // Login Message
      final responseData = jsonDecode(response.body);
      print('Response data: $responseData');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseData['token']);
      var id = responseData['user']['id'];

      String? userId = id != null ? id.toString() : null;
      if (userId != null) {
        await prefs.setString('userId', userId);
      } else {
        print('User ID is null');
      }

      print({responseData['user']['id']});
      print({responseData['token']});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Wrong email or password.'),
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
      throw Exception(
          'Failed to login with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to login: $e');
  }
}

Future<void> logout(BuildContext context) async {
  bool confirm = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm'),
      content: const Text('Are you sure you want to logout?'),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('Yes'),
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
        builder: (context) => LoginScreen(),
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

Future<bool> depositMoney(
    String token, double amount, String phone_number) async {
  final response = await http.post(
    Uri.parse('$ipaddress/users/depositMoney'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(
      <String, dynamic>{
        'amount': amount,
        'phone_number': phone_number,
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

Future<bool> sendMoney(String token, String phone_number, double amount) async {
  final response = await http.post(
    Uri.parse('$ipaddress/users/sendMoney'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(
      <String, dynamic>{
        'phone_number': phone_number,
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
    Uri.parse('$ipaddress/users/transactions'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    return jsonResponse['transactions'];
  } else {
    throw Exception('Failed to fetch transaction history');
  }
}

Future<void> deleteTransactionHistory(String transactionId) async {
  final String url = '$ipaddress/transactions/$transactionId';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  final response = await http.delete(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('Transaction deleted successfully');
  } else {
    throw Exception('Failed to delete transaction');
  }
}

Future<void> editProfile(String name, String email, context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final currentName = prefs.getString('name') ?? '';
  final currentEmail = prefs.getString('email') ?? '';

  if (token == null) {
    throw Exception('No token found');
  }
  String? userId = prefs.getString('userId');
  if (userId == null) {
    throw Exception('No user ID found');
  }

  final response = await http.put(
    Uri.parse('$ipaddress/users/edit/${userId}'),
    body: jsonEncode({
      'name': name.isNotEmpty ? name : currentName,
      'email': email.isNotEmpty ? email : currentEmail,
    }),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    prefs.setString('name', name.isNotEmpty ? name : currentName);
    prefs.setString('email', email.isNotEmpty ? email : currentEmail);

    print('Profile Updated Successfully');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profile Updated'),
          content: const Text('Your profile has been updated successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (Navigator.of(context).canPop()) {
                  // Check if there's a page that can be popped
                  Navigator.of(context)
                      .pop(); // Navigate back to the previous page
                }
              },
            ),
          ],
        );
      },
    );
  } else {
    print('Failed to update profile. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401) {
      print('Unauthorized - Token might be invalid');
    } else if (response.statusCode == 404) {
      print('Not Found - User not found on the server');
    } else {
      print('An error occurred. Please try again later.');
    }
  }
}

Future<List<Map<String, dynamic>>> fetchTransactionData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    throw Exception('No token found');
  }

  final response = await http.get(
    Uri.parse('$ipaddress/users/transactions'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return [jsonResponse];
  } else {
    throw Exception('Failed to fetch transaction history');
  }
}

Future<List<Map<String, dynamic>>> depositMoneyData() async {
  List<Map<String, dynamic>> transactions =
      (await fetchTransactionHistory()).cast<Map<String, dynamic>>();

  // Filter transactions of type 'deposit'
  List<Map<String, dynamic>> depositTransactions =
      transactions.where((transaction) {
    return transaction['type'] == 'deposit';
  }).toList();

  // Map each transaction to a new map containing only the date and amount
  List<Map<String, dynamic>> result = depositTransactions.map((transaction) {
    return {
      'date': transaction['date'],
      'amount': transaction['amount'],
    };
  }).toList();

  return result;
}



