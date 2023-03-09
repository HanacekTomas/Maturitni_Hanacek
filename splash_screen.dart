import 'package:flutter/material.dart';
import '../auth/cesty.dart';
import '/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Cesty()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.network(
              'https://pixabay.com/get/g71c79a89780daa092ae5ae95dcbd8bd6af569d9c90e2616c9320b6eb7c1cc48b4e7d01941a13d67c692a19d6a160e907_340.png'),
        ),
      ),
    );
  }
}
