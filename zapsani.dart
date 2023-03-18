import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ZapsaniDochazky extends StatefulWidget {
  const ZapsaniDochazky(
      {Key? key,
      required this.datumDochazky,
      required this.nazevLekce,
      required this.prihlasenyUzivatel})
      : super(key: key);

  final String datumDochazky;
  final String nazevLekce;
  final String prihlasenyUzivatel;
  @override
  State<ZapsaniDochazky> createState() => _ZapsaniDochazkyState();
}

class _ZapsaniDochazkyState extends State<ZapsaniDochazky> {
  late Stream<QuerySnapshot> zapsaniDochazkyData = FirebaseFirestore.instance
      .collection('zaci')
      .where('krouzek', isEqualTo: widget.nazevLekce)
      .snapshots();

  late Stream<QuerySnapshot> nejsouTady = FirebaseFirestore.instance
      .collection('zaci')
      .where('krouzek', isEqualTo: widget.nazevLekce)
      .where('${widget.nazevLekce}.${widget.datumDochazky}',
          isEqualTo: 'nepřítomen')
      .snapshots();

  late Stream<QuerySnapshot> jsouTady = FirebaseFirestore.instance
      .collection('zaci')
      .where('krouzek', isEqualTo: widget.nazevLekce)
      .where('${widget.nazevLekce}.${widget.datumDochazky}',
          isEqualTo: 'přítomen')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.nazevLekce} - ${widget.datumDochazky}'),
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.cancel_sharp),
            ),
            Tab(
              icon: Icon(Icons.live_help),
            ),
            Tab(
              icon: Icon(Icons.done_rounded),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: nejsouTady,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Něco je špatně");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Načítám');
                  }

                  final dochazkoveData = snapshot.requireData;

                  return ListView.builder(
                    itemCount: dochazkoveData.size,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: '${dochazkoveData.docs[index]['gdpr']}' ==
                                    'false' ||
                                '${dochazkoveData.docs[index]['zaplaceno']}' ==
                                    ''
                            ? Text(
                                '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}',
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(
                                '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}'),
                        tileColor: Color.fromARGB(255, 223, 166, 166),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check,
                                  color: Color.fromARGB(255, 0, 134, 4)),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        "${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']} je přítomen")));

                                FirebaseFirestore.instance
                                    .collection('lekce')
                                    .doc('${widget.nazevLekce}')
                                    .update({
                                  '${widget.datumDochazky}.${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}':
                                      'přítomen'
                                });

                                FirebaseFirestore.instance
                                    .collection('zaci')
                                    .doc(
                                        '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}')
                                    .update({
                                  '${widget.nazevLekce}.${widget.datumDochazky}':
                                      'přítomen'
                                });
                              },
                            ),
                          ],
                        ),
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
                                          '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.home),
                                      title: '${dochazkoveData.docs[index]['bydliste']}' ==
                                              ''
                                          ? Text('Nedoplněno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              '${dochazkoveData.docs[index]['bydliste']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.contact_phone),
                                      title: '${dochazkoveData.docs[index]['kontakt1']}' ==
                                              ''
                                          ? Text('Nedoplněno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              '${dochazkoveData.docs[index]['kontakt1']} / ${dochazkoveData.docs[index]['kontakt2']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.group),
                                      title: '${dochazkoveData.docs[index]['krouzek']}' ==
                                              ''
                                          ? Text('Nedoplněno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              '${dochazkoveData.docs[index]['krouzek']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.monetization_on),
                                      title: '${dochazkoveData.docs[index]['zaplaceno']}' ==
                                              ''
                                          ? Text('Nedoplněno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              '${dochazkoveData.docs[index]['zaplaceno']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.add_a_photo),
                                      title: '${dochazkoveData.docs[index]['gdpr']}' ==
                                              'false'
                                          ? Text('Zakázáno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              'Povoleno, ${dochazkoveData.docs[index]['kdyGDPR']}',
                                              style: TextStyle(
                                                  color: Colors.green)),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.speaker_notes),
                                      title: Text(
                                          '${dochazkoveData.docs[index]['poznamka']}'),
                                    ),
                                  ],
                                );
                              });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: zapsaniDochazkyData,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Něco je špatně");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Načítám');
                  }

                  final dochazkoveData = snapshot.requireData;

                  return ListView.builder(
                    itemCount: dochazkoveData.size,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: '${dochazkoveData.docs[index]['gdpr']}' ==
                                    'false' ||
                                '${dochazkoveData.docs[index]['zaplaceno']}' ==
                                    ''
                            ? Text(
                                '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}',
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(
                                '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}'),
                        tileColor: Colors.white,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check,
                                  color: Color.fromARGB(255, 0, 134, 4)),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        "${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']} je přítomen")));

                                FirebaseFirestore.instance
                                    .collection('lekce')
                                    .doc('${widget.nazevLekce}')
                                    .update({
                                  '${widget.datumDochazky}.${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}':
                                      'přítomen'
                                });

                                FirebaseFirestore.instance
                                    .collection('zaci')
                                    .doc(
                                        '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}')
                                    .update({
                                  '${widget.nazevLekce}.${widget.datumDochazky}':
                                      'přítomen'
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear,
                                  color: Color.fromARGB(255, 154, 18, 8)),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        "${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']} není přítomen")));

                                FirebaseFirestore.instance
                                    .collection('lekce')
                                    .doc('${widget.nazevLekce}')
                                    .update({
                                  '${widget.datumDochazky}.${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}':
                                      'nepřítomen'
                                });

                                FirebaseFirestore.instance
                                    .collection('zaci')
                                    .doc(
                                        '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}')
                                    .update({
                                  '${widget.nazevLekce}.${widget.datumDochazky}':
                                      'nepřítomen',
                                });
                              },
                            ),
                          ],
                        ),
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
                                          '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.home),
                                      title: '${dochazkoveData.docs[index]['bydliste']}' ==
                                              ''
                                          ? Text('Nedoplněno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              '${dochazkoveData.docs[index]['bydliste']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.contact_phone),
                                      title: '${dochazkoveData.docs[index]['kontakt1']}' ==
                                              ''
                                          ? Text('Nedoplněno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              '${dochazkoveData.docs[index]['kontakt1']} / ${dochazkoveData.docs[index]['kontakt2']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.group),
                                      title: '${dochazkoveData.docs[index]['krouzek']}' ==
                                              ''
                                          ? Text('Nedoplněno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              '${dochazkoveData.docs[index]['krouzek']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.monetization_on),
                                      title: '${dochazkoveData.docs[index]['zaplaceno']}' ==
                                              ''
                                          ? Text('Nedoplněno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              '${dochazkoveData.docs[index]['zaplaceno']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.add_a_photo),
                                      title: '${dochazkoveData.docs[index]['gdpr']}' ==
                                              'false'
                                          ? Text('Zakázáno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              'Povoleno, ${dochazkoveData.docs[index]['kdyGDPR']}',
                                              style: TextStyle(
                                                  color: Colors.green)),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.speaker_notes),
                                      title: Text(
                                          '${dochazkoveData.docs[index]['poznamka']}'),
                                    ),
                                  ],
                                );
                              });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: jsouTady,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Něco je špatně");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Načítám');
                  }

                  final dochazkoveData = snapshot.requireData;

                  return ListView.builder(
                    itemCount: dochazkoveData.size,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: '${dochazkoveData.docs[index]['gdpr']}' ==
                                    'false' ||
                                '${dochazkoveData.docs[index]['zaplaceno']}' ==
                                    ''
                            ? Text(
                                '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}',
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(
                                '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}'),
                        tileColor: Color.fromARGB(255, 162, 220, 175),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.clear,
                                  color: Color.fromARGB(255, 154, 18, 8)),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        "${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']} není přítomen")));

                                FirebaseFirestore.instance
                                    .collection('lekce')
                                    .doc('${widget.nazevLekce}')
                                    .update({
                                  '${widget.datumDochazky}.${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}':
                                      'nepřítomen'
                                });

                                FirebaseFirestore.instance
                                    .collection('zaci')
                                    .doc(
                                        '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}')
                                    .update({
                                  '${widget.nazevLekce}.${widget.datumDochazky}':
                                      'nepřítomen',
                                });
                              },
                            ),
                          ],
                        ),
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
                                          '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.home),
                                      title: '${dochazkoveData.docs[index]['bydliste']}' ==
                                              ''
                                          ? Text('Nedoplněno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              '${dochazkoveData.docs[index]['bydliste']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.contact_phone),
                                      title: '${dochazkoveData.docs[index]['kontakt1']}' ==
                                              ''
                                          ? Text('Nedoplněno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              '${dochazkoveData.docs[index]['kontakt1']} / ${dochazkoveData.docs[index]['kontakt2']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.group),
                                      title: '${dochazkoveData.docs[index]['krouzek']}' ==
                                              ''
                                          ? Text('Nedoplněno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              '${dochazkoveData.docs[index]['krouzek']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.monetization_on),
                                      title: '${dochazkoveData.docs[index]['zaplaceno']}' ==
                                              ''
                                          ? Text('Nedoplněno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              '${dochazkoveData.docs[index]['zaplaceno']}'),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.add_a_photo),
                                      title: '${dochazkoveData.docs[index]['gdpr']}' ==
                                              'false'
                                          ? Text('Zakázáno',
                                              style:
                                                  TextStyle(color: Colors.red))
                                          : Text(
                                              'Povoleno, ${dochazkoveData.docs[index]['kdyGDPR']}',
                                              style: TextStyle(
                                                  color: Colors.green)),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.speaker_notes),
                                      title: Text(
                                          '${dochazkoveData.docs[index]['poznamka']}'),
                                    ),
                                  ],
                                );
                              });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//pokud jich bude víc, tak -> >${Random().nextInt(10)}