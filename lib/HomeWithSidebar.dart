import 'package:flutter/material.dart';
import 'home_page.dart';

class HomeWithSidebar extends StatefulWidget {
  @override
  _HomeWithSidebarState createState() => _HomeWithSidebarState();
}

class _HomeWithSidebarState extends State<HomeWithSidebar> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeWithSidebar(),
    );
  }
}

class _HomeWithSidebar extends StatefulWidget {
  @override
  _HomeWithSidebarState createState() => _HomeWithSidebarState();
}

class __HomeWithSidebarState extends State<HomeWithSidebar> {
  bool sidebarActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
                      color: Colors.white
                    ),
                     child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/person.png'),
                                fit: BoxFit.contain
                              )
                            ),

                          )
                        ],

                      )
                    ),


                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
