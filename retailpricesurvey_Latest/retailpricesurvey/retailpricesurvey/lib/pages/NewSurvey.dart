import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:retailpricesurvey/Service/middlelayer.dart';
import 'package:retailpricesurvey/Service/shared_service.dart';
import 'package:retailpricesurvey/models/login_model.dart';
import 'package:retailpricesurvey/utils/progressbar.dart';

import 'login_page.dart';

class NewSyrveyform extends StatefulWidget {
  const NewSyrveyform({Key key}) : super(key: key);

  @override
  _NewSyrveyformState createState() => _NewSyrveyformState();
}

class _NewSyrveyformState extends State<NewSyrveyform> {
  Middlelayer mdl = new Middlelayer();
  String villageid,
      _setvillage,
      year,
      month,
      monthname,
      category,
      item,
      specialcode,
      previousprice,
      shopname;
  bool isApiCallProcess = false;
  
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController controllervillName = new TextEditingController();
  static TextEditingController controllerdescription =
      new TextEditingController();
  static TextEditingController controllerqty = new TextEditingController();
  static TextEditingController controllerunit = new TextEditingController();
  static TextEditingController controllerItemName = new TextEditingController();
  static TextEditingController controllerPrice = new TextEditingController();
  static TextEditingController controllerremark = new TextEditingController();
  static TextEditingController controllerpre = new TextEditingController();

  List<itemlist> _citemlist = [];
  List<yearmonthdet> _futureyearlist = [];
  List<yearmonthdet> _futuremonthlist = [];
  List<Categoryitem> _categorylist = [];
  Itemdetails idtm = new Itemdetails();
  var saveyear, savemonth, categsaved;

  void getvillname() {
    SharedService.loginDetails().then((value) {
      villageid = value.VillageCode;
      mdl.fetchvillage(value.VillageCode).then((vvalue) {
        setState(() {
          _setvillage = vvalue.villageName;
          controllervillName.text = _setvillage.toString();
        });
      });
    });
  }

  Future<bool> validatemonthyear() async {
    String value = await mdl.validmonthyear(monthname, idtm.year);
    if (value == "valid") {
      return true;
    } else {
      return false;
    }
  }

