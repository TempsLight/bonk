import 'package:final_project/pages/deposit_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../resources/service_functions.dart';
import 'transaction_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshUserData();
    });
    _loadUserData();
  }

  Future<void> _refreshUserData() async {
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
          title: Text('Hello, ${user?.name ?? 'Loading...'}'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                logout(context);
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _loadUserData();
          },
          child: ListView(children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Current Balance',
                    style: TextStyle(fontSize: 24),
                  ),
                  Center(
                    child: Text(
                      'Balance: \$${(user?.balance ?? 0)}',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionPage(),
                        ),
                      );
                    },
                    child: const Text('Transfer'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepositPage(
                            refreshCallback: () {
                              _refreshUserData();
                            },
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          user = result;
                        });
                      }
                    },
                    child: const Text('Deposit'),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
