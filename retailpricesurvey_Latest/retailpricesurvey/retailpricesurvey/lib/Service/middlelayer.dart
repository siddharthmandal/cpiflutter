import 'dart:io';

import 'package:retailpricesurvey/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Middlelayer {
  String url = "http://cpiodisha.nic.in/MobileService.svc/xmlservice";

  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    if (requestModel.Userid != null && requestModel.Password != null) {
      final response = await http.post(Uri.parse(url + '/MobileLogin'),
          headers: {"Content-Type": "application/json"},
          body: JsonEncoder().convert(requestModel));
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as List;
        return LoginResponseModel.fromJson(body[0]);
      } else {
        throw Exception('Wrong Userid or password!');
      }
    } else {
      throw Exception('Can not blank!');
    }
  }

  Future<Villagedet> fetchvillage(villageid) async {
    try {
      final response = await http
          .get(Uri.parse(url + '/Getvillages?villageid=' + villageid));

      if (response.statusCode == 200) {
        return Villagedet.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load village');
      }
    } on SocketException {
      throw Exception('No Internet connection 😑');
    } on HttpException {
      throw Exception("Couldn't find the post 😱");
    } on FormatException {
      throw Exception("Bad response format 👎");
    }
  }

  Future<years> fetchyear() async {
    try {
      final response = await http.get(Uri.parse(url + '/GetMyMonthList'));

      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        List<yearmonthdet> data = (map['year'] as List)
            .map((itemWord) => yearmonthdet.fromJson(itemWord))
            .toList();
        List<yearmonthdet> monthdata = (map['month'] as List)
            .map((itemWord) => yearmonthdet.fromJson(itemWord))
            .toList();
        years finaldata = new years();
        finaldata.year = data;
        finaldata.month = monthdata;
        return finaldata;
      } else {
        throw Exception('Failed to load year');
      }
    } on SocketException {
      throw Exception('No Internet connection 😑');
    } on HttpException {
      throw Exception("Couldn't find the post 😱");
    } on FormatException {
      throw Exception("Bad response format 👎");
    }
  }

  Future<List<Categoryitem>> fetchCAtegory() async {
    final response = await http.get(Uri.parse(url + '/GetCateList'));

    if (response.statusCode == 200) {
      List<Categoryitem> data = (json.decode(response.body) as List)
          .map((itemWord) => Categoryitem.fromJson(itemWord))
          .toList();
      return data;
    } else {
      throw Exception('Failed to load category');
    }
  }

  Future<List<itemlist>> fetchItem(villageid, categoryid,year,month) async {
    final response = await http.get(Uri.parse(
        url + '/GetnewItemList?cate=' + categoryid + '&villcd=' + villageid + '&year=' + year + '&month=' + month));

    if (response.statusCode == 200) {
      List<itemlist> data = (json.decode(response.body) as List)
          .map((itemWord) => itemlist.fromJson(itemWord))
          .toList();
      return data;
    } else {
      throw Exception('Failed to load category');
    }
  }

  Future<Itemdetails> fetchItemdetails(Itemdetails itmd) async {
    if (itmd != null) {
      final response = await http.post(Uri.parse(url + '/itemDetail'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(itmd));
      if (response.statusCode == 200) {
        return Itemdetails.fromJson(json.decode(response.body));
      } else {
        throw Exception('select again!internet slow!');
      }
    } else {
      throw Exception('Can not blank!');
    }
  }

  Future<String> validmonthyear(month, year) async {
    final response = await http
        .get(Uri.parse(url + '/getMonthVal?month=' + month + '&year=' + year));

    if (response.statusCode == 200) {
      return response.body.replaceAll('"', '');
    } else {
      throw Exception('Please try again!');
    }
  }

  Future<String> addSurveydetails(Addsurvey addsurvey) async {
    try {
      if (addsurvey != null) {
        final response = await http.post(Uri.parse(url + '/addItemDetail'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(addsurvey));
        if (response.statusCode == 200) {
          return response.body;
        } else {
          return 'select again!internet slow!';
        }
      } else {
        throw Exception('Can not blank!');
      }
    } on SocketException {
      throw Exception('No Internet connection 😑');
    } on HttpException {
      throw Exception("Couldn't find the post 😱");
    } on FormatException {
      throw Exception("Bad response format 👎");
    }
  }
}
