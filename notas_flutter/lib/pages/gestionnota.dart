import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notas_flutter/data/basedatos.dart';
import 'package:notas_flutter/modelo/note.dart';
import 'package:notas_flutter/pages/listanotausuario.dart';

class Gestionarnota extends StatelessWidget {
  Gestionarnota({Key? key}) : super(key: key);
  final _formkey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _contenido = TextEditingController();

  static Note noteactualizar = Note.empty();

  static void validarNota(Note note) {
    noteactualizar = note;
  }

  void limpiarCampos() {
    _titulo.text = "";
    _contenido.text = "";
  }

  @override
  Widget build(BuildContext context) {
    if (noteactualizar.id != null) {
      _titulo.text = noteactualizar.titulo;
      _contenido.text = noteactualizar.contenido;
    } else {
      limpiarCampos();
    }
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
          key: _formkey,
          child: Column(children: [
            TextFormField(
              controller: _titulo,
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
              controller: _contenido,
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
                              titulo: _titulo.text,
                              contenido: _contenido.text,
                              fecha: DateFormat.yMMMd().format(DateTime.now()),
                              estado: true);
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
                          limpiarCampos();
                          MenuState.tabController.index = 0;
                        } else {
                          noteactualizar.titulo = _titulo.text;
                          noteactualizar.contenido = _contenido.text;
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
                          limpiarCampos();
                          MenuState.tabController.index = 0;
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
}
