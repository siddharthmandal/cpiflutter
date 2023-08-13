import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:retailpricesurvey/utils/color.dart';

import 'login_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Position position ;

  void requestLocationPermission(BuildContext context)async {
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (this.mounted) {
    setState(() {
      position = currentPosition;
    });
    }
  }
  @override
  void initState() {
    
    super.initState();
   requestLocationPermission(context);
    Timer(const Duration(milliseconds: 4000), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [orangeColors, orangeLightColors],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
        ),
        child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
 Center(
                      child: Image.asset(
                    "assets/logo.png",
                    height: 130,
                    width: 130,
                    alignment: Alignment.center,
                  )),
                   SizedBox(
                    height: 13,//Director of econonimic & statistic
                  ),
                  Text(
                    "Retail Price Survey",
                    style:TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),
                       
                  ),
                   SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Directorate Of Economics and Statistics",
                    style:TextStyle(color: Colors.white,fontSize: 16),
                       
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Planning & Convergence Department",
                    style:TextStyle(color: Colors.white,fontSize: 14),
                       
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Goverment of Odisha",
                    style:TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),
                       
                  ),

                ],
      ),
      ),
    );
  }
}
