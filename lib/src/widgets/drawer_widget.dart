import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('John Doe'),
            accountEmail: Text('Siswa'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('lib/assets/images/user.png'),
            ),
          ),
          Text('Session Percakapan'),
        ],
      ),
    );
  }
}
