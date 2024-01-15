
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setting {
  final String title;
  final String route;
  final IconData icon;

  Setting({
    required this.title,
    required this.route,
    required this.icon,
  });
}

final List<Setting> settings = [
  Setting(
    title: "Edit Personal Data",
    route: "/",
    icon: CupertinoIcons.person_fill,
  ),
];

final List<Setting> settings2 = [
  Setting(
    title: "LOGOUT",
    route: "/",
    icon: Icons.logout,
  ),
];