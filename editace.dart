import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditovaniCloveka extends StatefulWidget {
  EditovaniCloveka({
    Key? key,
    required this.poznamka,
    required this.jmeno,
    required this.prijmeni,
    required this.bydliste,
    required this.kontakt1,
    required this.kontakt2,
    required this.zaplaceno,
    required this.prihlasenyUzivatel,
  }) : super(key: key);

  final String prihlasenyUzivatel;
  final String jmeno;
  final String prijmeni;
  final String bydliste;
  final String kontakt1;
  final String kontakt2;
  final String zaplaceno;
  final String poznamka;

  @override
  State<EditovaniCloveka> createState() => _EditovaniClovekaState();
}

class _EditovaniClovekaState extends State<EditovaniCloveka> {
  final jmenoController = new TextEditingController();
  final prijmeniController = new TextEditingController();
  final bydlisteController = new TextEditingController();
  final kontakt1Controller = new TextEditingController();
  final kontakt2Controller = new TextEditingController();
  final zaplacenoController = new TextEditingController();
  final poznamkaController = new TextEditingController();

  bool potvrzeno = false;

  String krouzek = '';

  String datumGDPR = '';

  final Stream<QuerySnapshot> editovanaData =
      FirebaseFirestore.instance.collection('zaci').snapshots();

  late Stream<QuerySnapshot> krouzekData = FirebaseFirestore.instance
      .collection('lekce')
      .where('ucetLekce', isEqualTo: widget.prihlasenyUzivatel)
      .snapshots();

  DateTime _datumDnesni = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Editace'),
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
                    child: Text(
                      widget.jmeno,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  //prijmeni
                  SizedBox(
                    child: Text(
                      widget.prijmeni,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              //bydliste
              SizedBox(
                child: TextField(
                  controller: bydlisteController,
                  decoration: InputDecoration(
                    hintText: 'Bydliště',
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
                        hintText: 'Kontakt 1',
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
                        hintText: 'Kontakt 2',
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
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: zaplacenoController,
                      decoration: InputDecoration(
                        hintText: 'Zaplaceno',
                        border: OutlineInputBorder(),
                      ),
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
                          activeColor: Colors.green,
                          onChanged: ((bool value) {
                            setState(() {
                              potvrzeno = value;
                              datumGDPR =
                                  DateFormat('dd.MM.yyyy').format(_datumDnesni);
                              FirebaseFirestore.instance
                                  .collection('zaci')
                                  .doc('${widget.jmeno} ${widget.prijmeni}')
                                  .update({
                                'gdpr': '${potvrzeno}',
                                'kdyGDPR': '${datumGDPR}',
                              });
                              _vymazVse();
                              //print(potvrzeno);
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
                                content: StreamBuilder<QuerySnapshot>(
                                  stream: krouzekData,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    final krouzekData = snapshot.requireData;
                                    return ListView.builder(
                                      itemCount: krouzekData.size,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          child: ListTile(
                                            title: Text(
                                                '${krouzekData.docs[index]['nazevLekce']}'),
                                            onTap: () {
                                              setState(() {
                                                krouzek =
                                                    '${krouzekData.docs[index]['nazevLekce']}';
                                              });
                                              FirebaseFirestore.instance
                                                  .collection('zaci')
                                                  .doc(
                                                      '${widget.jmeno} ${widget.prijmeni}')
                                                  .update({
                                                'krouzek': '${krouzek}',
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
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
                    hintText: widget.poznamka,
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
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () {
            if ('${bydlisteController.text}' == '') {
              FirebaseFirestore.instance
                  .collection('zaci')
                  .doc('${widget.jmeno} ${widget.prijmeni}')
                  .update({
                'kontakt1': '${kontakt1Controller.text}',
                'kontakt2': '${kontakt2Controller.text}',
                'zaplaceno': '${zaplacenoController.text}',
                'poznamka': '${poznamkaController.text}',
              });
              _vymazVse();
            } else if ('${kontakt1Controller.text}' == '') {
              FirebaseFirestore.instance
                  .collection('zaci')
                  .doc('${widget.jmeno} ${widget.prijmeni}')
                  .update({
                'bydliste': '${bydlisteController.text}',
                'kontakt2': '${kontakt2Controller.text}',
                'zaplaceno': '${zaplacenoController.text}',
                'poznamka': '${poznamkaController.text}',
              });
              _vymazVse();
            } else if ('${zaplacenoController.text}' == '') {
              FirebaseFirestore.instance
                  .collection('zaci')
                  .doc('${widget.jmeno} ${widget.prijmeni}')
                  .update({
                'bydliste': '${bydlisteController.text}',
                'kontakt1': '${kontakt1Controller.text}',
                'kontakt2': '${kontakt2Controller.text}',
                'poznamka': '${poznamkaController.text}',
              });
              _vymazVse();
            } else if ('${poznamkaController.text}' == '') {
              FirebaseFirestore.instance
                  .collection('zaci')
                  .doc('${widget.jmeno} ${widget.prijmeni}')
                  .update({
                'bydliste': '${bydlisteController.text}',
                'kontakt1': '${kontakt1Controller.text}',
                'kontakt2': '${kontakt2Controller.text}',
                'zaplaceno': '${zaplacenoController.text}',
              });
              _vymazVse();
            } else {
              FirebaseFirestore.instance
                  .collection('zaci')
                  .doc('${widget.jmeno} ${widget.prijmeni}')
                  .update({
                'bydliste': '${bydlisteController.text}',
                'kontakt1': '${kontakt1Controller.text}',
                'kontakt2': '${kontakt2Controller.text}',
                'zaplaceno': '${zaplacenoController.text}',
                'poznamka': '${poznamkaController.text}',
              });
              _vymazVse();
            }

            Navigator.pop(context);
          }),
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
