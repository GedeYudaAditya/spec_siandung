// lib/src/screens/splash_screen.dart
import 'dart:io';

import 'package:spec_siandung/app_theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? _deviceInfo;

  @override
  void initState() {
    super.initState();
    _getDeviceId();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _checkLoginStatus();
      }
    });
  }

  Future<void> _getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String identifier = 'Unknown';

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      identifier = androidInfo.id; // unique ID for Android devices
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;
      identifier = iosInfo.identifierForVendor!; // unique ID for iOS devices
    }

    setState(() {
      _deviceInfo = identifier;
      // Save the device ID to shared preferences
      _saveDeviceId();
    });
  }

  Future<void> _saveDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_id', _deviceInfo!);
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);

    if (token != null) {
      // Token exists, navigate to home screen
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // No token, navigate to login screen
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/icon.png',
                width: 200.0,
              ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              // Image.asset(
              //   'lib/assets/images/text_logo.png',
              //   width: 200.0,
              // ),
            ],
          ), // Ensure the image is added in pubspec.yaml
        ),
      ),
    );
  }
}
