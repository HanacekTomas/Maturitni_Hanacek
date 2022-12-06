import 'package:flutter/material.dart';
import 'package:slidovaci_apka/stranky/homepage.dart';
import 'package:slidovaci_apka/stranky/nastaveni.dart';

class Resit extends StatefulWidget {
  const Resit({super.key});

  @override
  State<Resit> createState() => _ResitState();
}

class _ResitState extends State<Resit> {
  int _stranka = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nevyřešené"),
        ),
    );
  }
}