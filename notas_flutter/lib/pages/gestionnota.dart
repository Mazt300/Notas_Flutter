import 'package:flutter/material.dart';
import 'package:notas_flutter/data/basedatos.dart';
import 'package:notas_flutter/modelo/nota.dart';
import 'package:notas_flutter/modelo/note.dart';

class Gestionarnota extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();

  final _titulo = TextEditingController();
  final _contenido = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
          key: _formkey,
          child: Column(children: [
            TextFormField(
              controller: _titulo,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingrese información al contenido";
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
                      if (_formkey.currentState?.validate() != null) {
                        // String texto =
                        //     'Se procesa ${_titulo.text} y tambien ${_contenido.text}';
                        // ScaffoldMessenger.of(context)
                        //     .showSnackBar(SnackBar(content: Text(texto)));
                        Note nota = Note(
                            titulo: _titulo.text,
                            contenido: _contenido.text,
                            fecha: DateTime.now().toString(),
                            estado: true);
                        int result = await BaseDato.insert(nota);
                        if (result > 0) {
                          const SnackBar(content: Text('Guardado con exito'));
                        } else {
                          const SnackBar(content: Text('Error al guardar'));
                        }
                      }
                    },
                    icon: const Icon(Icons.note_add),
                    label: const Text('Guardar')),
              ],
            )
          ])),
    );
  }
}
