import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notas_flutter/model/note.dart';
import 'package:notas_flutter/route/routing.dart';
import 'package:notas_flutter/service/noteservice.dart';

class ListaGeneral extends StatefulWidget {
  const ListaGeneral({
    Key? key,
  }) : super(key: key);
  @override
  State<ListaGeneral> createState() => _ListaGeneralState();
}

class _ListaGeneralState extends State<ListaGeneral> {
  //declaramos las variables necesarias
  //------
  //_busqueda variable controlladora de widget nos permite obtener el texto del widget de entrada
  final _busqueda = TextEditingController();
  //service variable para acceder a la capa servicio y consultar a la bd
  final service = NoteService();
  //_nota,_notaTemp listas de tipo Note que es la clase modelo para estructurar los datos
  List<Note> _nota = [], _notatemp = [];
  // expansion variable que identifica si se usa ordenamiento en la lista de notas
  bool expansion = false;
  //ordenamiento lista de strings que almacena los tipos de ordenamientos
  final List<String> ordenamiento = ["Titulo", "Contenido", "Fecha"];
  //_formatofecha variable string que define como se muestra la fecha en la aplicacion
  final String _formatofecha = "dd-MM-yyyy";
  //opcionordenamiento esta variable string es usada para identificar que tipo de ordenamiento desea ver el usuario
  String opcionordenamiento = "";

  @override
  void initState() {
    //_cargarnotas metodo que revisa o actualiza la lista de notas grabadas en la bd
    _cargarnotas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _vistaprincipal();
  }

  Widget _vistaprincipal() {
    //utilizamos el widget Padding ya que cargamos las page en un TabBarView eso delimita la forma de la page
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Ordenar por: ',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          //Este metodo define el principio del uso con ordenamientos
                          modificarfiltro(!expansion);
                        },
                        icon: const Icon(Icons.filter_alt_outlined),
                        label: const Text(''),
                      ),
                    ],
                  ),
                  //Widget que nos permite mostrar u ocultar cualquier child widget parametrizado con la variable expansion
                  Visibility(
                      visible: expansion,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: ordenamiento
                                .map<Container>((e) => Container(
                                    padding: const EdgeInsets.all(5),
                                    child: ElevatedButton(
                                      child: Text(e.toString()),
                                      onPressed: () {
                                        //la lista de opciones esta cargada con la lista ordenamiento y sus valores son los parametros para el metodo que evaluara y ordenara
                                        _ordenarnotas(e);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0))),
                                    )))
                                .toList(),
                          ),
                        ],
                      ))
                ],
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  const Text(
                    "Buscar: ",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  //Widget que permite acomodar o ajustar en una fila los widgets child
                  Flexible(
                      child: TextFormField(
                    controller: _busqueda,
                    decoration: const InputDecoration(
                      hintText: "por título o contenido",
                    ),
                    //funcion que envia el texto escrito en el widget... dicha opcion onChanged envia automaticamente el parametro string de la cadena escrita
                    onChanged: _buscarnotas,
                  )),
                ],
              ),
              const Divider(),
              Column(
                children: <Widget>[
                  SingleChildScrollView(
                    child: _nota.isEmpty
                        //Evaluamos si la lista de notas esta vacia o no si lo esta informamos que no existen registros
                        ? const Text('Sin Registros',
                            style: TextStyle(fontSize: 24))
                        : _tarjetaDeNota(),
                  )
                ],
              )
            ],
          ),
        ));
  }

