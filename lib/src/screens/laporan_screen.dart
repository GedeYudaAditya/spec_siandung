import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spec_siandung/src/models/laporan.dart';
import 'package:spec_siandung/src/services/api_service.dart';
import 'package:spec_siandung/src/utils/role_utils.dart';
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

  String? token;
  String? id;
  String? nama;
  int? role;

  TextEditingController keteranganController = TextEditingController();

  bool dataIsReady = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _getLaporan();
      _getSharedPrefs();
      dataIsReady = true;
    });
  }

  Future<void> _getLaporan() async {
    final body = await apiService.fetchData(
      'perundungan',
    );

    print(body);

    final List<dynamic> listLaporan = body['data'];
    dataLaporan = listLaporan.map((e) => Laporan.fromJson(e)).toList();
    setState(() {
      dataLaporan = dataLaporan;
      dataIsReady = true;
    });
  }

  Future<void> _createLaporan() async {
    final body = await apiService.postData(
      'create_perundungan_by_siswa',
      {
        'keterangan': keteranganController.text,
      },
    );

    print('Response Create: $body');

    await _getLaporan();
  }

  // get shared preferences
  Future<void> _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    id = prefs.getString('id');
    nama = prefs.getString('nama');
    role = prefs.getInt('role');
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
                  child: (dataIsReady)
                      ?
                      // Display datatable here
                      ListView.builder(
                          itemCount: dataLaporan.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                  onTap: () {
                                    if (RoleUtils.getRoleIndex(
                                            RoleUtils.psychologist) ==
                                        role) {
                                      Navigator.pushNamed(
                                        context,
                                        '/log',
                                        arguments: dataLaporan[index],
                                      );
                                    } else {
                                      Navigator.pushNamed(
                                        context,
                                        '/detail-laporan',
                                        arguments: dataLaporan[index],
                                      );
                                    }
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.red[100],
                                    child: const Icon(Icons.campaign),
                                  ),
                                  title: Text(
                                      dataLaporan[index].klarifikasi ?? '',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                      dataLaporan[index].dateCreated ?? '',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 10)),
                                  trailing:
                                      role ==
                                              RoleUtils.getRoleIndex(
                                                  RoleUtils.student)
                                          ? IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                // Pop up dialog to delete laporan
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Hapus Laporan'),
                                                      content: const Text(
                                                          'Apakah Anda yakin ingin menghapus laporan ini?'),
                                                      actions: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Batal'),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  // pop up circle loading
                                                                  showDialog(
                                                                    barrierColor:
                                                                        Colors
                                                                            .white60,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return const Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      );
                                                                    },
                                                                  );

                                                                  // Delete laporan
                                                                  await apiService.deleteData(
                                                                      'delete_perundungan_by_siswa',
                                                                      {
                                                                        'id_laporan':
                                                                            dataLaporan[index].id,
                                                                      }).then(
                                                                      (value) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    _getLaporan();
                                                                  }).onError((error,
                                                                      stackTrace) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    // Show error message pop up
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('Error'),
                                                                          content:
                                                                              Text('Gagal menghapus laporan: $error'),
                                                                          actions: [
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: const Text('OK'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  });
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Hapus'),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          : null),
                            );
                          },
                        )
                      :
                      // Display loading indicator here
                      const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                // Add button here
                role == RoleUtils.getRoleIndex(RoleUtils.student)
                    ? ElevatedButton(
                        onPressed: () {
                          // Pop up dialog to add new laporan
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Tambah Laporan'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: keteranganController,
                                      decoration: const InputDecoration(
                                        labelText: 'Keterangan',
                                        hintText:
                                            'Tuliskan keterangan laporan disini...',
                                        border: OutlineInputBorder(),
                                        alignLabelWithHint: true,
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      maxLines: 8,
                                    ),
                                  ],
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Batal'),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            showDialog(
                                              barrierColor: Colors.white60,
                                              context: context,
                                              builder: (context) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                            );
                                            // Add new laporan
                                            await _createLaporan()
                                                .then((value) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            }).onError((error, stackTrace) {
                                              Navigator.of(context).pop();
                                              // Show error message pop up
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text('Error'),
                                                    content: Text(
                                                        'Gagal menambahkan laporan: $error'),
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            });
                                          },
                                          child: const Text('Tambah'),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add),
                            Text('Tambah Laporan'),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
