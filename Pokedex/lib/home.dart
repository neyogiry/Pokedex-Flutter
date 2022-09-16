import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final items = List<String>.generate(150, (index) => "Pokemon #${index+1}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Pokedex'),
        ),
        backgroundColor: Color(0xFFD53B47),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xFFD53B47),
        ),
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
            );
          }
      ),
      backgroundColor: Colors.white,
    );
  }
}