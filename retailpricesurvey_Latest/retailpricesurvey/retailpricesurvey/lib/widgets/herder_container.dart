import 'package:flutter/material.dart';
import 'package:retailpricesurvey/utils/color.dart';

class HeaderContainer extends StatelessWidget {
  var text = "Login";

  HeaderContainer(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [orangeColors, orangeLightColors],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 20,
              right: 20,
              child: Text(
            text,
            style: TextStyle(color: Colors.white,fontSize: 20,fontStyle: FontStyle.italic),
          )),
           Container(
              child: Column(
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
                    height: 13,
                  ),
                  Text(
                    "Retail Price Survey",
                    style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                       
                  ),
                ]
                ),
                ),
         
        ],
      ),
    );
  }
}
