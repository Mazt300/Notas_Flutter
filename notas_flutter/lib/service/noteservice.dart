import 'package:notas_flutter/route/routingdata.dart';

//Clase de la capa servicio
class NoteService {
  //constructor vacio
  NoteService();

  //basedato variable que es instaciada del tipo BaseDato para poder acceder a sus metodos
  final basedato = BaseDato();

  //Future se utiliza siempre que tenemos metodos async await
  Future<int> insertNote(Note nota) async {
    return await basedato.insert(nota);
  }

  Future<int> updateNote(Note nota) async {
    return await basedato.update(nota);
  }

  Future<List<Note>> getNotes() async {
    return await basedato.obtenerNotas();
  }
}
