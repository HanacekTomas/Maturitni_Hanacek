import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tadytento/stranky/hlavniStranka.dart';

class VytvoreniLekce extends StatefulWidget {
  const VytvoreniLekce({super.key});

  @override
  State<VytvoreniLekce> createState() => _VytvoreniLekceState();
}

class _VytvoreniLekceState extends State<VytvoreniLekce> {
  final nazevController = new TextEditingController();

  final Stream<QuerySnapshot> nakyData =
      FirebaseFirestore.instance.collection('lekce').snapshots();

  final prihlasenyUzivatel = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vytvořte lekci"),
      ),
      body: Center(
        child: FloatingActionButton(
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
                        FirebaseFirestore.instance.collection('lekce').add({
                          'NazevLekce': '${nazevController.text}',
                          'UcetLekce': '${prihlasenyUzivatel.email!}',
                          'Spojene':
                              '${prihlasenyUzivatel.email!}-${nazevController.text}',
                        });
                        Navigator.of(context).pop();
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
      ),
    );
  }

  _vymazVse() {
    nazevController.clear();
  }
}
