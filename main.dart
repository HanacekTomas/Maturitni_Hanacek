import 'package:flutter/material.dart';
import 'package:tadytento/stranky/hlavniStranka.dart';
import 'package:tadytento/auth/prihlaseni.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tadytento/stranky/lide.dart';
import 'package:tadytento/stranky/splash_screen.dart';
import 'package:tadytento/stranky/zapsani.dart';

import 'auth/cesty.dart';
import 'auth/registrace.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Uvodni());
}

class Uvodni extends StatelessWidget {
  const Uvodni({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Cesty(),
    );
  }
}
