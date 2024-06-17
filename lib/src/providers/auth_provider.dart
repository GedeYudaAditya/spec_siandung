// lib/src/providers/auth_provider.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  bool _isLoggedIn = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String username, String password, bool rememberMe) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(username, password);

      // Handle the response, save tokens, etc.
      final token = response['data']['token'];

      // decode the token to get the user data
      final userData = json.decode(
        ascii.decode(
          base64.decode(
            base64.normalize(token.split(".")[1]),
          ),
        ),
      );

      print(userData);
      // {id: ID000040, nama: Cliff Miller Sanjaya, username: ciffaaa, role: 3, exp: 1718606824}

      if (rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('id', userData['id']);
      await prefs.setString('nama', userData['nama']);
      await prefs.setInt('role', int.parse(userData['role'].toString()));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register a new user
  Future<bool> register(
      String nisn, String username, String noTelp, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _apiService.register(nisn, username, noTelp, password);
      // Handle the response, save tokens, etc.

      // if successful, login the user
      if (response['status']) {
        final loginRes = await login(username, password, false);
        if (loginRes) {
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    _isLoggedIn = token != null;
    await prefs.setString('isloggedIn', _isLoggedIn.toString());
    notifyListeners();
  }

  Future<void> checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('username');
    final password = prefs.getString('password');

    if (email != null && password != null) {
      // Automatically login if credentials exist
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
    await prefs.remove('password');
    _isLoggedIn = false;
    await prefs.setString('isloggedIn', _isLoggedIn.toString());
    notifyListeners();
  }
}
