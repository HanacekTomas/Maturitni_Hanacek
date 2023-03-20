import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class PridatLidi extends StatefulWidget {
  const PridatLidi({
    super.key,
    required this.prihlasenyUzivatel,
  });

  final String prihlasenyUzivatel;

  @override
  State<PridatLidi> createState() => _PridatLidiState();
}

class _PridatLidiState extends State<PridatLidi> {
  final jmenoController = new TextEditingController();
  final prijmeniController = new TextEditingController();
  final bydlisteController = new TextEditingController();
  final kontakt1Controller = new TextEditingController();
  final kontakt2Controller = new TextEditingController();
  final zaplacenoController = new TextEditingController();
  final poznamkaController = new TextEditingController();

  String datumGDPR = '';

  bool potvrzeno = false;
  bool zaplaceno = false;

  String krouzek = '';

  final prihlasenyUzivatel = FirebaseAuth.instance.currentUser!.email;

  final Stream<QuerySnapshot> zaciData =
      FirebaseFirestore.instance.collection('zaci').snapshots();

  late Stream<QuerySnapshot> data = FirebaseFirestore.instance
      .collection('lekce')
      .where('ucetLekce', isEqualTo: widget.prihlasenyUzivatel)
      .snapshots();

  DateTime _datumDnesni = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Přidejte osobu'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  //jmeno
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: jmenoController,
                      decoration: InputDecoration(
                        hintText: "Jméno",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  //prijmeni
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: prijmeniController,
                      decoration: InputDecoration(
                        hintText: "Příjmení",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              //bydliste
              SizedBox(
                child: TextField(
                  controller: bydlisteController,
                  decoration: InputDecoration(
                    hintText: "Bydliště",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  //kontakt1
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: kontakt1Controller,
                      decoration: InputDecoration(
                        hintText: "Kontakt 1",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  //kontakt2
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: kontakt2Controller,
                      decoration: InputDecoration(
                        hintText: "Kontakt 2",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              Row(
                children: [
                  //zaplaceno
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.33,
                    child: Column(
                      children: [
                        Text('Zaplaceno'),
                        Switch(
                          value: zaplaceno,
                          activeColor: Barvy.barvaAktivnihoTlacitka,
                          onChanged: ((bool value) {
                            setState(() {
                              zaplaceno = value;
                            });
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  //gdpr
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      children: [
                        Text('GDPR'),
                        Switch(
                          value: potvrzeno,
                          activeColor: Barvy.barvaAktivnihoTlacitka,
                          onChanged: ((bool value) {
                            setState(() {
                              potvrzeno = value;
                              datumGDPR =
                                  DateFormat('dd.MM.yyyy').format(_datumDnesni);
                            });
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  //krouzek
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(children: [
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Vyberte'),
                                content: SingleChildScrollView(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: data,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      final pridatData = snapshot.requireData;
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: pridatData.size,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            child: ListTile(
                                              title: Text(
                                                  '${pridatData.docs[index]['nazevLekce']}'),
                                              onTap: () {
                                                setState(() {
                                                  krouzek =
                                                      '${pridatData.docs[index]['nazevLekce']}';
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text("Vybrat kroužek"),
                      ),
                      Text(krouzek),
                    ]),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              SizedBox(
                child: TextField(
                  controller: poznamkaController,
                  decoration: InputDecoration(
                    hintText: "Poznámka",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * 0.20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (jmenoController.text == '') {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Jméno nesmí zůstat prázdné!")));
          } else if (prijmeniController.text == '') {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Příjmení nesmí zůstat prázdné!")));
          } else {
            FirebaseFirestore.instance
                .collection('zaci')
                .doc('${jmenoController.text} ${prijmeniController.text}')
                .set({
              'jmeno': '${jmenoController.text}',
              'prijmeni': '${prijmeniController.text}',
              'bydliste': '${bydlisteController.text}',
              'kontakt1': '${kontakt1Controller.text}',
              'kontakt2': '${kontakt2Controller.text}',
              'zaplaceno': '${zaplaceno}',
              'gdpr': '${potvrzeno}',
              'krouzek': '${krouzek}',
              'poznamka': '${poznamkaController.text}',
              'vytvorenoUctem': '${prihlasenyUzivatel}',
              'kdyGDPR': '${datumGDPR}',
            });
            _vymazVse();
          }
        },
        icon: Icon(Icons.add),
        label: Text("Přidat"),
      ),
    );
  }

  _vymazVse() {
    jmenoController.clear();
    prijmeniController.clear();
    bydlisteController.clear();
    kontakt1Controller.clear();
    kontakt2Controller.clear();
    poznamkaController.clear();
    zaplacenoController.clear();
  }
}
