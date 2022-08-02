import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Pokedex'),
          ),
          backgroundColor: Color(0xFFD53B47),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFFD53B47),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

