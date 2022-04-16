import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notas_flutter/model/note.dart';
import 'package:notas_flutter/pages/tabmenu.dart';
import 'package:notas_flutter/service/noteservice.dart';

class GestionarNota extends StatefulWidget {
  const GestionarNota({Key? key}) : super(key: key);

  @override
  State<GestionarNota> createState() => GestionarNotaState();
}

class GestionarNotaState extends State<GestionarNota> {
  final _formkey = GlobalKey<FormState>();
  static final titulo = TextEditingController();
  static final contenido = TextEditingController();
  final color = const Color.fromARGB(255, 163, 64, 255);
  final service = NoteService();
  static Note noteactualizar = Note.empty();
  static bool edicion = false;
  static String _fechaSeleccionada = "";
  final String _formatofecha = "dd-MM-yyyy";
  late DateTime _fechaRegistro;

  static bool? validarNota(Note note) {
    noteactualizar = note;
    if (noteactualizar.id != null) {
      titulo.text = noteactualizar.titulo;
      contenido.text = noteactualizar.contenido;
      edicion = true;
    } else {
      titulo.text = "";
      contenido.text = "";
      edicion = false;
    }
    return edicion;
  }

  @override
  void initState() {
    setState(() {
      if (noteactualizar.id != null) {
        _fechaSeleccionada =
            DateFormat('dd-MM-yyyy').format(noteactualizar.fecha);
      } else {
        limpiarvariableslocales();
      }
      _fechaRegistro = DateTime.now();
    });
    super.initState();
  }

  void _cargarDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((fechaseleccionada) {
      if (fechaseleccionada == null || noteactualizar.id == null) {
        _fechaSeleccionada = DateFormat(_formatofecha).format(DateTime.now());
      }
      setState(() {
        _fechaSeleccionada =
            DateFormat(_formatofecha).format(fechaseleccionada!);
        _fechaRegistro = fechaseleccionada;
      });
    });
  }

  limpiarvariableslocales() {
    setState(() {
      _fechaSeleccionada = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return vistaprincial();
  }

  Widget vistaprincial() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
          key: _formkey,
          child: Column(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      _cargarDatePicker();
                    },
                    icon: const Icon(Icons.date_range_outlined),
                    label: const Text('Seleccionar fecha')),
                _fechaSeleccionada == ""
                    ? const Text('')
                    : Text(_fechaSeleccionada)
              ],
            ),
            TextFormField(
              controller: titulo,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingrese información al titulo";
                }
                return null;
              },
              decoration: const InputDecoration(
                  hintText: "Titulo", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: contenido,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingrese información al contenido";
                }
                return null;
              },
              maxLines: 15,
              maxLength: 200,
              decoration: const InputDecoration(
                  hintText: "Contenido", border: OutlineInputBorder()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        if (noteactualizar.id == null) {
                          noteactualizar = Note(
                              titulo: titulo.text,
                              contenido: contenido.text,
                              fecha: _fechaRegistro,
                              estado: 1);
                          int result = await service.insertNote(noteactualizar);
                          if (result > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: color,
                                content: Container(
                                  height: 20,
                                  alignment: Alignment.center,
                                  child: const Text('Guardado con exito',
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: "Arial")),
                                )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: color,
                                content: Container(
                                    height: 20,
                                    alignment: Alignment.center,
                                    child: const Text('Error al guardar',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Arial")))));
                          }
                          limpiarvariableslocales();
                          MenuState.tabController.animateTo(0);
                        } else {
                          noteactualizar.titulo = titulo.text;
                          noteactualizar.contenido = contenido.text;
                          noteactualizar.fecha = _fechaRegistro;
                          int result = await service.updateNote(noteactualizar);
                          if (result > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: color,
                                content: Container(
                                    height: 20,
                                    alignment: Alignment.center,
                                    child: const Text('Editado correctamente',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Arial")))));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: color,
                                content: Container(
                                    height: 20,
                                    alignment: Alignment.center,
                                    child: const Text('Error al editar',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Arial")))));
                          }
                          limpiarvariableslocales();
                          MenuState.tabController.animateTo(0);
                        }
                      }
                    },
                    icon: edicion == false
                        ? const Icon(Icons.note_add)
                        : const Icon(Icons.note_alt),
                    label: edicion == false
                        ? const Text('Guardar')
                        : const Text('Editar')),
              ],
            )
          ])),
    );
  }
}
