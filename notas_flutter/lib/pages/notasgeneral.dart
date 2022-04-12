import 'package:flutter/material.dart';

class ListaGeneral extends StatefulWidget {
  const ListaGeneral({Key? key}) : super(key: key);

  @override
  State<ListaGeneral> createState() => _ListaGeneralState();
}

class _ListaGeneralState extends State<ListaGeneral> {
  final games = ["Lista de notas", "Buscar notas", "CRUD notas"];
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Text(
                  "Buscar: ",
                  textAlign: TextAlign.left,
                ),
                const Flexible(
                    child: TextField(
                  obscureText: true,
                )),
                ElevatedButton(
                    onPressed: () {}, child: const Icon(Icons.search))
              ],
            ),
            const Divider(),
            Column(
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: games.length,
                  itemBuilder: (context, index) => Text(games[index]),
                ),
              ],
            )
          ],
        ));
  }
}
