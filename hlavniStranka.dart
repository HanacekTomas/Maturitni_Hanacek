import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tadytento/stranky/vytvoreniLekce.dart';

class HlavniStranka extends StatelessWidget {
  HlavniStranka({Key? key}) : super(key: key);

  final Stream<QuerySnapshot> nakyData =
      FirebaseFirestore.instance.collection('data').snapshots();

  var Datum = '';

  DateTime _datumDnesni = DateTime.now();

  final prihlasenyUzivatel = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    CollectionReference data = FirebaseFirestore.instance.collection('data');
    return Scaffold(
      appBar: AppBar(
        title: Text(prihlasenyUzivatel.email!),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Přidat lekci"),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Nastavení"),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Odhlásit se"),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  print("Vytvořit lekci...");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VytvoreniLekce()),
                  );
                } else if (value == 1) {
                  print("Settings menu is selected.");
                } else if (value == 2) {
                  FirebaseAuth.instance.signOut();
                }
              }),
        ],
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: nakyData,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Něco je špatně");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Načítám");
            }

            final nejakaData = snapshot.requireData;

            return ListView.builder(
              itemCount: nejakaData.size,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('${nejakaData.docs[index]['Datum']}'),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_circle_right),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          FirebaseFirestore.instance.collection('data').add({
            'Datum': '${DateFormat('dd.MM.yyyy').format(_datumDnesni)}',
          });
        },
        icon: Icon(Icons.add),
        label: Text("Přidat"),
      ),
    );
  }
}
