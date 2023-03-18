import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tadytento/stranky/vytvoreniLekce.dart';
import 'package:tadytento/stranky/zapsani.dart';

import 'lide.dart';

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

  DateTime _datumNaPozdej = DateTime.now();

  final prihlasenyUzivatel = FirebaseAuth.instance.currentUser!;

  void _ukazKalendar() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    ).then((value) {
      setState(() {
        _zvoleneDatum = value!;
      });

      FirebaseFirestore.instance
          .collection('data')
          .doc(
              '${DateFormat('dd.MM.yyyy').format(_zvoleneDatum)} - ${widget.nazevLekce} - ${prihlasenyUzivatel.email!}') // popřípadě pokud by bylo více za den -->  - ${Random().nextInt(30)}
          .set({
        'upraveneDatum': '${DateFormat('dd|MM|yyyy').format(_zvoleneDatum)}',
        'datum': '${DateFormat('dd.MM.yyyy').format(_zvoleneDatum)}',
        'ucetLekce': '${prihlasenyUzivatel.email!}',
        'nazevLekce': '${widget.nazevLekce}'
      });
    });
  }

  DateTime _zvoleneDatum = DateTime.now();

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
                MaterialPageRoute(
                    builder: (context) => SeznamLidi(
                          prihlasenyUzivatel: '${prihlasenyUzivatel.email!}',
                          nazevLekce: widget.nazevLekce,
                        )),
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
                    child: Text("Přidat zpetně lekci"),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Odhlásit se"),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VytvoreniLekce(
                              aktualniUzivatel: '${prihlasenyUzivatel.email!}',
                              vybranaLekce: 'Lekce není vybrána',
                            )),
                  );
                } else if (value == 1) {
                  if (widget.nazevLekce == 'Lekce není vybraná') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Vyberte prosím lekci",
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red,
                    ));
                  } else {
                    _ukazKalendar();
                  }
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
                                        '${nejakaData.docs[index]['upraveneDatum']}',
                                    nazevLekce: '${widget.nazevLekce}',
                                    prihlasenyUzivatel:
                                        '${prihlasenyUzivatel.email!}',
                                  )),
                        );
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Smazání data'),
                            content: Text(
                                'Odstranit ${nejakaData.docs[index]['datum']}?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Zrušit"),
                              ),
                              TextButton(
                                child: const Text(
                                  'Odstranit',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("data")
                                      .doc(
                                          "${nejakaData.docs[index]['datum']} - ${widget.nazevLekce} - ${prihlasenyUzivatel.email!}")
                                      .delete();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: widget.nazevLekce == 'Lekce není vybraná'
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.clear),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('data')
                    .doc(
                        '${DateFormat('dd.MM.yyyy').format(_datumDnesni)} - ${widget.nazevLekce} - ${prihlasenyUzivatel.email!}')
                    .set({
                  'upraveneDatum':
                      '${DateFormat('dd|MM|yyyy').format(_datumDnesni)}',
                  'datum': '${DateFormat('dd.MM.yyyy').format(_datumDnesni)}',
                  'ucetLekce': '${prihlasenyUzivatel.email!}',
                  'nazevLekce': '${widget.nazevLekce}',
                });
              },
              icon: Icon(Icons.add),
              label: Text("Přidat"),
            ),
    );
  }
}
