import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MaterialApp(
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
    )
  );
}
