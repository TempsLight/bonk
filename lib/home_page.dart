import 'package:flutter/material.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/walletlogo.webp'),
                        fit: BoxFit.contain)
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text("bONK",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'ubuntu',
                    ),),
                    
                   
                ],
              ),

               SizedBox(height: 17,),
               Container(
                margin: EdgeInsets.only(right: 150),
                child: Text("Account Overview", style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                fontFamily: 'ubuntu',
              ),),
               )

            ],   
          ),      
        ),

  



      ),
    );
    
  }
}