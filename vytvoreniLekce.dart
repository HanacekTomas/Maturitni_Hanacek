import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tadytento/stranky/hlavniStranka.dart';

class VytvoreniLekce extends StatefulWidget {
  const VytvoreniLekce(
      {Key? key, required this.aktualniUzivatel, required this.vybranaLekce})
      : super(key: key);

  final String aktualniUzivatel;
  final String vybranaLekce;

  @override
  State<VytvoreniLekce> createState() => _VytvoreniLekceState();
}

class _VytvoreniLekceState extends State<VytvoreniLekce> {
  final nazevController = new TextEditingController();

  final aktualniUzivatel = FirebaseAuth.instance.currentUser!;

  late Stream<QuerySnapshot> vytvoreniLekceData = FirebaseFirestore.instance
      .collection('lekce')
      .where('ucetLekce', isEqualTo: widget.aktualniUzivatel)
      .snapshots();

  final prihlasenyUzivatel = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    CollectionReference data = FirebaseFirestore.instance.collection('lekce');
    return Scaffold(
      appBar: AppBar(
        title: Text("Vytvořte/Vyberte lekci"),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: vytvoreniLekceData,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Něco je špatně");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Načítám");
            }

            final lekceData = snapshot.requireData;

            return ListView.builder(
              itemCount: lekceData.size,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('${lekceData.docs[index]['nazevLekce']}'),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HlavniStranka(
                              nazevLekce:
                                  '${lekceData.docs[index]['nazevLekce']}',
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Vytvoření lekce'),
                content: TextField(
                  controller: nazevController,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: "Vložte název lekce",
                    border: OutlineInputBorder(),
                  ),
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
                      FirebaseFirestore.instance
                          .collection('lekce')
                          .doc('${nazevController.text}')
                          .set({
                        'nazevLekce': '${nazevController.text}',
                        'ucetLekce': '${prihlasenyUzivatel.email!}',
                      });
                      Navigator.pop(context);
                      print(nazevController.text);
                      _vymazVse();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _vymazVse() {
    nazevController.clear();
  }
}
