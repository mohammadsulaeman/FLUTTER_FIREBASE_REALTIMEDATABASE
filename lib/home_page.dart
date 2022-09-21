import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:realtimedatabase/add_data.dart';
import 'package:realtimedatabase/main.dart';
import 'package:realtimedatabase/update_data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Query dbRef =
      FirebaseDatabase.instance.reference().child('Users').orderByChild('nama');
  final DatabaseReference _reference =
      FirebaseDatabase.instance.ref().child('Users');
  Widget listPerson({required Map person}) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 5),
              child: ListTile(
                title: Text(
                  person['nama'],
                ),
                subtitle: Text(
                  person['alamat'],
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) =>
                              MyUpdatePage(personKey: person['key'])),
                        ),
                      );
                    },
                    child: const Text('Update')),
              ),
              Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () async {
                    await _reference
                        .child(person['key'])
                        .remove()
                        .then((value) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => const MyApp())));
                    }).catchError((onError) {
                      print(onError);
                    });
                  },
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> future = Firebase.initializeApp();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Firebase Realtime Database',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
          future: future,
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return const Text("errro");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return FirebaseAnimatedList(
                query: dbRef,
                itemBuilder: ((context, snapshot, animation, index) {
                  Map person = snapshot.value as Map;
                  person['key'] = snapshot.key;
                  return listPerson(person: person);
                }),
              );
            } else {
              return const Text('data');
            }
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: ((context) => const MyInsertPage())));
        },
        tooltip: "Insert",
        child: const Icon(Icons.add),
      ),
    );
  }
}
