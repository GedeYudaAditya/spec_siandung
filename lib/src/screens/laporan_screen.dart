import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
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
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _there = GlobalKey();
  final GlobalKey _four = GlobalKey();
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
    _startShowcase();
  }

  Future<void> _startShowcase() async {
    final prefs = await SharedPreferences.getInstance();
    bool? showcaseSeen = prefs.getBool('showcase_seen');

    if (showcaseSeen == null || !showcaseSeen) {
      //Start showcase view after current widget frames are drawn.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context)
            .startShowCase([_one, _two, _there, _four]),
      );
      prefs.setBool('showcase_seen', true);
    }
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
  void dispose() {
    super.dispose();
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
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'lib/assets/images/home.png',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Container(
                      height: 100,
                      color: Color.fromARGB(209, 88, 115, 129),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "List Laporan Perundungan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Jangan takut untuk melaporkan tindakakan perundungan untuk kenyamanan belajar anda di sekolah",
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Showcase(
                  key: _one,
                  description: 'List Laporan akan tampil disini',
                  child: (dataIsReady)
                      ?
                      // Display datatable here
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.builder(
                            itemCount: dataLaporan.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Showcase(
                                  key: (RoleUtils.getRoleIndex(
                                              RoleUtils.student) ==
                                          role)
                                      ? _there
                                      : _two,
                                  description:
                                      "Klik Salah Satu List Untuk Melihat Detail Laporan",
                                  child: ListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
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
                                        // backgroundColor: Colors.red[100],
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
                                              ? Showcase(
                                                  key: _four,
                                                  description:
                                                      "Klik Tombol Ini Untuk Menghapus",
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.redAccent,
                                                    ),
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
                                                                            Colors.red,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'Batal'),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Expanded(
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        // pop up circle loading
                                                                        showDialog(
                                                                          barrierColor:
                                                                              Colors.white60,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return const Center(
                                                                              child: CircularProgressIndicator(),
                                                                            );
                                                                          },
                                                                        );

                                                                        // Delete laporan
                                                                        await apiService.deleteData(
                                                                            'delete_perundungan_by_siswa', {
                                                                          'id_laporan':
                                                                              dataLaporan[index].id,
                                                                        }).then(
                                                                            (value) {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          _getLaporan();
                                                                        }).onError((error,
                                                                            stackTrace) {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          // Show error message pop up
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return AlertDialog(
                                                                                title: const Text('Error'),
                                                                                content: Text('Gagal menghapus laporan: $error'),
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
                                                                      child: const Text(
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
                                                  ),
                                                )
                                              : null),
                                );
                              } else {
                                return ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
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
                                      // backgroundColor: Colors.red[100],
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
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                ),
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
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: const Text(
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
                                                                    }).onError(
                                                                        (error,
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
                                                                  child: const Text(
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
                                            : null);
                              }
                            },
                          ),
                        )
                      :
                      // Display loading indicator here
                      const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
              // Add button here
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: role == RoleUtils.getRoleIndex(RoleUtils.student)
                    ? Showcase(
                        key: _two,
                        description:
                            'Klik Tombol Berikut Untuk Menambahkan Laporan',
                        child: ElevatedButton(
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
                                                      title:
                                                          const Text('Error'),
                                                      content: Text(
                                                          'Gagal menambahkan laporan: $error'),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('OK'),
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
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
