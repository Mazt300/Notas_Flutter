import 'package:flutter/material.dart';
import 'package:notas_flutter/route/routing.dart';

class Menu extends StatefulWidget {
  Menu({Key? key, required this.titulo}) : super(key: key);
  final String titulo;
  @override
  State<Menu> createState() => MenuState();
  int indiceseleccionado = 0;
}

class MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  static late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  cambiotab(int index) {
    if (tabController.index != index) {
      tabController.animateTo(index);
    }
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
                  children: [Gestionarnota()],
                ),
              ),
            ],
          )),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.navigate_next),
      //   onPressed: () {
      //     if (widget.indiceseleccionado == tabController.index) {
      //       widget.indiceseleccionado += 1;
      //     }
      //     if (widget.indiceseleccionado > 2) {
      //       widget.indiceseleccionado = 0;
      //     }
      //     tabController.animateTo(widget.indiceseleccionado);
      //   },
      // ),
      // ...games
      //               .map((item) => ElevatedButton.icon(
      //                   icon: const Icon(Icons.arrow_right),
      //                   onPressed: () {},
      //                   label: Text(item)))
      //               .toList(),

      // ListView.separated(
      //       itemBuilder: (context, index) => ElevatedButton.icon(
      //           onPressed: () {},
      //           icon: const Icon(Icons.arrow_right_alt_outlined),
      //           label: Text(games[index])),
      //       separatorBuilder: (_, __) => const Divider(),
      //       itemCount: games.length),

      // Container(
      //       width: dimension.width,
      //       height: dimension.height * 0.5,
      //       margin: const EdgeInsets.all(16.0),
      //       child: ListView(
      //         padding: const EdgeInsets.all(10.0),
      //         children: <Widget>[
      //           ...games.map((e) => ElevatedButton.icon(
      //                 onPressed: () {},
      //                 icon: const Icon(Icons.arrow_forward_ios),
      //                 label: Text(
      //                   e,
      //                   textAlign: TextAlign.center,
      //                 ),
      //                 style: ElevatedButton.styleFrom(
      //                   alignment: Alignment.centerLeft,
      //                 ),
      //               ))
      //         ],
      //       )),
    );
  }
}
