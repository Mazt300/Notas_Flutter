import 'package:flutter/material.dart';
import 'package:notas_flutter/model/note.dart';
import 'package:notas_flutter/pages/gestionnota.dart';
import 'package:notas_flutter/pages/listanotausuario.dart';
import 'package:notas_flutter/service/noteservice.dart';

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
  final service = NoteService();
  List<Note> _nota = [], _notaTemp = [];
  bool expansion = false;
  List<String> ordenamiento = ["Titulo", "Contenido", "Fecha"];
  String opcionordenamiento = "";

  @override
  void initState() {
    _cargarnotas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    modificarfiltro(bool estado) {
      setState(() {
        expansion = estado;
      });
      if (expansion == false) {
        _ordenarnotas("");
      }
    }

    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Ordenar por: ',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          modificarfiltro(!expansion);
                        },
                        icon: const Icon(Icons.filter_alt_outlined),
                        label: const Text(''),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: expansion,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: ordenamiento
                                .map<Container>((e) => Container(
                                    padding: const EdgeInsets.all(5),
                                    child: ElevatedButton(
                                      child: Text(e.toString()),
                                      onPressed: () {
                                        _ordenarnotas(e);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0))),
                                    )))
                                .toList(),
                          ),
                        ],
                      ))
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  const Text(
                    "Buscar: ",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Filtro por titulo o contenido",
                          ),
                          controller: _buscar,
                          onChanged: _buscarnotas,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "El valor buscar no puede estar vacio";
                            }
                            return null;
                          })),
                ],
              ),
              const Divider(),
              Column(
                children: <Widget>[
                  SingleChildScrollView(
                    child: _nota.isEmpty
                        ? const Text('Sin Registros',
                            style: TextStyle(fontSize: 24))
                        : _tarjetaDeNota(),
                  )
                ],
              )
            ],
          ),
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
    List<Note> tempNote = await service.getNotes();
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
          _nota = titulonota;
        } else if (contenidonota.isNotEmpty) {
          _nota = contenidonota;
        } else {
          List<Note> lista = [];
          _nota = lista;
        }
      });
    } else {
      if (expansion == false) {
        _cargarnotas();
      } else {
        _nota = _notaTemp;
        _ordenarnotas(opcionordenamiento);
      }
    }
  }

  void _ordenarnotas(String opcion) {
    opcionordenamiento = opcion;
    setState(() {
      switch (opcion) {
        case "Titulo":
          _nota.sort((a, b) => a.titulo.compareTo(b.titulo));
          break;
        case "Contenido":
          _nota.sort((a, b) => a.contenido.compareTo(b.contenido));
          break;
        case "Fecha":
          _nota.sort((a, b) => a.fecha.compareTo(b.fecha));
          break;
        case "":
          _nota = _notaTemp;
          _nota.sort((a, b) => a.titulo.compareTo(b.titulo));
          break;
        default:
          break;
      }
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
              title: Text("Contenido: ${nota.contenido}"),
              subtitle: Text("Fecha: ${nota.fecha}"),
              // subtitle: Text(contenido),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      GestionarNotaState.validarNota(nota);
                      MenuState.tabController.animateTo(1);
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
