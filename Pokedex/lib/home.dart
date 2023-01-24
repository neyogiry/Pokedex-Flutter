import 'dart:convert';

import 'package:app/pokemon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';
import '../util/constants.dart' as constants;

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
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) => PokemonItem(name: list[index].name, url: list[index].url,),
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

class PokemonItem extends StatefulWidget {
  const PokemonItem({Key? key, required this.name, required this.url}) : super(key: key);
  final String name;
  final String url;

  @override
  State<PokemonItem> createState() => _PokemonItemState();
}

class _PokemonItemState extends State<PokemonItem> {
  Color backgroundColor = Colors.transparent;
  late Image image;


  @override
  void initState() {
    super.initState();
    _loadImage();
    _updatePaletteGenerator();
  }

  _loadImage() async {
    image = Image.network(pokemonImageUrl(widget.url));
  }

  _updatePaletteGenerator() async {
    PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
        image.image,
        size: const Size(100, 100)
    );
    setState(() {
      backgroundColor = paletteGenerator.dominantColor?.color ?? Colors.transparent;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        children: [
          Expanded(
              child: Image(image: image.image)
          ),
          Text(widget.name),
        ],
      ),
    );
  }

  pokemonImageUrl(String url) {
    List<String> splitted = url.split("/");
    splitted.removeLast();
    int index = int.parse(splitted.last);
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$index.png";
  }

}

Future<List<Pokemon>> fetchData() async {
  final response = await http.get(Uri.parse(constants.baseUrl));

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
