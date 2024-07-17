import 'package:flutter/material.dart';
import 'package:spec_siandung/src/services/api_service.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log'),
      ),
      body: Center(
          child: Column(
        children: [],
      )),
    );
  }
}
