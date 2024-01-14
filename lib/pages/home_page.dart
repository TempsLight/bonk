import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../services/service_functions.dart';
import 'deposit_page.dart';

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
          padding: EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/walletlogo.webp'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
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
                    child: Text(
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
                padding: EdgeInsets.only(bottom: 5, top: 13),
                alignment: Alignment.centerLeft,
                child: Text(
                  "  Account Overview",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'ubuntu'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
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
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'ubuntu'),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Current Balance",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'ubuntu'),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
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
                      child: Container(
                        height: 50,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffa5d6a7),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 70,
                      width: 60,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffa5d6a7),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                    avatarWidget("person", "Lite"),
                    avatarWidget("person", "Pitot"),
                    avatarWidget("person", "Kisi"),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '  Services',
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'ubuntu'),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    child: Icon(Icons.dialpad),
                  )
                ],
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 0.7,
                  padding: EdgeInsets.only(top: 13),
                  children: [
                    serviceWidget("sendMoney", "Send\nMoney"),
                    serviceWidget("receiveMoney", "Receive\nMoney"),
                    serviceWidget("phone", "Mobile\nRecharge"),
                    serviceWidget("electricity", "Electricity\nBill"),
                    serviceWidget("tag", "Cashback\nOffer"),
                    serviceWidget("phone", "Movie\nTicket"),
                    serviceWidget("flight", "Flight\nTicket"),
                    serviceWidget("more", "More\n"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column serviceWidget(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/$img.png'),
                  )),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 0.5,
        ),
        Text(
          name,
          style: TextStyle(
            fontFamily: "ubuntu",
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Container avatarWidget(String img, String name) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 150,
      width: 140,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xffe8f5e9)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage('assets/images/$img.png'),
                    fit: BoxFit.contain),
                border: Border.all(color: Color(0xffa5d6a7), width: 2)),
          ),
          Text(
            name,
            style: TextStyle(
                fontSize: 16,
                fontFamily: "ubuntu",
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
