import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notas_flutter/route/routingdata.dart';
import 'package:notas_flutter/route/routing.dart';
import 'package:notas_flutter/route/routingservice.dart';

class GestionarNota extends StatefulWidget {
  const GestionarNota({Key? key}) : super(key: key);

  @override
  State<GestionarNota> createState() => GestionarNotaState();
}

class GestionarNotaState extends State<GestionarNota> {
  //Variables a utilizar
  // --------------
  //_formkey variable utilizada para monitorear los formularios que tengan este controlador
  final _formkey = GlobalKey<FormState>();
  //titulocontroller y contenidocontroller son variables que nos permiten obtener el texto del widget que controlan
  static final titulocontroller = TextEditingController();
  static final contenidocontroller = TextEditingController();
  //color variable que define el color a usar en cualquier componente deseado
  final color = const Color.fromARGB(255, 163, 64, 255);
  //service variable para acceder a la capa servicio y consultar a la bd
  final service = NoteService();
  //noteactualizar variable escencial para la gestion de la informacion
  //Note.empty() es un metodo para inicializar la variable vacia
  static Note noteactualizar = Note.empty();
  //edicion permite darnos cuenta si vamos a crear o a modificar decidi dejarlo con esta variable ya que la utilizo mas adelante
  static bool edicion = false;
  //_fechaSeleccionada variable que manipulara las fechas de la nota o las del widget e ilustrara en un formato especifico
  static String _fechaSeleccionada = "";
  //_formatofecha formato de fecha designado
  final String _formatofecha = "dd-MM-yyyy";
  //_fechaRegistro variable que almacenara las fechas convertidas en el formato DATETIME para pasarselo a la clase NOTE
  late DateTime _fechaRegistro;

  //validarNota estatico que nos permite obtener la data especifica o nula si estamos creando una nota
  static validarNota(Note note) {
    noteactualizar = note;
    if (noteactualizar.id != null) {
      titulocontroller.text = noteactualizar.titulo;
      contenidocontroller.text = noteactualizar.contenido;
      edicion = true;
    } else {
      titulocontroller.text = "";
      contenidocontroller.text = "";
      edicion = false;
    }
  }

//initState metodo que se ejecuta en cuanto se inicaliza un estado
  @override
  void initState() {
    //validamos si estamos cargando una nota existente o una nula y designamos las fechas ya guardadas o limpiamos si es nota nueva
    if (noteactualizar.id != null) {
      setState(() {
        _fechaSeleccionada =
            DateFormat('dd-MM-yyyy').format(noteactualizar.fecha);
        _fechaRegistro = noteactualizar.fecha;
      });
    } else {
      limpiarvariableslocales();
    }
    super.initState();
  }

  //_cargarDatePicker metodo que nos permite solicitar una fecha especifica al usuario con el widget DatePicker
  void cargarDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((fechaseleccionada) {
      setState(() {
        //modificamos los valores de las variables involucradas en el manejo de las fechas
        if (fechaseleccionada == null || noteactualizar.id == null) {
          _fechaSeleccionada = DateFormat(_formatofecha).format(DateTime.now());
        }
        _fechaSeleccionada =
            DateFormat(_formatofecha).format(fechaseleccionada!);
        _fechaRegistro = fechaseleccionada;
      });
    });
  }

  //actualizamos los valores una vez se halla usado el recurso
  limpiarvariableslocales() {
    setState(() {
      _fechaSeleccionada = "";
      _fechaRegistro = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    //cargamos la page diseñada
    return vistaprincial();
  }

  //contiene la lista de componentes de toda la vista
  //utilizamos paddin porque montamos una vista dentro de un componete scaffold normal excede el contenedor del widget padre
  Widget vistaprincial() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
          key: _formkey,
          child: Column(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      cargarDatePicker();
                    },
                    icon: const Icon(Icons.date_range_outlined),
                    label: const Text('Seleccionar fecha')),
                _fechaSeleccionada == ""
                    ? const Text('')
                    : Text(_fechaSeleccionada)
              ],
            ),
            TextFormField(
              controller: titulocontroller,
              //creamos validaciones para los widget de texto input
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingrese información al titulo";
                }
                return null;
              },
              decoration: const InputDecoration(
                  hintText: "Titulo", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: contenidocontroller,
              //creamos validaciones para los widget de texto input
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingrese información al contenido";
                }
                return null;
              },
              maxLines: 15,
              maxLength: 200,
              decoration: const InputDecoration(
                  hintText: "Contenido", border: OutlineInputBorder()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: () => gestionnota(),
                    //evaluamos si estamos editando o no para mostrar las diferentes opciones
                    icon: edicion == false
                        ? const Icon(Icons.note_add)
                        : const Icon(Icons.note_alt),
                    label: edicion == false
                        ? const Text('Guardar')
                        : const Text('Editar')),
              ],
            )
          ])),
    );
  }

  gestionnota() async {
    //validamos que _formkey controlador de formulario revise las validaciones a los widget que establecimos
    if (_formkey.currentState!.validate()) {
      //validamos si nuestra nota fue cargada o no y tomamos la decision de ejecutar creacion o edicion
      if (noteactualizar.id == null && edicion == false) {
        //creamos la nota con los controladores de texto y la variable de fecha
        noteactualizar = Note(
            titulo: titulocontroller.text,
            contenido: contenidocontroller.text,
            fecha: _fechaRegistro,
            estado: 1);
        //hacemos el consumo al servicio y esperamos un resultado
        int result = await service.insertNote(noteactualizar);
        if (result > 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: color,
              content: Container(
                height: 20,
                alignment: Alignment.center,
                child: const Text('Guardado con exito',
                    style: TextStyle(fontSize: 20, fontFamily: "Arial")),
              )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: color,
              content: Container(
                  height: 20,
                  alignment: Alignment.center,
                  child: const Text('Error al guardar',
                      style: TextStyle(fontSize: 20, fontFamily: "Arial")))));
        }
        limpiarvariableslocales();
        //volvemos a la lista de notas para actualizarla
        MenuState.tabController.animateTo(0);
      } else {
        noteactualizar.titulo = titulocontroller.text;
        noteactualizar.contenido = contenidocontroller.text;
        noteactualizar.fecha = _fechaRegistro;
        //hacemos el consumo del servicio en actualizacion y esperamos una respuesta
        int result = await service.updateNote(noteactualizar);
        if (result > 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: color,
              content: Container(
                  height: 20,
                  alignment: Alignment.center,
                  child: const Text('Editado correctamente',
                      style: TextStyle(fontSize: 20, fontFamily: "Arial")))));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: color,
              content: Container(
                  height: 20,
                  alignment: Alignment.center,
                  child: const Text('Error al editar',
                      style: TextStyle(fontSize: 20, fontFamily: "Arial")))));
        }
        limpiarvariableslocales();
        //volvemos a la lista de notas para actualizarla
        MenuState.tabController.animateTo(0);
      }
    }
  }
}
