

class LoginRequestModel {
  String Userid;
  String Password;
  String optval="NU";

  LoginRequestModel({
    this.Userid,
    this.Password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Userid': Userid.trim(),
      'Password': Password.trim(),
      'optval':optval.trim()
    };

    return map;
  }
}
class LoginResponseModel {
   String Userid;
   String VillageCode;
   String DistrictCode;
   String GRP_ID;

  LoginResponseModel({this.Userid, this.VillageCode,this.DistrictCode,this.GRP_ID});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      Userid: json["Userid"] != null ? json["Userid"] : "",
      VillageCode: json["VillageCode"] != null ? json["VillageCode"] : "",
      DistrictCode: json["DistrictCode"] != null ? json["DistrictCode"] : "",
      GRP_ID: json["GRP_ID"] != null ? json["GRP_ID"] : "",
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Userid': Userid.trim(),
      'VillageCode': VillageCode.trim(),
    };

    return map;
  }
}
class Villagedet {
  final String villageName;
  Villagedet({
     this.villageName,
  });

  factory Villagedet.fromJson(Map<String, dynamic> json) {
    return Villagedet(      
      villageName: json['VillageName'],
    );
  }
}
class yearmonthdet {
  final String name;
  final String value;
  final bool selected;
  yearmonthdet({
     this.name,this.selected,this.value
  });

  factory yearmonthdet.fromJson(Map<String, dynamic> json) {
    return yearmonthdet(      
      name: json['name'],
       value: json['value'],
        selected: json['selected'],
    );
  }
}
class years {
   List<yearmonthdet> month;
  List<yearmonthdet> year;
   years({ this.year,this.month  });
   factory years.fromJson(Map<String, dynamic> json) {
    return years(      
      month: json['month'].cast<yearmonthdet>(),
      year: json['year'].cast<yearmonthdet>(),
    );
  }
}
class Categoryitem {
  String catecode;
  String catename;

  Categoryitem({this.catecode,this.catename});
 factory Categoryitem.fromJson(Map<String,dynamic>json){
   return Categoryitem(
      catecode: json['Category_Code'],
      catename: json['Category_Name']
   );
 }

}
class itemlist {
  String itemcode;
  String itemname;

  itemlist({this.itemcode,this.itemname});
 factory itemlist.fromJson(Map<String,dynamic>json){
   return itemlist(
      itemcode: json['Item_Code'],
      itemname: json['Item_Name']
   );
 }

}
class Itemdetails {
  String catecode;
  String itemcode,itemname;
   String villagecode;
   String month;
   String year;
   String remarks;
   String price;
   String shopcode;
   String spcode;
   String prvprice1,prvprice2;
   String unit;
   String qty;
   String idetails;
   Itemdetails({this.catecode,this.itemcode,this.itemname,this.villagecode,this.month,this.year,this.remarks,this.price,this.shopcode,this.spcode,this.prvprice1,this.prvprice2,this.unit,this.qty,this.idetails});

   factory Itemdetails.fromJson(Map<String,dynamic>json){
   return Itemdetails(
      catecode: json['Category_Code'],
      itemcode: json['Item_Code'],
      itemname: json['Item_Name'],
      villagecode: json['VillageCode'],
      month: json['month'],
      year: json['year'],
      remarks: json['Remarks'],
      price: json['Price'],
      shopcode: json['Shop_code'],
      spcode: json['Spl_Code'],
      prvprice1: json['Prv_price1'],
      prvprice2: json['Prv_price2'],
      unit: json['Unit'],
      qty: json['Qty'],
      idetails: json['Item_dtls'],
      
   );
 }
 Map toJson() => {
        'Category_Code': catecode,
        'Item_Code': itemcode,
        'VillageCode': villagecode,
        'month': month,
        'year': year
    };
  
}

class Addsurvey {
    Addsurvey({
        this.price,
        this.splCode,
        this.shopCode,
        this.prvPrice1,
        this.prvPrice2,
        this.remarks,
        this.unit,
        this.qty,
        this.itemName,
        this.itemCode,
        this.villageCode,
        this.month,
        this.year,
        this.lat,
        this.lang,
    });

    String price;
    String splCode;
    String shopCode;
    String prvPrice1;
    String prvPrice2;
    String remarks;
    String unit;
    String qty;
    String itemName;
    String itemCode;
    String villageCode;
    String month;
    String year;
    String lat;
    String lang;

    factory Addsurvey.fromJson(Map<String, dynamic> json) => Addsurvey(
        price: json["Price"],
        splCode: json["Spl_Code"],
        shopCode: json["Shop_code"],
        prvPrice1: json["Prv_price1"],
        prvPrice2: json["Prv_price2"],
        remarks: json["Remarks"],
        unit: json["Unit"],
        qty: json["Qty"],
        itemName: json["Item_Name"],
        itemCode: json["Item_Code"],
        villageCode: json["VillageCode"],
        month: json["month"],
        year: json["year"],
        lat: json["Lat"],
        lang: json["Lang"],
    );

    Map<String, dynamic> toJson() => {
        "Price": price,
        "Spl_Code": splCode,
        "Shop_code": shopCode,
        "Prv_price1": prvPrice1,
        "Prv_price2": prvPrice2,
        "Remarks": remarks,
        "Unit": unit,
        "Qty": qty,
        "Item_Name": itemName,
        "Item_Code": itemCode,
        "VillageCode": villageCode,
        "month": month,
        "year": year,
        "Lat": lat,
        "Lang": lang,
    };
}