//_tarjetaDeNota metodo que dibuja un widget por cada elemento de nota llamado expansionpanellist
  Widget _tarjetaDeNota() {
    return ExpansionPanelList(
      //expansionCallback metodo que esta atengo de la iteracion con el expansionpanel el cual ejecuta si la nota muestra detalles o no
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _nota[index].expandido = !isExpanded;
        });
      },
      //Se define una lista mapeada para el widget child cargada de la data que contiene _nota
      children: _nota.map<ExpansionPanel>(
        (Note nota) {
          return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(nota.titulo),
                );
              },
              body: _tarjetaDetalleNota(nota),
              isExpanded: nota.expandido);
        },
      ).toList(),
    );
  }

  //metodo que dibuja y carga los detalles de las notas cuando se iteractua con el callback padre
  Widget _tarjetaDetalleNota(Note nota) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.note),
              title: Text("Contenido: ${nota.contenido}"),
              subtitle: Text(
                  //se define un formato 01-01-1999 por ejemplo para mejor ilustracion del usuario con la fecha de la nota
                  //utilizamos la variable _formatofecha para su configuracion
                  "Fecha: ${DateFormat(_formatofecha).format(nota.fecha)}"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      //accedemos a un metodo statico de la clase GestionarNotaState para enviar la informacion de la nota seleccionada
                      GestionarNotaState.validarNota(nota);
                      //cambiamos de forma controlada al tab 1 donde esta cargada la data
                      MenuState.tabController.animateTo(1);
                    },
                    icon: const Icon(Icons.edit_calendar_outlined),
                    label: const Text('Editar')),
                const SizedBox(
                  width: 5,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

//Metodo que no retornara nada porque la variable ya esta declarada de manera global para poder iterar en ella y cargar las consultas
//Ademas se utiliza una variable temporal para hacer el await de la consulta y hacer una iteracion de estado para mantener actualizada la consulta
  _cargarnotas() async {
    List<Note> tempNote = await service.getNotes();
    _nota.clear();
    _notatemp.clear();
    setState(() {
      _nota = tempNote;
    });
    //cargamos la data a _notatemp para usarla de respaldo en metodos de ordenamiento y/o busqueda
    _notatemp = _nota;
  }

  modificarfiltro(bool estado) {
    //indicamos si vamos a usar ordenamiento o no
    setState(() {
      expansion = estado;
    });
    if (expansion == false) {
      _ordenarnotas("");
    }
  }

  //el metodo recibe el string de busqueda e identifica similitudes en titulo y contenido
  void _buscarnotas(String palabra) {
    //usamos una lista temporal creada en el metodo ya que solo sera para buscar las palabras
    List<Note> _auxnote = _notatemp;

    if (palabra.isNotEmpty) {
      //
      final listanotabusquedatitulo = _auxnote.where((x) {
        final titulo = x.titulo.toLowerCase();
        final busqueda = palabra.toLowerCase();

        return titulo.contains(busqueda);
      }).toList();

      final listanotabusquedacontenido = _auxnote.where((x) {
        final contenido = x.contenido.toLowerCase();
        final busqueda = palabra.toLowerCase();

        return contenido.contains(busqueda);
      }).toList();

      setState(() {
        if (listanotabusquedatitulo.isNotEmpty) {
          _nota = listanotabusquedatitulo;
        } else if (listanotabusquedacontenido.isNotEmpty) {
          _nota = listanotabusquedacontenido;
        } else {
          List<Note> listavacia = [];
          _nota = listavacia;
        }
      });
    } else {
      //si no se esta buscando nada o el usuario dicidio eliminar todo el texto de la busqueda
      //suceden 2 cosas 1- todos los elementos contenidos en _notatemp van a ser no expandidos
      // ya que la actualizacion de estados presento un fallo el cual me gustaria conversalo en alguna ocasion
      //2- necesitamos evaluar si el ordenamiento esta activo y dependiendo del ultimo ordenamiento la variable opcionordenamiento
      // indicara como mostrarlo
      setState(() {
        for (var element in _notatemp) {
          element.expandido = false;
        }
        if (expansion == true) {
          _nota = _notatemp;
          _ordenarnotas(opcionordenamiento);
        } else {
          _nota = _notatemp;
        }
      });
    }
  }

//_ordenarnotas metodo de ordenamiento segun el usuario
//el parametro opcion define como debe ordenarse la lista de notas
//opcionordenamiento aqui juega el papel de resguardar el valor antes recibido por si la busqueda se cancela se mantiene el ordenamiento
  void _ordenarnotas(String opcion) {
    opcionordenamiento = opcion;
    setState(() {
      switch (opcion) {
        case "Titulo":
          _nota.sort((a, b) => a.titulo.compareTo(b.titulo));
          break;
        case "Contenido":
          _nota.sort((a, b) => a.contenido.compareTo(b.contenido));
          break;
        case "Fecha":
          _nota.sort((a, b) => a.fecha.compareTo(b.fecha));
          break;
        case "":
          //evaluamos si el usuario dejo de usar ordenamiento pero no si aun esta buscando alguna palabra clave
          if (expansion == false && _busqueda.text != "") {
            _buscarnotas(_busqueda.text);
          } else {
            //sino es asi entonces ponemos en false el atributo expandido de todos los elemento
            //y actualizamos la lista principal con los valores de la lista auxiliar
            for (var element in _notatemp) {
              element.expandido = false;
            }
            _nota = _notatemp;
          }
          break;
        default:
          break;
      }
    });
  }
}
