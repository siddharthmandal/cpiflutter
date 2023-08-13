import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:retailpricesurvey/Service/middlelayer.dart';
import 'package:retailpricesurvey/Service/shared_service.dart';
import 'package:retailpricesurvey/models/login_model.dart';
import 'package:retailpricesurvey/pages/Surveyformtwo.dart';
import 'package:retailpricesurvey/utils/progressbar.dart';

import 'Surveyformone.dart';
import 'login_page.dart';

class Surveyform extends StatefulWidget {
  @override
  _SurveyformState createState() => _SurveyformState();
}

class _SurveyformState extends State<Surveyform> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  bool isApiCallProcess = false;
  Itemdetails idmt;
  Middlelayer mdl = new Middlelayer();
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _surveySetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _surveySetup(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Retail Price Survey'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                type: stepperType,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                onStepCancel: cancel,
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _currentStep == 1 // this is the last step
                            ? ElevatedButton.icon(
                                icon: Icon(Icons.create),
                                onPressed: onStepContinue,
                                label: Text('SUBMIT'),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green)),
                              )
                            : ElevatedButton.icon(
                                icon: Icon(Icons.navigate_next),
                                onPressed: onStepContinue,
                                label: Text('CONTINUE'),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue)),
                              ),
                        SizedBox(
                          width: 12,
                        ),
                        _currentStep == 1 // this is the last step
                            ? ElevatedButton.icon(
                                icon: Icon(Icons.delete_forever),
                                label: const Text('BACK'),
                                onPressed: onStepCancel,
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.orange)),
                              )
                            : ElevatedButton.icon(
                                icon: Icon(null),
                                label: const Text(''),
                                onPressed: null,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent),
                                ),
                              )
                      ],
                    ),
                  );
                },
                steps: <Step>[
                  Step(
                    title: new Text('Step-1'),
                    content: Surveyformfirst(),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Step-2'),
                    content: Surveyformtwo(idmt: idmt),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _switchStepsType(context);
        },
        label: Text('Logout'),
        icon: Icon(Icons.offline_bolt),
      ),
    );
  }

  Future<void> _switchStepsType(context) async {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure to Logout?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    SharedService.logout().then(
                      (_) => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage())),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  Future<void> _FinalSave(context) async {
    setState(() {
      isApiCallProcess = true;
    });
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        isApiCallProcess = false;
      });
      return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Warning'),
                content: const Text('Location services are disabled.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Ok'),
                    child: const Text('Ok'),
                  ),
                ],
              ));
    } else {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          isApiCallProcess = false;
        });
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Warning'),
                  content: const Text('Location services Permission denied.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Ok'),
                      child: const Text('Ok'),
                    ),
                  ],
                ));
      } else if (permission == LocationPermission.deniedForever) {
        setState(() {
          isApiCallProcess = false;
        });
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Warning'),
                  content: const Text('Location services Permission denied.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Ok'),
                      child: const Text('Ok'),
                    ),
                  ],
                ));
      } else {
        Position position;
        Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        setState(() {
          isApiCallProcess = false;
          position = currentPosition;
        });
        _saveonserver(context, position.latitude.toString(),
            position.longitude.toString());
      }
    }
  }

  Future<void> _saveonserver(context, lat, lng) async {
    try {
      setState(() {
        isApiCallProcess = true;
      });
      Addsurvey ads = new Addsurvey();
      ads.itemCode = idmt.itemcode;
      ads.itemName = idmt.itemname;
      ads.prvPrice1 = idmt.prvprice1;
      ads.prvPrice2 = idmt.prvprice2;
      ads.price = SurveyformtwoState.controllerPrice.text.toString();
      ads.splCode = idmt.spcode;
      ads.shopCode = idmt.shopcode;
      ads.unit = idmt.unit;
      ads.qty = idmt.qty;
      ads.remarks = SurveyformtwoState.controllerremark.text.toString();
      ads.villageCode = idmt.villagecode;
      ads.month = idmt.month;
      ads.year = idmt.year;
      ads.lang = lat;
      ads.lat = lng;
      String succrep = await mdl.addSurveydetails(ads);
      setState(() {
        isApiCallProcess = false;
      });
      if (succrep == 'true') {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Confirm'),
                  content: const Text('Successfully Submitted.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Ok');
                        SurveyformfirstState.controllerFirstName.clear();
                        SurveyformtwoState.controllerPrice.clear();
                        SurveyformtwoState.controllerItemName.clear();
                        SurveyformtwoState.controllerpre.clear();
                        SurveyformtwoState.controllerremark.clear();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Surveyform()));
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                ));
      } else {
        final snackBar = SnackBar(content: Text('Oops! something wrong.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (excp) {
      setState(() {
        isApiCallProcess = false;
      });
      final snackBar = SnackBar(content: Text(excp.message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep < 1 &&
        SurveyformfirstState.formKey.currentState.validate()) {
      mdl
          .validmonthyear(
              SurveyformfirstState.monthname, SurveyformfirstState.idtm.year)
          .then((value) {
        if (value == "valid") {
          setState(() {
            _currentStep += 1;
            
            idmt = SurveyformfirstState.idtm;
           
          });
        } else {
          final snackBar = SnackBar(content: Text("Invalid Month & Year."));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } else if (_currentStep == 1 &&
        SurveyformtwoState.formKey.currentState.validate()) {
      _FinalSave(context);
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() { _currentStep -= 1;
     SurveyformfirstState.controllerFirstName.clear();
                        SurveyformtwoState.controllerPrice.clear();
                        SurveyformtwoState.controllerItemName.clear();
                        SurveyformtwoState.controllerpre.clear();
                        SurveyformtwoState.controllerremark.clear();
    }
    ) : null;
  }
}
