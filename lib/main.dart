import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widt is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor : Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                child : Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/walletlogo.webp'),
                      fit: BoxFit.contain)
                ),
              ),
            ),

      Center(
        child: Padding( // Add thisee
           padding: EdgeInsets.only(top: 20), // Add this
           child: Text(
            "bONK",
              style: TextStyle(
               fontSize: 50,
                fontFamily: 'ubuntu',
                  fontWeight: FontWeight.w600,
              ),),


            )
           )
          ],
        ),
      ),


         Container(
              margin: EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomePageScreen()
                      ))


                    },

                    child: Text(
                      "GET STARTED",
                      style: TextStyle(
                       fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)

                      ),
                    ),
                  )
                ],
              ),
            )


    ],
  ),
);
}
}
