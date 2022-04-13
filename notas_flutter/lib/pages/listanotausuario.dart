import 'package:flutter/material.dart';
import 'package:notas_flutter/modelo/note.dart';
import 'package:notas_flutter/route/routing.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key, required this.titulo}) : super(key: key);
  final String titulo;
  @override
  State<Menu> createState() => MenuState();
}

class MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  static late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (tabController.index != 2) {
        GestionarNota.validarNota(Note.empty());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.titulo),
        backgroundColor: const Color.fromARGB(255, 163, 64, 255),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.list),
              text: 'Lista de notas',
            ),
            Tab(
              icon: Icon(Icons.search),
              text: 'Buscar notas',
            ),
            Tab(
              icon: Icon(Icons.app_registration),
              text: 'Gestionar notas',
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: TabBarView(
            controller: tabController,
            children: <Widget>[
              Center(
                child: ListView(
                  children: const [ListaGeneral()],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Hombres trabajando"),
                    Icon(Icons.build_circle)
                  ],
                ),
              ),
              Center(
                child: ListView(
                  children: [GestionarNota()],
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
