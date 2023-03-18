import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tadytento/stranky/editace.dart';
import 'package:tadytento/stranky/gdpr.dart';
import 'package:tadytento/stranky/nezaplaceni.dart';
import 'package:tadytento/stranky/pridatCloveka.dart';

class SeznamLidi extends StatefulWidget {
  const SeznamLidi(
      {super.key, required this.prihlasenyUzivatel, required this.nazevLekce});

  final String prihlasenyUzivatel;
  final String nazevLekce;

  @override
  State<SeznamLidi> createState() => _SeznamLidiState();
}

class _SeznamLidiState extends State<SeznamLidi> {
  final jmenoController = new TextEditingController();
  final prijmeniController = new TextEditingController();
  final bydlisteController = new TextEditingController();
  final kontakt1Controller = new TextEditingController();
  final kontakt2Controller = new TextEditingController();
  final zaplacenoController = new TextEditingController();
  final poznamkaController = new TextEditingController();
  final gdprController = new TextEditingController();
  final krouzekController = new TextEditingController();

  late Stream<QuerySnapshot> zaseData = FirebaseFirestore.instance
      .collection('zaci')
      .where('vytvorenoUctem', isEqualTo: widget.prihlasenyUzivatel)
      .snapshots();

  bool podminka = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: PopupMenuButton(
            icon: Icon(Icons.filter_list),
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Není GDPR"),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Nezaplaceno"),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text("Vše"),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NeniGDPR(
                              prihlasenyUzivatel: widget.prihlasenyUzivatel,
                            )));
              } else if (value == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Nezaplaceno(
                              prihlasenyUzivatel: widget.prihlasenyUzivatel,
                            )));
              } else if (value == 2) {}
            }),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PridatLidi(
                    prihlasenyUzivatel: widget.prihlasenyUzivatel,
                  ),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.storage),
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: zaseData,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Něco je špatně");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Načítám");
            }

            final asiData = snapshot.requireData;

            return ListView.builder(
              itemCount: asiData.size,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Smazání žáka'),
                            content: Text(
                                'Odstranit ${asiData.docs[index]['jmeno']} ${asiData.docs[index]['prijmeni']}?'),
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
                                      .collection("zaci")
                                      .doc(
                                          "${asiData.docs[index]['jmeno']} ${asiData.docs[index]['prijmeni']}")
                                      .delete();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text(
                                      '${asiData.docs[index]['jmeno']} ${asiData.docs[index]['prijmeni']}'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.home),
                                  title: '${asiData.docs[index]['bydliste']}' ==
                                          ''
                                      ? Text('Nedoplněno',
                                          style: TextStyle(color: Colors.red))
                                      : Text(
                                          '${asiData.docs[index]['bydliste']}'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.contact_phone),
                                  title: '${asiData.docs[index]['kontakt1']}' ==
                                          ''
                                      ? Text('Nedoplněno',
                                          style: TextStyle(color: Colors.red))
                                      : Text(
                                          '${asiData.docs[index]['kontakt1']} / ${asiData.docs[index]['kontakt2']}'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.group),
                                  title: '${asiData.docs[index]['krouzek']}' ==
                                          ''
                                      ? Text('Nedoplněno',
                                          style: TextStyle(color: Colors.red))
                                      : Text(
                                          '${asiData.docs[index]['krouzek']}'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.monetization_on),
                                  title: '${asiData.docs[index]['zaplaceno']}' ==
                                          ''
                                      ? Text('Nedoplněno',
                                          style: TextStyle(color: Colors.red))
                                      : Text(
                                          '${asiData.docs[index]['zaplaceno']}'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.add_a_photo),
                                  title: '${asiData.docs[index]['gdpr']}' ==
                                          'false'
                                      ? Text('Zakázáno',
                                          style: TextStyle(color: Colors.red))
                                      : Text(
                                          'Povoleno, ${asiData.docs[index]['kdyGDPR']}',
                                          style:
                                              TextStyle(color: Colors.green)),
                                ),
                                ListTile(
                                  leading: Icon(Icons.speaker_notes),
                                  title: Text(
                                      '${asiData.docs[index]['poznamka']}'),
                                ),
                              ],
                            );
                          });
                    },
                    title: Text(
                        '${asiData.docs[index]['jmeno']} ${asiData.docs[index]['prijmeni']}'),
                    subtitle: Text('${asiData.docs[index]['krouzek']}'),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditovaniCloveka(
                              poznamka: '${asiData.docs[index]['poznamka']}',
                              bydliste: '${asiData.docs[index]['bydliste']}',
                              jmeno: '${asiData.docs[index]['jmeno']}',
                              kontakt1: '${asiData.docs[index]['kontakt1']}',
                              kontakt2: '${asiData.docs[index]['kontakt2']}',
                              prijmeni: '${asiData.docs[index]['prijmeni']}',
                              zaplaceno: '${asiData.docs[index]['zaplaceno']}',
                              prihlasenyUzivatel: widget.prihlasenyUzivatel,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
