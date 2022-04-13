import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notas_flutter/data/basedatos.dart';
import 'package:notas_flutter/modelo/note.dart';
import 'package:notas_flutter/pages/listanotausuario.dart';

class GestionarNota extends StatefulWidget {
  const GestionarNota({Key? key}) : super(key: key);

  @override
  State<GestionarNota> createState() => GestionarNotaState();
}

class GestionarNotaState extends State<GestionarNota> {
  final _formkey = GlobalKey<FormState>();
  static final titulo = TextEditingController();
  static final contenido = TextEditingController();

  static Note noteactualizar = Note.empty();
  static bool edicion = false;
  DateTime? _fechaSeleccionada;

  static void validarNota(Note note) {
    noteactualizar = note;
    if (note.id != null) {
      titulo.text = noteactualizar.titulo;
      contenido.text = noteactualizar.contenido;
      edicion = true;
    } else {
      limpiar();
    }
  }

  static void limpiar() {
    titulo.text = "";
    contenido.text = "";
    edicion = false;
  }

  void _cargarDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((fechaseleccionada) {
      if (fechaseleccionada == null) {
        _fechaSeleccionada = DateTime.now();
      }
      setState(() {
        _fechaSeleccionada = fechaseleccionada;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
          key: _formkey,
          child: Column(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: _cargarDatePicker,
                    icon: const Icon(Icons.date_range_outlined),
                    label: const Text('Seleccionar fecha'))
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
                          Note nota = Note(
                              titulo: titulo.text,
                              contenido: contenido.text,
                              fecha: _fechaSeleccionada != null
                                  ? DateFormat.yMd().format(_fechaSeleccionada!)
                                  : DateFormat.yMd().format(DateTime.now()),
                              estado: 1);
                          int result = await BaseDato.insert(nota);
                          if (result > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Guardado con exito')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error al guardar')));
                          }
                          limpiar();
                          MenuState.tabController.animateTo(0);
                        } else {
                          noteactualizar.titulo = titulo.text;
                          noteactualizar.contenido = contenido.text;
                          int result = await BaseDato.update(noteactualizar);
                          if (result > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Editado correctamente')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error al editar')));
                          }
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

/*class GestionarNota extends StatelessWidget {
  GestionarNota({Key? key}) : super(key: key);

  final _formkey = GlobalKey<FormState>();
  static final titulo = TextEditingController();
  static final contenido = TextEditingController();

  static Note noteactualizar = Note.empty();

  static void validarNota(Note note) {
    noteactualizar = note;
    if (note.id != null) {
      titulo.text = noteactualizar.titulo;
      contenido.text = noteactualizar.contenido;
    } else {
      limpiar();
    }
  }

  static void limpiar() {
    titulo.text = "";
    contenido.text = "";
  }

  void cargarDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((fechaseleccionada) => {if (fechaseleccionada == null) {}});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
          key: _formkey,
          child: Column(children: [
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
                          Note nota = Note(
                              titulo: titulo.text,
                              contenido: contenido.text,
                              fecha: DateFormat.yMd().format(DateTime.now()),
                              estado: 1);
                          int result = await BaseDato.insert(nota);
                          if (result > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Guardado con exito')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error al guardar')));
                          }
                          limpiar();
                          MenuState.tabController.animateTo(0);
                        } else {
                          noteactualizar.titulo = titulo.text;
                          noteactualizar.contenido = contenido.text;
                          int result = await BaseDato.update(noteactualizar);
                          if (result > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Editado correctamente')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error al editar')));
                          }
                          MenuState.tabController.animateTo(0);
                        }
                      }
                    },
                    icon: noteactualizar.id == null
                        ? const Icon(Icons.note_add)
                        : const Icon(Icons.note_alt),
                    label: noteactualizar.id == null
                        ? const Text('Guardar')
                        : const Text('Editar')),
              ],
            )
          ])),
    );
  }
}*/
