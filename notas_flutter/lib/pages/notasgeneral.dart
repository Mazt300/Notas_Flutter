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
  final _formkey = GlobalKey<FormState>();
  final _buscar = TextEditingController();
  List<Note> _nota = [];
  List<Note> _notaTemp = [];
  bool expansion = false;

  @override
  void initState() {
    _cargarnotas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Text(
                    "Buscar: ",
                    textAlign: TextAlign.left,
                  ),
                  Flexible(
                      child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Filtro por titulo o contenido"),
                          controller: _buscar,
                          onChanged: _buscarnotas,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "El valor buscar no puede estar vacio";
                            }
                            return null;
                          })),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       // _buscarnotas(_buscar.text);
                  //     },
                  //     child: const Icon(Icons.search))
                ],
              ),
              const Divider(),
              Column(
                children: <Widget>[
                  SingleChildScrollView(
                    child: _nota.isEmpty
                        ? const Text('Sin Registros',
                            style: TextStyle(fontSize: 24))
                        : _tarjetaDeNota(expansion),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget _tarjetaDeNota(bool? expansion) {
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
      _notaTemp = _nota;
    });
  }

  void _buscarnotas(String query) {
    if (query.isNotEmpty) {
      final titulonota = _notaTemp.where((x) {
        final titulo = x.titulo.toLowerCase();
        final input = query.toLowerCase();

        return titulo.contains(input);
      }).toList();

      final contenidonota = _notaTemp.where((x) {
        final contenido = x.contenido.toLowerCase();
        final input = query.toLowerCase();

        return contenido.contains(input);
      }).toList();

      setState(() {
        if (titulonota.isNotEmpty) {
          expansion = true;
          _nota = titulonota;
        } else if (contenidonota.isNotEmpty) {
          expansion = true;
          _nota = contenidonota;
        } else {
          List<Note> lista = [];
          _nota = lista;
        }
      });
    } else {
      _cargarnotas();
    }
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
                      GestionarNotaState.validarNota(nota);
                      MenuState.tabController.animateTo(2);
                    },
                    icon: const Icon(Icons.edit_calendar_outlined),
                    label: const Text('Editar')),
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
