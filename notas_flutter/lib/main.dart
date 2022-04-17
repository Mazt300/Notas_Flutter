import 'package:flutter/material.dart';
import 'package:notas_flutter/route/routing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas de usaurio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //llamado a la page principal
      home: const Menu(titulo: "Prueba técnica final"),
    );
  }
}
