import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../services/service_functions.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            if (user != null) ...[
              ListTile(
                title: const Text('Name'),
                subtitle: Text('${user?.name}'),
              ),
              ListTile(
                title: const Text('Email'),
                subtitle: Text('${user?.email}'),
              ),
              ListTile(
                title: const Text('Balance'),
                subtitle: Text('\$${user!.balance}'),
              ),
              ListTile(
                title: const Text('Account Number'),
                subtitle: Text('${user?.phone_number}'),
              ),
              // Add more fields as needed...
            ],
            ElevatedButton(
              onPressed: () {
                
               Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
