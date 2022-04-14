import 'package:notas_flutter/data/basedatos.dart';
import 'package:notas_flutter/model/note.dart';

class NoteService {
  NoteService();

  final basedato = BaseDato();
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
