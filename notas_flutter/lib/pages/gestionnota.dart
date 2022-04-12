import 'package:flutter/material.dart';
import 'package:notas_flutter/modelo/nota.dart';

class Gestionnota extends StatefulWidget {
  const Gestionnota({Key? key}) : super(key: key);
  @override
  State<Gestionnota> createState() => _GestionnotaState();
}

Nota _enviarnota(Nota nota) {
  final Nota _nota = nota;

  return _nota;
}

class _GestionnotaState extends State<Gestionnota> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text('TITULO'),
        Divider(),
        SizedBox(
          width: 200,
          child: TextField(),
        ),
        Divider(),
        Text('CUERPO'),
        Divider(),
        SizedBox(
          width: 200,
          child: TextField(),
        ),
      ],
    );
  }
}
