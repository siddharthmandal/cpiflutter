import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retailpricesurvey/models/login_model.dart';
import 'package:retailpricesurvey/pages/Surveyformone.dart';

class Surveyformtwo extends StatefulWidget {
  Itemdetails idmt;
  Surveyformtwo({this.idmt});
  @override
  State<StatefulWidget> createState() {
    return SurveyformtwoState();
  }
}

class SurveyformtwoState extends State<Surveyformtwo> {
  static final formKey = GlobalKey<FormState>();
  static TextEditingController controllerItemName = new TextEditingController();
  static TextEditingController controllerPrice ;
  static TextEditingController controllerremark = new TextEditingController();
  static TextEditingController controllerpre = new TextEditingController();
  var specialcode;
  var shopname;
  var previousprice;
  Itemdetails idtm;

  @override void initState() {
    super.initState();
    setState(() {
      idtm = SurveyformfirstState.idtm;
    });
    controllerPrice = new TextEditingController (text: idtm.price);
    controllerremark = new TextEditingController(text: idtm.remarks);
  }
  
  @override
  Widget build(BuildContext context) {
    
    controllerItemName.text = widget.idmt.itemname;
    controllerpre.text = widget.idmt.prvprice1;
   // controllerPrice.text=widget.idmt.price;
    //specialcode=widget.idmt.spcode;
   // controllerremark.text = widget.idmt.remarks;
    shopname = widget.idmt.shopcode;
    

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
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return "Item is Required";
                }
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
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
               
              validator: (value) {
                if (value.trim().isEmpty) {
                  return "Price is Required";
                }                
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))
              ],
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
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
                  idtm.spcode=value;
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
                  idtm.shopcode=value;
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
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                controller: controllerremark
                
                ),
          ],
        ),
      ),
    );
  }
}
