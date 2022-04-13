class Note {
  final int? id;
  final String titulo;
  final String contenido;
  final String fecha;
  final bool estado;
  late bool expandido = false;

  Note(
      {this.id,
      required this.titulo,
      required this.contenido,
      required this.fecha,
      required this.estado});

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
