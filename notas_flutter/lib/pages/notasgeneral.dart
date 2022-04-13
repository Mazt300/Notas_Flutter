import 'package:flutter/material.dart';
import 'package:notas_flutter/data/basedatos.dart';
import 'package:notas_flutter/modelo/note.dart';
import 'package:notas_flutter/pages/gestionnota.dart';
import 'package:notas_flutter/pages/listanotausuario.dart';

class ListaGeneral extends StatefulWidget {
  const ListaGeneral({
    Key? key,
  }) : super(key: key);
  @override
  State<ListaGeneral> createState() => _ListaGeneralState();
}

class _ListaGeneralState extends State<ListaGeneral> {
  // final List<Nota> _notas = generarLista(8);
  List<Note> _nota = [];

  @override
  void initState() {
    _cargarnotas();
    super.initState();
  }

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
          _nota[index].expandido = !isExpanded;
        });
      },
      children: _nota.map<ExpansionPanel>(
        (Note nota) {
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

//Metodo que no retornara nada porque la variable ya esta declarada de manera glonal para poder iterar en ella y cargar las consultas
//Ademas se utiliza una variable temporal para hacer el await de la consulta y hacer una iteracion de estado para mantener actualizada la consulta
  _cargarnotas() async {
    List<Note> tempNote = await BaseDato.obtenerNotas();
    setState(() {
      _nota = tempNote;
    });
  }

  Widget _tarjetaDetalleNota(Note nota) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.note),
              title: Text(nota.contenido),
              subtitle: Text(nota.fecha),
              // subtitle: Text(contenido),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      Gestionarnota.validarNota(nota);
                      MenuState.tabController.index = 2;
                    },
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
