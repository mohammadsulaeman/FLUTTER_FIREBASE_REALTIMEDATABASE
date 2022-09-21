import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:realtimedatabase/main.dart';

class MyInsertPage extends StatefulWidget {
  const MyInsertPage({super.key});

  @override
  State<MyInsertPage> createState() => _MyInsertPageState();
}

class _MyInsertPageState extends State<MyInsertPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('Users');
  final TextEditingController namaControllerAdd = TextEditingController();
  final TextEditingController alamatControllerAdd = TextEditingController();

  Future addUsers() async {
    Map person = {
      'nama': namaControllerAdd.text,
      'alamat': alamatControllerAdd.text,
    };

    await _databaseReference.push().set(person).then((value) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: ((context) => const MyApp()),
        ),
      );
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(onError),
          duration: const Duration(seconds: 4),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    namaControllerAdd.dispose();
    alamatControllerAdd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert Data"),
      ),
      body: Card(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: namaControllerAdd,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Nama Lengkap',
                  labelText: 'Nama Lengkap',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: alamatControllerAdd,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Alamat Lengkap',
                  labelText: 'Alamat Lengkap',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                onPressed: addUsers,
                child: const Text('Insert'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
