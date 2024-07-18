import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spec_siandung/src/models/laporan.dart';
import 'package:spec_siandung/src/services/api_service.dart';
import 'package:spec_siandung/src/utils/role_utils.dart';

class DetailLaporanScreen extends StatefulWidget {
  const DetailLaporanScreen({super.key});

  @override
  State<DetailLaporanScreen> createState() => _DetailLaporanScreenState();
}

class _DetailLaporanScreenState extends State<DetailLaporanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();
  final apiService = ApiService();

  String? token;
  String? id;
  String? nama;
  int? role;

  @override
  void initState() {
    super.initState();
    _getSharedPrefs();
  }

  Future<bool> _updateLaporan(id, keterangan) async {
    // if (_formKey.currentState!.validate()) {
    final keterangan = _keteranganController.text;

    // call api service to update laporan
    try {
      final response = await apiService.putData('update_perundungan_by_siswa', {
        'id_laporan': id,
        'keterangan': keterangan,
      });

      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
    // } else {
    // return false;
    // }
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

  @override
  Widget build(BuildContext context) {
    // get arguments from previous screen
    final args = ModalRoute.of(context)!.settings.arguments as Laporan;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.centerLeft,
                    child: Text('${args.klarifikasi}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.centerLeft,
                    child: Text('Detail Laporan:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                  // text paragraph dari laporan
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(args.keterangan ?? '',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // button untuk meligat log
            Container(
              height: 80,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Row(
                children: [
                  role != RoleUtils.getRoleIndex(RoleUtils.student)
                      ? Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // navigate ke halaman log
                              Navigator.pushNamed(context, '/log');
                            },
                            child: Text('Lihat Log'),
                          ),
                        )
                      : Spacer(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // pop up dialog untuk edit laporan
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Edit Laporan'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FormField(
                                    key: _formKey,
                                    builder: (field) => TextFormField(
                                      controller: _keteranganController,
                                      decoration: const InputDecoration(
                                        labelText: 'Keterangan',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Keterangan tidak boleh kosong';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
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
                                          // update laporan
                                          final result = await _updateLaporan(
                                              args.id,
                                              _keteranganController.text);

                                          if (result) {
                                            // change the data in the previous screen
                                            args.keterangan =
                                                _keteranganController.text;

                                            setState(() {});

                                            Navigator.pop(context);
                                          } else {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Gagal mengupdate laporan')));
                                          }
                                        },
                                        child: Text('Save'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Edit'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
