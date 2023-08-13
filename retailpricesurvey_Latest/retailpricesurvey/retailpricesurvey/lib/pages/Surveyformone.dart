import 'package:flutter/material.dart';
import 'package:retailpricesurvey/Service/middlelayer.dart';
import 'package:retailpricesurvey/Service/shared_service.dart';
import 'package:retailpricesurvey/models/login_model.dart';
import 'package:retailpricesurvey/pages/login_page.dart';

class Surveyformfirst extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SurveyformfirstState();
  }
}

class SurveyformfirstState extends State<Surveyformfirst> {
  Middlelayer mdl;
  Future<Villagedet> futurevillage;
  List<yearmonthdet> _futureyearlist = [];
  List<yearmonthdet> _futuremonthlist = [];
  List<Categoryitem> _categorylist = [];
  List<itemlist> _citemlist = [];
  String year, month, category, item, villageid;
  static Itemdetails idtm;
  Future<LoginResponseModel> loginResponseModel;
  String _setvillage = null;
  static String monthname;
  static final formKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  static TextEditingController controllerFirstName =
      new TextEditingController();
  static TextEditingController controllerLastName = new TextEditingController();
  static TextEditingController controllerdescription =
      new TextEditingController();
  static TextEditingController controllerqty = new TextEditingController();
  static TextEditingController controllerunit = new TextEditingController();
  var saveyear, savemonth, categsaved;
  Future<void> getdata() async {
    saveyear = await SharedService.getyearDetails();
    savemonth = await SharedService.getmonthDetails();
    categsaved = await SharedService.getcategoryDetails();
  }
  Future<void> getitem() {
     year = year == null
                    ? _futureyearlist
                        .firstWhere((i) => i.selected == true)
                        .value
                    : year;
                month = month == null
                    ? _futuremonthlist
                        .firstWhere((i) => i.selected == true)
                        .value
                    : month;
                    
 mdl.fetchItem(villageid, category, year, month).then((ivalue) {
            setState(() {
              _citemlist = ivalue;
            });
          });
  }

  Future <void> getfinalyr()
  async {
       mdl.fetchyear().then((value) {
              setState(() {
                _futureyearlist = value.year;
                _futuremonthlist = value.month;

                year = saveyear == null
                    ? _futureyearlist
                        .firstWhere((i) => i.selected == true)
                        .value
                    : saveyear;
                month = savemonth == null
                    ? _futuremonthlist
                        .firstWhere((i) => i.selected == true)
                        .value
                    : savemonth;
              });
            });
  }

