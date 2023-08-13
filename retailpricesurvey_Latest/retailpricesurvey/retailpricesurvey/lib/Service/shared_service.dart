import 'dart:convert';
import 'package:retailpricesurvey/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SharedService {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("login_details") != null ? true : false;
  }

  

  static Future<void> setLoginDetails(LoginResponseModel loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
   if(loginResponse!=null)
   {
     return prefs.setString("login_details",jsonEncode(loginResponse.toJson()));
   }
   else{
      prefs.remove("login_details");
   }
    
  }
   static Future<void> setyearDetails(String year) async {
    final prefs = await SharedPreferences.getInstance();
   if(year!=null)
   {
     return prefs.setString("year_details",year);
   }
   else{
      prefs.remove("year_details");
   }
    
  }
   static Future<String> getyearDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("year_details") != null
        ? prefs.getString("year_details")
        : null;
  }
  static Future<void> setmonthDetails(String month) async {
    final prefs = await SharedPreferences.getInstance();
   if(month!=null)
   {
     return prefs.setString("month_details",month);
   }
   else{
      prefs.remove("month_details");
   }
    
  }
   static Future<String> getmonthDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("month_details") != null
        ? prefs.getString("month_details")
        : null;
  }

  static Future<void> setcategoryDetails(String cate) async {
    final prefs = await SharedPreferences.getInstance();
   if(cate!=null)
   {
     return prefs.setString("cate_details",cate);
   }
   else{
      prefs.remove("cate_details");
   }
    
  }
   static Future<String> getcategoryDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("cate_details") != null
        ? prefs.getString("cate_details")
        : null;
  }

  static Future<void> logout() async {
    await setLoginDetails(null);
    await setmonthDetails(null);
    await setyearDetails(null);
    await setcategoryDetails(null);
  }

  static Future<LoginResponseModel> loginDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("login_details") != null
        ? LoginResponseModel.fromJson(jsonDecode(prefs.getString("login_details")))
        : null;
  }
}