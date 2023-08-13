import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:retailpricesurvey/Service/middlelayer.dart';
import 'package:retailpricesurvey/Service/shared_service.dart';
import 'package:retailpricesurvey/models/login_model.dart';
import 'package:retailpricesurvey/pages/NewSurvey.dart';
import 'package:retailpricesurvey/pages/Survey.dart';
import 'package:retailpricesurvey/utils/progressbar.dart';
import 'package:retailpricesurvey/widgets/btn_widget.dart';
import 'package:retailpricesurvey/widgets/herder_container.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isApiCallProcess = false;
  TextEditingController truid = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 35),
          child: Column(
            children: <Widget>[
              HeaderContainer("Login"),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _textInput(hint: "Login Id", icon: Icons.email),
                      _buildPasswordTextField(
                          hint: "Password", icon: Icons.vpn_key),
                      // Container(
                      //   margin: EdgeInsets.only(top: 10),
                      //   alignment: Alignment.centerRight,
                      //   child: Text(
                      //     "Forgot Password?",
                      //   ),
                      // ),
                      Expanded(
                        child: Center(
                          child: ButtonWidget(
                            onClick: () {
                              LoginRequestModel loginRequestModel =
                                  new LoginRequestModel();
                              loginRequestModel.Userid = truid.text.trim();
                              loginRequestModel.Password = sha256
                                  .convert(utf8.encode(pass.text.trim()))
                                  .toString();
                              SharedService.logout();
                              Middlelayer mdl = new Middlelayer();
                              setState(() {
                                isApiCallProcess = true;
                              });
                              mdl.login(loginRequestModel).then((value) {
                                if (value != null) {
                                  if (value.VillageCode.isNotEmpty) {
                                  
                                    SharedService.setLoginDetails(value)
                                        .then((value) {
                                      final snackBar = SnackBar(
                                          content: Text("Login Successful"));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      setState(() {
                                        isApiCallProcess = false;
                                      });
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NewSyrveyform()));
                                    });
                                  } else {
                                    setState(() {
                                      isApiCallProcess = false;
                                    });
                                    final snackBar =
                                        SnackBar(content: Text(value.Userid));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              }).catchError((error) {
                                setState(() {
                                  isApiCallProcess = false;
                                });
                                final snackBar =
                                    SnackBar(content: Text(error.message));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            },
                            btnText: "LOGIN",
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "\u00a9 Directorate Of Economics and Statistics ",
                              style: TextStyle(color: Colors.black)),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _textInput({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: truid,
        decoration: InputDecoration(
          // border: InputBorder,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  bool _showPassword = false;

  Widget _buildPasswordTextField({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        obscureText: !this._showPassword,
        controller: pass,
        decoration: InputDecoration(
          // border: InputBorder,
          hintText: hint,
          prefixIcon: Icon(icon),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: this._showPassword ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              setState(() => this._showPassword = !this._showPassword);
            },
          ),
        ),
      ),
    );
  }
}