  Future<void> fetchcate() {
    getdata();
    mdl.fetchCAtegory().then((value) {
      setState(() {
        _categorylist = value;

        if (categsaved != null) {
          category = categsaved;
          setState(() {
            _citemlist.clear();
            _citemlist = [];
            item = null;
          });
          getitem();

         
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    mdl = new Middlelayer();

    SharedService.isLoggedIn().then((value) {
      if (value == false) {
        SharedService.logout().then(
          (_) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage())),
        );
      } else {
        try {
          getdata();
          SharedService.loginDetails().then((value) async {
            villageid = value.VillageCode;
            mdl.fetchvillage(value.VillageCode).then((vvalue) {
              _setvillage = vvalue.villageName;
              SurveyformfirstState.controllerFirstName.text =
                  _setvillage.toString();
            });

         await getfinalyr();
            fetchcate();

            setState(() {
              SurveyformfirstState.controllerdescription.text = "";
              SurveyformfirstState.controllerqty.text = "";
              SurveyformfirstState.controllerunit.text = "";
            });
          });
        } catch (exc) {
          final snackBar = SnackBar(content: Text(exc.message.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
//       return ProgressHUD(
//       child: _surveyFirstSetup(context),
//       inAsyncCall: isApiCallProcess,
//       opacity: 0.3,
//     );
//   }
// Widget _surveyFirstSetup(BuildContext context) {
    return Container(
      child: Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              maxLines: 1,
              readOnly: true,
              enableInteractiveSelection: false,
              controller: controllerFirstName,
              decoration: InputDecoration(
                labelText: 'Village/Market ',
                fillColor: Colors.grey[120],
                filled: true,
                labelStyle: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                prefixIcon: const Icon(
                  Icons.shop,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return "Market is Required";
                }
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              items: _futureyearlist?.map((yearmonthdet value) {
                    return DropdownMenuItem<String>(
                      value: value.value,
                      child: Text(value.name),
                    );
                  })?.toList() ??
                  [],
              onChanged: (value) async {
                SharedService.setyearDetails(value);
                setState(() {
                  year = value;
                  idtm.year = year;
                  idtm.month = month;
                });
                fetchcate();
              },
              value: year,
              validator: (value) =>
                  value == null ? 'Please fill in year' : null,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Select Year',
                labelStyle: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                hintText: "Select Year",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              elevation: 1,
              style: TextStyle(color: Colors.black, fontSize: 14),
              isDense: true,
              iconSize: 25.0,
              iconEnabledColor: Colors.black,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              items: _futuremonthlist?.map((yearmonthdet value) {
                    return DropdownMenuItem<String>(
                      value: value.value,
                      child: Text(value.name),
                    );
                  })?.toList() ??
                  [],
              onChanged: (value) async {
                SharedService.setmonthDetails(value);
                setState(() {
                  month = value;
                  monthname =
                      _futuremonthlist.firstWhere((o) => o.value == value).name;
                  idtm.year = year;
                  idtm.month = month;
                });
                fetchcate();
              },
              value: month,
              validator: (value) => value == null ? 'Please fill month' : null,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Select Month',
                labelStyle: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                hintText: "Select Month",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              elevation: 1,
              style: TextStyle(color: Colors.black, fontSize: 14),
              isDense: true,
              iconSize: 25.0,
              iconEnabledColor: Colors.black,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              items: _categorylist?.map((Categoryitem value) {
                    return DropdownMenuItem<String>(
                      value: value.catecode,
                      child: Text(value.catename),
                    );
                  })?.toList() ??
                  [],
              onChanged: (value) async {
                await SharedService.setcategoryDetails(value);
                setState(() {
                  category = value;
                  _citemlist.clear();
                  _citemlist = [];
                  item = null;
                });
                mdl.fetchItem(villageid, category, year, month).then((ivalue) {
                  setState(() {
                    _citemlist = ivalue;
                  });
                });
              },
              value: category,
              validator: (value) =>
                  value == null ? 'Please fill category' : null,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Select Category',
                labelStyle: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                hintText: "Select Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              elevation: 1,
              style: TextStyle(color: Colors.black, fontSize: 14),
              isDense: true,
              iconSize: 25.0,
              iconEnabledColor: Colors.black,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              items: _citemlist?.map((itemlist value) {
                    return DropdownMenuItem<String>(
                      value: value.itemcode,
                      child: Text(value.itemname),
                    );
                  })?.toList() ??
                  [],
              onChanged: (value) async {
                setState(() {
                  final snackBar = SnackBar(content: Text("Loading..."));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  item = value;
                  SurveyformfirstState.controllerdescription.text = "";
                  SurveyformfirstState.controllerqty.text = "";
                  SurveyformfirstState.controllerunit.text = "";
                });
                setState(() {
                  Itemdetails itemd = Itemdetails(
                      catecode: category,
                      itemcode: item,
                      villagecode: villageid,
                      month: month,
                      year: year);
                  mdl.fetchItemdetails(itemd).then((values) {
                    idtm = values;
                    SurveyformfirstState.controllerdescription.text =
                        idtm.idetails.toString();
                    SurveyformfirstState.controllerqty.text =
                        idtm.qty.toString();
                    SurveyformfirstState.controllerunit.text =
                        idtm.unit.toString();
                    idtm.itemname = _citemlist
                        .firstWhere((o) => o.itemcode == value)
                        .itemname;
                    idtm.year = year;
                    idtm.month = month;
                    idtm.itemcode = item;
                    idtm.catecode = category;
                    idtm.villagecode = villageid;
                    monthname = _futuremonthlist
                        .firstWhere((o) => o.value == month)
                        .name;
                  });
                });
              },
              value: item,
              isExpanded: true,
              validator: (value) => value == null ? 'Please fill item' : null,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Select Item',
                labelStyle: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                hintText: "Select Item",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              elevation: 1,
              style: TextStyle(color: Colors.black, fontSize: 14),
              isDense: true,
              iconSize: 25.0,
              iconEnabledColor: Colors.black,
            ),
            SizedBox(height: 20),
            TextFormField(
                maxLines: 2,
                readOnly: true,
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                  labelText: 'Description',
                  fillColor: Colors.grey[120],
                  filled: true,
                  labelStyle: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  prefixIcon: const Icon(
                    Icons.description,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                controller: controllerdescription),
            SizedBox(height: 20),
            TextFormField(
              maxLines: 1,
              readOnly: true,
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                labelText: 'Quantity',
                fillColor: Colors.grey[120],
                filled: true,
                labelStyle: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                prefixIcon: const Icon(
                  Icons.pending_sharp,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              controller: controllerqty,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Could not blank!';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
                maxLines: 1,
                readOnly: true,
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                  labelText: 'Unit',
                  fillColor: Colors.grey[120],
                  filled: true,
                  labelStyle: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  prefixIcon: const Icon(
                    Icons.ac_unit,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                controller: controllerunit),
          ],
        ),
      ),
    );
  }
}
