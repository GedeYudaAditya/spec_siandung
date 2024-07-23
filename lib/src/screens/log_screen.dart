import 'package:flutter/material.dart';
import 'package:spec_siandung/src/models/laporan.dart';
import 'package:spec_siandung/src/models/log.dart';
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
    // get the arguments from the previous screen
    final args = ModalRoute.of(context)!.settings.arguments as Laporan;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log'),
      ),
      body: Center(
          child: Column(
        children: [
          FutureBuilder(
            future: apiService.fetchData('log?id_laporan=' + args.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              } else {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Log> logs =
                      Log.fromJsonList(snapshot.data!['data']['log']);
                  return Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 16, right: 16, left: 16),
                        alignment: Alignment.centerLeft,
                        child: Text('${snapshot.data!['data']['klasifikasi']}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            right: 16, left: 16, top: 10, bottom: 5),
                        alignment: Alignment.centerLeft,
                        child: Text('Detail Laporan:',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            textAlign: TextAlign.left),
                      ),
                      // text paragraph dari laporan
                      Container(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                                snapshot.data!['data']['keterangan'] ?? '',
                                style: TextStyle(fontSize: 16, height: 1.5),
                                textAlign: TextAlign.justify),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            right: 16, left: 16, top: 10, bottom: 5),
                        alignment: Alignment.centerLeft,
                        child: Text('Log List:',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            textAlign: TextAlign.left),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(logs[index].status),
                                subtitle: Text(logs[index].keterangan),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              }
            },
          ),
        ],
      )),
    );
  }
}
