import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  }) : super(key: key);

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

  final Stream<QuerySnapshot> editovanaData =
      FirebaseFirestore.instance.collection('zaci').snapshots();

  final Stream<QuerySnapshot> krouzekData =
      FirebaseFirestore.instance.collection('lekce').snapshots();

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
                      autofocus: false,
                      controller: jmenoController,
                      decoration: InputDecoration(
                        hintText: widget.jmeno,
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
                      autofocus: false,
                      controller: prijmeniController,
                      decoration: InputDecoration(
                        hintText: widget.prijmeni,
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
                    suffixIcon: IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('zaci')
                              .doc('${widget.jmeno} ${widget.prijmeni}')
                              .update({
                            'bydliste': '${bydlisteController.text}',
                          });
                          _vymazVse();
                        },
                        icon: Icon(Icons.check)),
                    hintText: widget.bydliste,
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
                        suffixIcon: IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('zaci')
                                  .doc('${widget.jmeno} ${widget.prijmeni}')
                                  .update({
                                'kontakt1': '${kontakt1Controller.text}',
                              });
                              _vymazVse();
                            },
                            icon: Icon(Icons.check)),
                        hintText: widget.kontakt1,
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
                        suffixIcon: IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('zaci')
                                  .doc('${widget.jmeno} ${widget.prijmeni}')
                                  .update({
                                'kontakt2': '${kontakt2Controller.text}',
                              });
                              _vymazVse();
                            },
                            icon: Icon(Icons.check)),
                        hintText: widget.kontakt2,
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
                        suffixIcon: IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('zaci')
                                  .doc('${widget.jmeno} ${widget.prijmeni}')
                                  .update({
                                'zaplaceno': '${zaplacenoController.text}',
                              });
                              _vymazVse();
                            },
                            icon: Icon(Icons.check)),
                        hintText: widget.zaplaceno,
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
                              FirebaseFirestore.instance
                                  .collection('zaci')
                                  .doc('${widget.jmeno} ${widget.prijmeni}')
                                  .update({
                                'gdpr': '${potvrzeno}',
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
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Zrušit"),
                                  ),
                                  TextButton(
                                    child: const Text('Přidat'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
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
                    suffixIcon: IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('zaci')
                              .doc('${widget.jmeno} ${widget.prijmeni}')
                              .update({
                            'poznamka': '${poznamkaController.text}',
                          });
                          _vymazVse();
                        },
                        icon: Icon(Icons.check)),
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
