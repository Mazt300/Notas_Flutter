import 'package:flutter/material.dart';
import 'package:notas_flutter/route/routing.dart';

class ListaGeneral extends StatefulWidget {
  const ListaGeneral({Key? key}) : super(key: key);

  @override
  State<ListaGeneral> createState() => _ListaGeneralState();
}

class _ListaGeneralState extends State<ListaGeneral> {
  final List<Nota> _notas = generarLista(8);
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
                const Flexible(child: TextField()),
                ElevatedButton(
                    onPressed: () {}, child: const Icon(Icons.search))
              ],
            ),
            const Divider(),
            Column(
              children: <Widget>[
                SingleChildScrollView(
                  child: _tarjetaDeNota(),
                )
              ],
            )
          ],
        ));
  }

  Widget _tarjetaDeNota() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _notas[index].expandido = !isExpanded;
        });
      },
      children: _notas.map<ExpansionPanel>(
        (Nota nota) {
          return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(nota.titulo),
                );
              },
              body: _tarjetaDetalleNota(nota),
              isExpanded: nota.expandido);
        },
      ).toList(),
    );
  }

  Widget _tarjetaDetalleNota(Nota nota) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.note),
              title: Text(nota.contenido),
              // subtitle: Text(contenido),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_calendar_outlined),
                    label: const Text('Editar')),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.remove_red_eye),
                    label: const Text('Visualizar')),
                const SizedBox(
                  width: 5,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
