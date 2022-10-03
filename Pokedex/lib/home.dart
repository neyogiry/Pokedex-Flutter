import 'dart:convert';

import 'package:app/pokemon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

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
      body: PokemonListPage(),
      backgroundColor: Colors.white,
    );
  }
}

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({Key? key}) : super(key: key);

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late Future<List<Pokemon>> pokemonList;

  @override
  void initState() {
    super.initState();
    pokemonList = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pokemon>>(
      future: pokemonList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Pokemon> list = snapshot.data as List<Pokemon>;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => PokemonItem(name: list[index].name),
            itemCount: list.length,
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class PokemonItem extends StatelessWidget {
  const PokemonItem({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(name),
        )
      ],
    );
  }

}

Future<List<Pokemon>> fetchData() async {
  final response =
      await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon"));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return (json.decode(response.body)['results'] as List)
        .map((e) => Pokemon.fromJson(e))
        .toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load pokedex');
  }
}
