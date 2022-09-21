import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:realtimedatabase/main.dart';

class MyUpdatePage extends StatefulWidget {
  const MyUpdatePage({super.key, required this.personKey});
  final String personKey;
  @override
  State<MyUpdatePage> createState() => _MyUpdatePageState();
}

class _MyUpdatePageState extends State<MyUpdatePage> {
  final DatabaseReference _reference =
      FirebaseDatabase.instance.ref().child('Users');
  final TextEditingController namaControllerEdit = TextEditingController();
  final TextEditingController alamatControllerEdit = TextEditingController();
  @override
  void initState() {
    super.initState();
    getDataUsersById();
  }

  Future getDataUsersById() async {
    DataSnapshot snapshot = await _reference.child(widget.personKey).get();
    Map person = snapshot.value as Map;

    namaControllerEdit.text = person['nama'];
    alamatControllerEdit.text = person['alamat'];
  }

  Future updateUsersById() async {
    Map<String, String> persons = {
      'nama': namaControllerEdit.text,
      'alamat': alamatControllerEdit.text,
    };
    await _reference.child(widget.personKey).update(persons).then((value) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: ((context) => const MyApp()),
        ),
      );
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(onError),
        duration: const Duration(seconds: 6),
      ));
    });
  }

  @override
  void dispose() {
    super.dispose();
    namaControllerEdit.dispose();
    alamatControllerEdit.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Users'),
      ),
      body: Card(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: namaControllerEdit,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Nama Lengkap',
                  labelText: 'Nama Lengkap',
                  hintStyle: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: TextFormField(
                controller: alamatControllerEdit,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Alamat Lengkap',
                  labelText: 'Alamat Lengkap',
                  hintStyle: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: ElevatedButton(
                onPressed: updateUsersById,
                child: const Text('Update'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
