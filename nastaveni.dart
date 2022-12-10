import 'package:flutter/material.dart';
import 'package:slidovaci_apka/stranky/homepage.dart';
import 'package:slidovaci_apka/stranky/resit.dart';

class Nastaveni extends StatefulWidget {
  const Nastaveni({super.key});

  @override
  State<Nastaveni> createState() => _NastaveniState();
}

class _NastaveniState extends State<Nastaveni> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nastavení"),
        backgroundColor: Colors.blue,
      ),
    );
  }
}