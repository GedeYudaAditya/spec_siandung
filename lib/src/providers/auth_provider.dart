// lib/src/providers/auth_provider.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

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
      // final token = response['token'];

      // rondom token
      final token = Random().nextInt(100000).toString();

      if (rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // user information
      await prefs.setString('id', response['data']['id'].toString());
      await prefs.setString('nama', response['data']['nama']);
      await prefs.setString('nama_user', response['data']['nama_user']);
      await prefs.setString('created_at', response['data']['created_at']);
      await prefs.setString('updated_at', response['data']['updated_at']);
      // await prefs.setString('password', response['data']['password']);
      await prefs.setString('isactive', response['data']['isactive']);
      await prefs.setString(
          'id_jenispengguna', response['data']['id_jenispengguna'].toString());

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register a new user
  Future<bool> register(String email, String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.register(email, username, password);
      // Handle the response, save tokens, etc.

      // if successful, login the user
      if (!response['error']) {
        final loginRes = await login(email, password, false);
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
    final email = prefs.getString('email');
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
    await prefs.remove('email');
    await prefs.remove('password');
    _isLoggedIn = false;
    await prefs.setString('isloggedIn', _isLoggedIn.toString());
    notifyListeners();
  }
}
