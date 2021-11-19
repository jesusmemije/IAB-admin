import 'package:flutter/material.dart';
import 'package:invitacionaboda_admin/models/guest_model.dart';
import 'package:invitacionaboda_admin/providers/guests_provider.dart';
import 'package:invitacionaboda_admin/shared_prefs/user_preferences.dart';

class GuestSearch extends SearchDelegate {

  final guestProvider = GuestsProvider();
  final prefs = PreferenciasUsuario();

  @override
  List<Widget> buildActions(BuildContext context) {
    //Acciones de nuestro AppBar
    return [
      IconButton(
        icon: const Icon(Icons.clear), 
        onPressed: (){
          query = '';
        }
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crear los resultados que vamos a mostrar en la misma pantalla de búsqueda
    // En este caso no me sirve.
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las segurencias que aparecen cuando la persona escribe.

    if ( query.isEmpty ) return Container();

    return FutureBuilder(
      future: guestProvider.searchGuest(prefs.idNovios, query),
      builder: (BuildContext context, AsyncSnapshot<List<GuestModel>> snapshot) {
        
        final guests = snapshot.data;

        if ( snapshot.hasData ){
          if ( guests!.isNotEmpty ) {
            int index = 0;
            return ListView(
              children: guests.map( (guest) {
                index ++;
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
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
                );
                
              }).toList(),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.cloud_off,
                      color: Colors.black54,
                      size: 40.0,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'No se encontraron datos relacionados',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
