//Clase modelo
class Note {
  late int? id;
  late String titulo;
  late String contenido;
  late DateTime fecha;
  late int estado;
  late bool expandido = false;
  //constructor que exige todos los valores excepto id ya que necesitamos el metodo empty
  Note(
      {this.id,
      required this.titulo,
      required this.contenido,
      required this.fecha,
      required this.estado});

  //metodo que devuelve una nota vacia para validaciones
  Note.empty() {
    id = null;
    titulo = "";
    contenido = "";
    fecha = DateTime.now();
    estado = 0;
    expandido = false;
  }
  //devuelve un mapa estructurado como String y dynamic(cualquier valor)
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
