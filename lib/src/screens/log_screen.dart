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
                return const CircularProgressIndicator();
              } else {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Log> logs =
                      Log.fromJsonList(snapshot.data!['data']['log']);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(logs[index].status),
                        subtitle: Text(logs[index].keterangan),
                      );
                    },
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
