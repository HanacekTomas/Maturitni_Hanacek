import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tadytento/stranky/pridatCloveka.dart';
import 'package:toggle_switch/toggle_switch.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nazevLekce} - ${widget.datumDochazky}'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: zapsaniDochazkyData,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  title: Text(
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
//pokud jich bude víc, tak -> >${Random().nextInt(10)}