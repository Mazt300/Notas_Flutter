import 'package:flutter/material.dart';
import 'package:notas_flutter/route/routing.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key, required this.titulo}) : super(key: key);
  final String titulo;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    // TODO: implement dispose
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
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Lista de notas',
              ),
              Tab(
                text: 'Buscar notas',
              ),
              Tab(
                text: 'Gestionar notas',
              )
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: const <Widget>[
                  Center(
                    child: ListaGeneral(),
                  ),
                  Center(
                    child: Text("It's rainy here"),
                  ),
                  Center(
                    child: Text("It's sunny here"),
                  ),
                ]))
          ],
        )
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
