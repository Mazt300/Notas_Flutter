import 'package:flutter/material.dart';

class OrdenamientoNota extends StatefulWidget {
  const OrdenamientoNota({Key? key}) : super(key: key);

  @override
  State<OrdenamientoNota> createState() => _OrdenamientoNotaState();
}

class _OrdenamientoNotaState extends State<OrdenamientoNota> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            Row(
              children: const [
                SizedBox(
                  height: 20,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
