import 'package:notas_flutter/modelo/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BaseDato {
  static Future<Database> _abrirBD() async {
    //funcion para abrir o crear una base de datos
    return openDatabase(
      //Join concatena X cadenas en este caso estamos concatenando el path de la BD con el nombre que se le asigna
      join(await getDatabasesPath(), 'notas.db'),
      onCreate: (db, version) {
        //Creamos una funcion que realice la creacion de tabla y la especificacion de version para esa tabla
        return db.execute(
            "Create Table Nota (id INTEGER PRIMARY KEY, titulo TEXT, contenido TEXT, fecha TEXT, estado BIT)");
      },
      version: 1,
    );
  }

  static Future<int> insert(Note nota) async {
    //inicializamos la BD
    Database database = await _abrirBD();

    //Retornamos la consulta local
    return database.insert('Nota', nota.toMap());
  }

  static Future<List<Note>> obtenerNotas() async {
    Database database = await _abrirBD();

    final List<Map<String, dynamic>> notamap =
        await database.query('Nota', where: "estado == 1");
    //Retornamos la consulta generando una lista con lo optenido de la consulta
    return List.generate(
        notamap.length,
        (i) => Note(
            id: notamap[i]['id'],
            titulo: notamap[i]['titulo'],
            contenido: notamap[i]['contenido'],
            fecha: notamap[i]['fecha'],
            //convertimos un valor bit almacenado a bool para cargar en la vista
            estado: notamap[i]['estado'] == 0 ? false : true));
  }

  static Future<int> update(Note nota) async {
    Database database = await _abrirBD();

    return database
        .update('Nota', nota.toMap(), where: 'id = ?', whereArgs: [nota.id]);
  }

  static Future<int> delete(Note nota) async {
    Database database = await _abrirBD();

    return database
        .update("Nota", nota.toMap(), where: 'id = ?', whereArgs: [nota.id]);
  }
}
