import 'package:flutter/material.dart';
import 'package:retailpricesurvey/pages/login_page.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
             child: Container(
                  child: Text("Retail Price Survey",style: TextStyle( fontSize: 20,backgroundColor:Colors.purple[100],color: Colors.black45)),
                  alignment: Alignment.bottomCenter, // <-- ALIGNMENT
                  height: 12,
                ),
            decoration: BoxDecoration(
                color: Colors.black38,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/cover.png'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Home'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => { 
   Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()))

              },
          ),
        ],
      ),
    );
  }
}