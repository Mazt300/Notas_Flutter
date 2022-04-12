class Nota {
  Nota({
    required this.titulo,
    required this.contenido,
    this.expandido = false,
  });

  String titulo;
  String contenido;
  bool expandido;
}

List<Nota> generarLista(int cantidad) {
  // final games = ["Lista de notas", "Buscar notas", "CRUD notas"];
  return List<Nota>.generate(cantidad, (index) {
    return Nota(
        titulo: 'Nota $index',
        contenido:
            'Esta nota la escribimos y asignamos el número $index para esta nota');
  });
}
