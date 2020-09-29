import 'package:shared_preferences/shared_preferences.dart';

class SharedDatabase {
  setDone(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('done', value);
  }

  Future<bool> getDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('done');
  }

  setLogin(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', value);
  }

  Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('login');
  }

  setMobile(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mobile', value);
  }

  Future<String> getMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('mobile');
  }

  Future<String> getBusinessID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('id');
  }

  setProfileData(
      String id,
      String name,
      String email,
      String business_name,
      String address,
      String mobile,
      String pincode,
      bool category,
      double lat,
      double lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.setString('business_name', business_name);
    prefs.setString('address', address);
    prefs.setString('mobile', mobile);
    prefs.setString('pincode', pincode);
    prefs.setBool('category', category);
    prefs.setDouble("lat", lat);
    prefs.setDouble("lang", lang);
  }
  Future<double> getLatitude() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('lat');
  }

  Future<double> getLongitude() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('lang');
  }
  setCategory(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('category', value);
  }

  Future<bool> getCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('category');
  }

  Future<String> getPincode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('pincode');
  }

  Future<String> getBusinessname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('business_name');
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<String> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('address');
  }
  userLogout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
