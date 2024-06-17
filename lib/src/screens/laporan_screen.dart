import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spec_siandung/src/models/laporan.dart';
import 'package:spec_siandung/src/services/api_service.dart';
import 'package:spec_siandung/src/widgets/app_bar_widget.dart';
import 'package:spec_siandung/src/widgets/drawer_widget.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final apiService = ApiService();
  List<Laporan> dataLaporan = [];

  @override
  void initState() {
    super.initState();
    _getLaporan();
  }

  Future<void> _getLaporan() async {
    final body = await apiService.fetchData(
      'perundungan_by_siswa',
    );

    print(body);

    final List<dynamic> listLaporan = body['data'];
    dataLaporan = listLaporan.map((e) => Laporan.fromJson(e)).toList();
    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        // Check if there is chat bot widget
        appBar: AppBarWidget(scaffoldKey: _scaffoldKey),
        drawer: const DrawerWidget(),
        body: Center(
          // Display datatable here
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'List Laporan Perundungan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: dataLaporan.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.grey[200],
                        child: ListTile(
                          title: Text(dataLaporan[index].klarifikasi ?? ''),
                          subtitle: Text(dataLaporan[index].keterangan ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 10)),
                          trailing: Text(dataLaporan[index].dateCreated ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 10)),
                        ),
                      );
                    },
                  ),
                ),
                // Add button here
                ElevatedButton(
                  onPressed: () {
                    // Add action here
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      Text('Tambah Laporan'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
