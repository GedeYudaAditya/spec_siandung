import 'package:flutter/material.dart';
import 'package:spec_siandung/src/widgets/app_bar_widget.dart';
import 'package:spec_siandung/src/widgets/drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Menu 1'),
    Text('Menu 2'),
    Text('Menu 3'),
    Text('Menu 4'),
    Text('Menu 5'),
  ];

  bool shouldShowAppBar(int index) {
    // Define the indexes that should show the AppBar
    const appBarIndexes = [
      2,
    ]; // Add the indexes for which you want to show the AppBar

    return appBarIndexes.contains(index);
  }

  bool shouldShowDrawer(int index) {
    // Define the indexes that should show the Drawer
    const drawerIndexes = [
      // 1,
    ]; // Add the indexes for which you want to show the Drawer

    return drawerIndexes.contains(index);
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset('lib/assets/images/icons/mengenali.png',
                  fit: BoxFit.cover, width: 30, height: 30),
              label: '', // No label
            ),
            BottomNavigationBarItem(
              icon: Image.asset('lib/assets/images/icons/membedakan.png',
                  fit: BoxFit.cover, width: 30, height: 30),
              label: '', // No label
            ),
            BottomNavigationBarItem(
              icon: Image.asset('lib/assets/images/icons/user.png',
                  fit: BoxFit.cover, width: 40, height: 40),
              label: '', // No label
            ),
            BottomNavigationBarItem(
              icon: Image.asset('lib/assets/images/icons/mengurutkan.png',
                  fit: BoxFit.cover, width: 30, height: 30),
              label: '', // No label
            ),
            BottomNavigationBarItem(
              icon: Image.asset('lib/assets/images/icons/perkembangan.png',
                  fit: BoxFit.cover, width: 30, height: 30),
              label: '', // No label
            ),
          ],
          selectedItemColor: Colors.purple[400],
          unselectedItemColor: Colors.grey[400],
          backgroundColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        // Check if there is chat bot widget
        appBar: shouldShowAppBar(_selectedIndex)
            ? null
            : AppBarWidget(scaffoldKey: _scaffoldKey, index: _selectedIndex),
        drawer: shouldShowDrawer(_selectedIndex) ? const DrawerWidget() : null,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
