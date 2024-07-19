import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spec_siandung/src/utils/role_utils.dart';
import 'package:spec_siandung/src/widgets/app_bar_widget.dart';
import 'package:spec_siandung/src/widgets/drawer_widget.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // for text fields
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();

  String? token;
  String? id;
  String? nama;
  int? role;
  String? email;
  String? username;
  String? noTelp;
  String? image;

  // get shared preferences
  Future<void> _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    id = prefs.getString('id');
    nama = prefs.getString('nama');
    role = prefs.getInt('role');
    email = prefs.getString('email');
    username = prefs.getString('username');
    noTelp = prefs.getString('noTelp');

    image = prefs.getString('foto');
    setState(() {});
  }

  // set text fields
  void _setFields() {
    _emailController.text = email ?? '';
    _usernameController.text = username ?? '';
    _noTelpController.text = noTelp ?? '';
    _namaController.text = nama ?? '';
  }

  @override
  void initState() {
    super.initState();
    _getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    _setFields();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(scaffoldKey: _scaffoldKey),
      drawer: const DrawerWidget(),
      body: Center(
        // Profile settings
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Avatar and fields set image, name, phone, email.
              CircleAvatar(
                backgroundImage: NetworkImage(image != null
                    ? "https://mobile.siandung.com/assets/img/${RoleUtils.getRole(role ?? 1).toLowerCase()}/${image}"
                    : 'https://via.placeholder.com/150'),
                radius: 100,
              ),
              SizedBox(height: 10),
              Text(
                nama ?? 'Nama Pengguna',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Text(
                RoleUtils.getRole(role ?? 1),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              // Fields for email, username, and phone number.
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormField(builder: (FormFieldState state) {
                  return Column(
                    children: <Widget>[
                      TextField(
                        controller: _namaController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Nama',
                          hintText: 'Nama',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Email',
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Username',
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _noTelpController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.phone),
                          labelText: 'No. Telp',
                          hintText: 'No. Telp',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          child: const Text('Simpan'),
                          onPressed: () async {
                            // Save the changes to the shared preferences first.
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString('nama', _namaController.text);
                            prefs.setString('email', _emailController.text);
                            prefs.setString(
                                'username', _usernameController.text);
                            prefs.setString('noTelp', _noTelpController.text);
                            // Then, update the user data in the API.

                            // Finally, update the user data in the app.
                            setState(() {
                              nama = _namaController.text;
                              email = _emailController.text;
                              username = _usernameController.text;
                              noTelp = _noTelpController.text;
                            });
                          }),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
