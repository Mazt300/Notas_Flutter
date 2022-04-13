class Note {
  late int? id;
  late String titulo;
  late String contenido;
  late String fecha;
  late bool estado;
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
    fecha = "";
    estado = false;
    expandido = false;
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'contenido': contenido,
      'fecha': fecha,
      'estado': estado
    };
  }
}
