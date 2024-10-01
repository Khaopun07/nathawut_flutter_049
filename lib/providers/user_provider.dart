import 'package:flutter/material.dart';
import 'package:natthawut_flutter_049/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  
  User? _user;
  String? _accessToken;
  String? _refreshToken;

  User get user => _user!;
  String get accessToken => _accessToken!;
  String get refreshToken => _refreshToken!;

  void onLogin(UserModel userModel) {
    _user = userModel.user;
    _accessToken = userModel.accessToken;
    _refreshToken = userModel.refreshToken;
    notifyListeners();
  }

  void onLogout(){
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  void updateAccessToken(String newAccessToken) {
    _accessToken = newAccessToken;
    notifyListeners();
  }
}