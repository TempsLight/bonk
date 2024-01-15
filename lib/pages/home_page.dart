import 'package:final_project/pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../services/service_functions.dart';
import 'deposit_page.dart';
import 'transaction_page_history.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  User? user;
  String? userToken;
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
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadUserData();
        },
        child: Container(
          padding:
              const EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/walletlogo.webp'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "bONK",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'ubuntu',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      logout(context);
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 5, top: 13),
                alignment: Alignment.centerLeft,
                child: Text(
                  '   Account Overview ${user?.name}',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'ubuntu'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xfff1f3f6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Balance: \$${(user?.balance ?? 0)}',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'ubuntu'),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Account Number: ${user?.phone_number}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'ubuntu'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
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
                          icon:
                              const Icon(Icons.add), // Use the appropriate icon
                          label: const Text('Add'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(
                    top: 5, bottom: 8.0), // Adjust the value as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "  Send Money",
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'ubuntu'),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionPage(
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
                  icon: const Icon(Icons.transfer_within_a_station),
                  label: const Text('Transfer'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "  Transaction History",
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'ubuntu'),
              ),
              SizedBox(
                width: double
                    .infinity, // This will make the button take up the full width available
                child: ElevatedButton.icon(
                  onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionHistoryPage(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          user = result;
                        });
                      }
                    },
                  icon: const Icon(Icons.history), // Use the appropriate icon
                  label: const Text('Transaction History'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
