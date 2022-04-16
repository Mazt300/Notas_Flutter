class Note {
  late int? id;
  late String titulo;
  late String contenido;
  late DateTime fecha;
  late int estado;
  late bool expandido = false;

  Note(
      {this.id,
      required this.titulo,
      required this.contenido,
      required this.fecha,
      required this.estado});
  Note.empty() {
    id = null;
    titulo = "";
    contenido = "";
    fecha = DateTime.now();
    estado = 0;
    expandido = false;
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'contenido': contenido,
      'fecha': fecha.toString(),
      'estado': estado
    };
  }
}