  Future<void> onStepContinue() async {
     FocusScope.of(context).unfocus();
    if (formKey.currentState.validate()) {
      if (await validatemonthyear()) {
        await _finalSave(context);
      } else {
        final snackBar = SnackBar(content: Text("Invalid Month & Year."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> _finalSave(context) async {
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
      ads.itemCode = idtm.itemcode;
      ads.itemName = idtm.itemname;
      ads.prvPrice1 = idtm.prvprice1;
      ads.prvPrice2 = idtm.prvprice2;
      ads.price = controllerPrice.text.toString();
      ads.splCode = idtm.spcode;
      ads.shopCode = idtm.shopcode;
      ads.unit = idtm.unit;
      ads.qty = idtm.qty;
      ads.remarks = controllerremark.text.toString();
      ads.villageCode = idtm.villagecode;
      ads.month = idtm.month;
      ads.year = idtm.year;
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
                        controllerPrice.clear();
                        controllerItemName.clear();
                        controllerpre.clear();
                        controllerremark.clear();
                        controllerdescription.clear();
                        controllerqty.clear();
                        controllerunit.clear();
                        shopname = null;
                        specialcode = null;
                        fetchitem();
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => NewSyrveyform()));
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

  Future<void> getdata() async {
    saveyear = await SharedService.getyearDetails();
    savemonth = await SharedService.getmonthDetails();
    categsaved = await SharedService.getcategoryDetails();
  }

  Future<void> getfinalyr() async {
    mdl.fetchyear().then((value) {
      setState(() {
        _futureyearlist = value.year;
        _futuremonthlist = value.month;

        year = saveyear == null
            ? _futureyearlist.firstWhere((i) => i.selected == true).value
            : saveyear;
        month = savemonth == null
            ? _futuremonthlist.firstWhere((i) => i.selected == true).value
            : savemonth;
      });
    });
  }

  Future<void> fetchcate() async {
    setState(() {
      isApiCallProcess = true;
    });
    await getdata();
    mdl.fetchCAtegory().then((value) {
      setState(() {
        _categorylist = value;

        if (categsaved != null) {
          category = categsaved;
        }
        isApiCallProcess = false;
      });
    });
  }

  Future<void> fetchitem() async {
    setState(() {
      isApiCallProcess = true;
    });
    await getdata();
    mdl.fetchItem(villageid, category, year, month).then((value) {
      setState(() {
        item = null;
        _citemlist = value;

        isApiCallProcess = false;
      });
    });
  }

  Future<void> fetchItemdetails() async {
    setState(() {
      isApiCallProcess = true;
    });
    await getdata();
    Itemdetails itemd = Itemdetails(
        catecode: category,
        itemcode: item,
        villagecode: villageid,
        month: month,
        year: year);
    mdl.fetchItemdetails(itemd).then((values) {
      setState(() {
        idtm.itemname =
            _citemlist.firstWhere((o) => o.itemcode == item).itemname;
        idtm.year = year;
        idtm.month = month;
        idtm.itemcode = item;
        idtm.catecode = category;
        idtm.villagecode = villageid;
        monthname = _futuremonthlist.firstWhere((o) => o.value == month).name;
        idtm.unit = values.unit.toString();
        idtm.qty = values.qty.toString();
        idtm.idetails = values.idetails.toString();
        idtm.prvprice1=values.prvprice1.toString();
        controllerdescription.text = idtm.idetails.toString();
        controllerqty.text = idtm.qty.toString();
        controllerunit.text = idtm.unit.toString();
        controllerItemName.text = idtm.itemname.toString();
        controllerpre.text =idtm.prvprice1 == null ? "" : idtm.prvprice1.toString();
        controllerPrice.text = idtm.price == null ? "" : idtm.price.toString();
        shopname = idtm.shopcode;
        isApiCallProcess = false;
      });
    });
  }

  @override
  void initState() {
    setState(() {
      isApiCallProcess = true;
    });
    asyncMethod();

    super.initState();
    setState(() {
      isApiCallProcess = false;
    });
  }

  void asyncMethod() async {
    setState(() {
      isApiCallProcess = true;
    });
    await getdata();
    await getfinalyr();
    getvillname();
    await fetchcate();
    if (category != null) {
      await fetchitem();
    }

    setState(() {
      isApiCallProcess = false;
    });
  }
  Future<void> logout(context) async {
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
  title: Text("Retail Price Survey"),
  centerTitle: true,
  actions: <Widget>[
    FlatButton(
      textColor: Colors.white,
      onPressed: () {logout(context);},
      child: Text("Logout"),
      color: Colors.redAccent,
      //shape: CircleBorder(side: BorderSide(color: Colors.blueGrey)),
    ),
  ],
),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text('Retail Price Survey'),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(children: <Widget>[
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
                Text("Start Survey",style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 16)),
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
              ]),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Form(
                    autovalidateMode: AutovalidateMode.disabled,
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          maxLines: 1,
                          readOnly: true,
                          enableInteractiveSelection: false,
                          controller: controllervillName,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return "Market is Required";
                            }
                            return null;
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
                            await SharedService.setyearDetails(value);
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
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
                            await SharedService.setmonthDetails(value);
                            setState(() {
                              month = value;
                              monthname = _futuremonthlist
                                  .firstWhere((o) => o.value == value)
                                  .name;
                              idtm.year = year;
                              idtm.month = month;
                            });
                            fetchcate();
                          },
                          value: month,
                          validator: (value) =>
                              value == null ? 'Please fill month' : null,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
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
                            });
                            await fetchitem();
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          elevation: 1,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          isDense: true,
                          iconSize: 25.0,
                          iconEnabledColor: Colors.black,
                        ),
                        SizedBox(height: 14),
                         Divider(
                        color: Colors.blueGrey,
                        height: 6,
                      ),
                        Divider(
                        color: Colors.blueGrey,
                        height: 6,
                      ),
                       SizedBox(height: 14),
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
                              final snackBar =
                                  SnackBar(content: Text("Loading..."));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              item = value;
                              controllerdescription.text = "";
                              controllerqty.text = "";
                              controllerunit.text = "";
                              controllerItemName.text = "";
                              controllerPrice.text = "";
                            });
                            await fetchItemdetails();
                          },
                          value: item,
                          isExpanded: true,
                          validator: (value) =>
                              value == null ? 'Please fill item' : null,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            controller: controllerunit),
                        SizedBox(height: 20),
                        TextFormField(
                          maxLines: 1,
                          readOnly: true,
                          enableInteractiveSelection: false,
                          controller: controllerItemName,
                          decoration: InputDecoration(
                            labelText: 'Itename',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return "Item is Required";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          maxLines: 1,
                          controller: controllerPrice,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            labelStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            prefixIcon: const Icon(
                              Icons.money,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return "Price is Required";
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))
                          ],
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          onTap: (){FocusScope.of(context).unfocus();},
                          items: [
                            DropdownMenuItem<String>(
                              value: "0",
                              child: Text(
                                "0",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "1",
                              child: Text(
                                "1",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "2",
                              child: Text(
                                "2",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "3",
                              child: Text(
                                "3",
                              ),
                            ),
                          ],
                          onChanged: (value) async {
                            setState(() {
                              specialcode = value;
                              idtm.spcode = value;
                            });
                          },
                          value: specialcode,
                          validator: (value) =>
                              value == null ? 'Please fill Special Code' : null,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: 'Select Special Code',
                            labelStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            hintText: "Select Month",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
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
                          items: [
                            DropdownMenuItem<String>(
                              value: "Original Shop",
                              child: Text(
                                "Original Shop",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "First Reserve",
                              child: Text(
                                "First Reserve",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Second Reserve",
                              child: Text(
                                "Second Reserve",
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "Others",
                              child: Text(
                                "Others",
                              ),
                            ),
                          ],
                          onChanged: (value) async {
                            setState(() {
                              shopname = value;
                              idtm.shopcode = value;
                            });
                          },
                          value: shopname,
                          validator: (value) =>
                              value == null ? 'Please fill ShopName' : null,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: 'Select Shop',
                            labelStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            hintText: "Select Shop",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
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
                            maxLines: 1,
                            readOnly: true,
                            enableInteractiveSelection: false,
                            decoration: InputDecoration(
                              labelText: 'Prev. Price',
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            controller: controllerpre),
                        SizedBox(height: 20),
                        TextFormField(
                            maxLines: 1,
                            decoration: InputDecoration(
                              labelText: 'Remarks',
                              fillColor: Colors.white,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            controller: controllerremark),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.save),
                          onPressed: onStepContinue,
                          label: Text('SUBMIT'),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.green)),
                        ),
                         SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
