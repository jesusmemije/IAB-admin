import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invitacionaboda_admin/models/guest_model.dart';
import 'package:invitacionaboda_admin/providers/guests_provider.dart';
import 'package:invitacionaboda_admin/providers/type_guest_provider.dart';
import 'package:invitacionaboda_admin/shared_prefs/user_preferences.dart';

class EditGuestScreen extends StatefulWidget {
  const EditGuestScreen({ Key? key }) : super(key: key);

  @override
  _EditGuestScreenState createState() => _EditGuestScreenState();
}

class _EditGuestScreenState extends State<EditGuestScreen> {

  // Global Keys
  final formKey     = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final prefs = PreferenciasUsuario();

  // Variables de control
  bool _guardando = false;

  // Provider
  final typeGuestProvider = TypeGuestProvider();
  final guestsProvider = GuestsProvider();

  GuestModel guestModel = GuestModel(idInvitado: 0 );

  @override
  Widget build(BuildContext context) {

    guestModel = ModalRoute.of(context)!.settings.arguments as GuestModel;

    return Scaffold(
      appBar: _crearAppBar( context ),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formKey,
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  _textApodo(),
                  const SizedBox(height: 10.0),
                  _textNombre(),
                  const SizedBox(height: 10.0),
                  _textApellidoPaterno(),
                  const SizedBox(height: 10.0),
                  _textApellidoMaterno(),
                  const SizedBox(height: 10.0),
                  _textMesa(),
                  const SizedBox(height: 10.0),
                  _textNumBoletos(),
                  const SizedBox(height: 20.0),
                  _buttomSave()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textApodo() {
    return TextFormField(
      initialValue: guestModel.apodo,
      textCapitalization: TextCapitalization.sentences,
      autofocus: false,
      maxLines: 1,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Apodo',
        isDense: true,
      ),
      onSaved: (value) => guestModel.apodo = value.toString(),
      validator: ( value ){
        if( value!.isEmpty ){
          return "Ingresa el apodo";
        } else {
          return null;
        }
      },
    );
  }

  Widget _textNombre() {
    return TextFormField(
      initialValue: guestModel.nombre,
      textCapitalization: TextCapitalization.sentences,
      autofocus: false,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Nombre',
        isDense: true,
      ),
      onSaved: (value) => guestModel.nombre = value.toString(),
      validator: ( value ){
        if( value!.isEmpty ){
          return "Ingresa el nombre";
        } else {
          return null;
        }
      },
    );
  }

  Widget _textApellidoPaterno() {
    return TextFormField(
      initialValue: guestModel.aPaterno,
      textCapitalization: TextCapitalization.sentences,
      autofocus: false,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Apellido paterno',
        isDense: true,
      ),
      onSaved: (value) => guestModel.aPaterno = value.toString(),
      validator: ( value ){
        if( value!.isEmpty ){
          return "Ingresa el apellido paterno";
        } else {
          return null;
        }
      },
    );
  }

  Widget _textApellidoMaterno() {
    return TextFormField(
      initialValue: guestModel.aMaterno,
      textCapitalization: TextCapitalization.sentences,
      autofocus: false,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Apellido materno',
        isDense: true,
      ),
      onSaved: (value) => guestModel.aMaterno = value.toString(),
      validator: ( value ){
        if( value!.isEmpty ){
          return "Ingresa el apellido materno";
        } else {
          return null;
        }
      },
    );
  }

  Widget _textMesa() {
    return TextFormField(
      initialValue: guestModel.mesa.toString(),
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.sentences,
      autofocus: false,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Número de mesa',
        isDense: true,
      ),
      onSaved: (value) => guestModel.mesa = int.parse(value!),
      validator: ( value ){
        if( value!.isEmpty ){
          return "Ingrese el número de la mesa";
        } else {
          return null;
        }
      },
    );
  }

  Widget _textNumBoletos() {
    return TextFormField(
      initialValue: guestModel.boletos.toString(),
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.sentences,
      autofocus: false,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Número de boletos',
        isDense: true,
      ),
      onSaved: (value) => guestModel.boletos = int.parse(value!),
      validator: ( value ){
        if( value!.isEmpty ){
          return "Ingrese el número de boletos";
        } else {
          return null;
        }
      },
    );
  }

  PreferredSize _crearAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ), 
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              'Editar invitado',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
            )
          ],
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buttomSave(){

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded (
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label:  const Text('Editar'),
            onPressed: ( _guardando ) ? null : _saveForm,
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )
            ),
          ),
        ),
      ],
    );
  }

  void _saveForm() {

    var form = formKey.currentState;
    if ( !form!.validate() ) return; 
    //Código cuando el formulario es válido...
    form.save();

    setState(() { _guardando = true; });

    final response = guestsProvider.editGuest(guestModel);

    response.then((value){
      if( value ){
        mostrarSnackbar("Invitado actualizado con éxito");
      } else {
        mostrarSnackbar("Hemos tenido un problema al actualizar al invitado");
      }

      setState(() { _guardando = false; });

    });
    
  }

  void mostrarSnackbar( String mensaje ) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text( mensaje ),
          duration: const Duration( milliseconds: 3500 ),
        ),
      );

  }

}