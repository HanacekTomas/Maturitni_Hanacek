import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:tadytento/stranky/zapsani.dart';
import 'lide.dart';
import 'package:tadytento/stranky/vytvoreniLekce.dart';
import 'dart:math';

class HlavniStranka extends StatefulWidget {
  const HlavniStranka({
    Key? key,
    required this.nazevLekce,
  }) : super(key: key);

  final String nazevLekce;

  @override
  State<HlavniStranka> createState() => _HlavniStrankaState();
}

class _HlavniStrankaState extends State<HlavniStranka> {
  late Stream<QuerySnapshot> nakyData = FirebaseFirestore.instance
      .collection('data')
      .where("nazevLekce", isEqualTo: widget.nazevLekce)
      .snapshots();

  var nahodne = Random().nextInt(30);

  var Datum = '';

  DateTime _datumDnesni = DateTime.now();

  final prihlasenyUzivatel = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    CollectionReference data = FirebaseFirestore.instance.collection('data');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.nazevLekce),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SeznamLidi()),
              );
            },
            icon: Icon(Icons.supervisor_account),
          ),
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Přidat/Vybrat lekci"),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Tmavý/Světlý režim"),
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
                        builder: (context) => VytvoreniLekce(
                              aktualniUzivatel: '${prihlasenyUzivatel.email!}',
                            )),
                  );
                } else if (value == 1) {
                  
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
                    title: Text('${nejakaData.docs[index]['datum']}'),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ZapsaniDochazky(
                                    datumDochazky:
                                        '${nejakaData.docs[index]['datum']}',
                                    nazevLekce: '${widget.nazevLekce}',
                                  )),
                        );
                      },
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
          FirebaseFirestore.instance
              .collection('data')
              .doc(
                  '${DateFormat('dd.MM.yyyy').format(_datumDnesni)} - ${widget.nazevLekce} - ${prihlasenyUzivatel.email!} - ${Random().nextInt(30)}')
              .set({
            'datum': '${DateFormat('dd.MM.yyyy').format(_datumDnesni)}',
            'ucetLekce': '${prihlasenyUzivatel.email!}',
            'nazevLekce': '${widget.nazevLekce}'
          });
        },
        icon: Icon(Icons.add),
        label: Text("Přidat"),
      ),
    );
  }
}
