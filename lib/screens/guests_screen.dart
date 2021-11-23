import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invitacionaboda_admin/models/guest_model.dart';
import 'package:invitacionaboda_admin/providers/guests_provider.dart';
import 'package:invitacionaboda_admin/search/guest_search.dart';
import 'package:invitacionaboda_admin/shared_prefs/user_preferences.dart';

class GuestsScreen extends StatefulWidget {
  const GuestsScreen({Key? key}) : super(key: key);

  @override
  State<GuestsScreen> createState() => _GuestsScreenState();
}

class _GuestsScreenState extends State<GuestsScreen> {
  final guestsProvider = GuestsProvider();

  final prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _crearAppBar( context ),
      body: _crearListado()
    );
  }

  Widget _crearListado() {

    return FutureBuilder(
      future: guestsProvider.getGuests( prefs.idNovios ),
      builder: (BuildContext context, AsyncSnapshot<List<GuestModel>> snapshot) {

        final guests = snapshot.data;

        if (snapshot.hasData) {
          if ( guests!.isNotEmpty ) {
            return Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
              child: ListView.builder(
                itemCount: guests.length,
                itemBuilder: (context, i) => _crearItemGuest( context, guests[i], i),
              ),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.sentiment_very_dissatisfied,
                      size: 40.0,
                    ),
                    SizedBox(height: 8.0),
                    Text( 'No se encontró ningún invitado', textAlign: TextAlign.center),
                  ],
                ),
              ],
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItemGuest( BuildContext context, GuestModel guest, int index) {

    index = index + 1;

    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
      child: Container(
        color: Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
          leading: CircleAvatar(
            foregroundColor: Colors.pink,
            radius: 18,
            child: Text( index.toString() ),
          ),
          title: Text(
            'Apodo: ' + guest.apodo,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          subtitle: Text(
            'Nombre: ' + guest.nombre + '\nApellido: ' + guest.aPaterno + '\n' + 'Mesa: #' + guest.mesa.toString()
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: guest.asistioBoda == 1 ? Colors.pink : Colors.black45,
                ),
                onPressed: () {

                  final response = guestsProvider.updateAssistence(guest.idInvitado, guest.asistioBoda);
            
                  response.then((value){
                    if( value ){
                      Fluttertoast.showToast(
                        msg: 'La asistencia de ' + guest.apodo + ' ha sido modificada'
                      );
                      setState(() {
                        // Refresh
                      });
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Hemos tenido un problema al registrar al invitado'
                      );
                    }
                  });
                    
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  void mostrarSnackbar( String mensaje ) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text( mensaje ),
          duration: const Duration( milliseconds: 3500 ),
        ),
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
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              'Invitados',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
            )
          ],
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.plus,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () async {
              await Navigator.pushNamed(context, '/add_guest');
              setState(() {
                // Espera a que se cierre para refrescar
              });
            },
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.search,
              color: Colors.black,
              size: 18,
            ),
            onPressed: (){
              showSearch(
                context: context,
                delegate: GuestSearch(),
              );
            },
          ),
        ],
      ),
    );
  }
}
