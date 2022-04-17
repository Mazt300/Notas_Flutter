import 'package:flutter/material.dart';
import 'package:notas_flutter/route/routingdata.dart';
import 'package:notas_flutter/route/routing.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key, required this.titulo}) : super(key: key);
  //parametro del constructor que establece el nombre que la appbar tendra por titulo
  final String titulo;
  @override
  State<Menu> createState() => MenuState();
}

class MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  //tabController variable controlador para el componente TabBar y sus childs
  //con esta variable validamos si estamos creando o editando algun registro ademas orienta el cambio de tabs
  static late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      //si el tab cambia a 0 entonces ponemos todo lo que esta en gestionnota como nuevo
      if (tabController.index != 1) {
        GestionarNotaState.validarNota(Note.empty());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    //valor default del controllador
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //En este caso decidi dejar la page en el metodo build ya que es pequeña y solamente contiene el TabBar y el llamado a las page contenidas
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.titulo),
        backgroundColor: const Color.fromARGB(255, 163, 64, 255),
        bottom: TabBar(
          //definicion de los tabs y sus componentes
          controller: tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.list),
              text: 'Lista de notas',
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
                child: ListView(
                  children: const [GestionarNota()],
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
