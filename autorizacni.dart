import 'package:flutter/material.dart';
import 'package:tadytento/auth/registrace.dart';
import 'package:tadytento/auth/prihlaseni.dart';

class Autorizacni extends StatefulWidget {
  const Autorizacni({super.key});

  @override
  State<Autorizacni> createState() => _AutorizacniState();
}

class _AutorizacniState extends State<Autorizacni> {
  bool ukazatPrihlaseni = true;

  void prehodStranky() {
    setState(() {
      ukazatPrihlaseni = !ukazatPrihlaseni;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ukazatPrihlaseni) {
      return Prihlaseni(ukazRegistrace: prehodStranky);
    } else {
      return Registrace(ukazPrihlaseni: prehodStranky);
    }
  }
}
