import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/customExp.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expireDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse("url");

    try {
      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final resData = json.decode(res.body);

      if (resData['error'] != null) {
        throw HttpException(message: resData['error']['message']);
      }

      _token = resData['idToken'];
      _userId = resData['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(resData['expiresIn'])));
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expireDate.toIso8601String()
      });

      prefs.setString("userData", userData);
    } catch (err) {
      throw err;
    }

    // print(json.decode(res.body));
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

// auto login functionality
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString("userData")) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  // logout
  Future<void> logout() async {
    _token = null;
    _expireDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

// autologout
  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  // class end
}
