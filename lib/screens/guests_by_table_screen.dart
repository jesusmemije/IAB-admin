
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invitacionaboda_admin/models/guest_model.dart';
import 'package:invitacionaboda_admin/providers/guests_provider.dart';
import 'package:invitacionaboda_admin/shared_prefs/user_preferences.dart';

class GuestsByTableScreen extends StatefulWidget {
  const GuestsByTableScreen({Key? key}) : super(key: key);

  @override
  _GuestsByTableScreenState createState() => _GuestsByTableScreenState();
}

class _GuestsByTableScreenState extends State<GuestsByTableScreen> {

  final prefs = PreferenciasUsuario();

  //Variables de control
  String _idMesaSelected = '';

  //Provider
  final guestsProvider = GuestsProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _crearAppBar( context ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _dropDownTables(),
              const SizedBox(height: 10.0),  
              _idMesaSelected == '' ? Container() : _showGeneralDescription(), 
              const SizedBox(height: 10.0),  
              _idMesaSelected == '' ? _notSelected() : _showGuestsByTable(),    
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropDownTables() {

    return FutureBuilder<List<dynamic>>(
      future: guestsProvider.getTablesByGroup( prefs.idNovios ),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        return DropdownButton<String>(
            items: snapshot.data!.map((mesa) => DropdownMenuItem<String>(
              child: Text( 'Mesa #' + mesa['mesa'], overflow: TextOverflow.ellipsis),
              value: mesa['mesa'].toString(),
            )).toList(),
            onChanged: (String? idMesaSelected) {
              setState(() {
                _idMesaSelected = idMesaSelected!;
              });
            },
            hint: const Text('Selecciona una mesa'),
            isExpanded: true, 
            value: _idMesaSelected == '' ? null : _idMesaSelected,        
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 32,
            iconEnabledColor: Theme.of(context).primaryColor,
            underline: Container(
              height: 2,
              color: Colors.pinkAccent,
            )
        );
      }
    );
  }

  Widget _showGeneralDescription() {

    return FutureBuilder<Map>(
      future: guestsProvider.getDataTableGeneral(prefs.idNovios, int.parse(_idMesaSelected)),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {

        final dataGeneral = snapshot.data;

        if (snapshot.hasData) {
          if ( dataGeneral!.isNotEmpty ) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Card(
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0.0),
                      child: Center(
                        child: Column(
                          children: [
                            const Text('Boletos'),
                            Text(dataGeneral['boletos'].toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
                          ],
                        )
                      )
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0.0),
                      child: Center(
                        child: Column(
                          children: [
                            const Text('Confirmados'),
                            Text(dataGeneral['boletosConfirmados'].toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
                          ],
                        )
                      )
                    ),
                  ),
                )
              ],
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
                    Text( 'No se encontró ningún dato', textAlign: TextAlign.center),
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

  Widget _showGuestsByTable() {

    return FutureBuilder(
      future: guestsProvider.getGuestsByTable( prefs.idNovios, int.parse(_idMesaSelected) ),
      builder: (BuildContext context, AsyncSnapshot<List<GuestModel>> snapshot) {

        final guests = snapshot.data;

        if (snapshot.hasData) {
          if ( guests!.isNotEmpty ) {
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: guests.length,
                itemBuilder: (context, i) => _crearItemGuest( context, guests[i], i),
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

  Widget _crearItemGuest( BuildContext context, GuestModel guest, int index ) {

    index = index + 1;

    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
      child: Container(
        color: Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 20),
          title: Text(
            'Apodo: ' + guest.apodo,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          subtitle: Text(
            'Nombre: '+guest.nombre+' '+guest.aPaterno+' '+guest.aMaterno
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/edit_guest', arguments: guest);
                  setState(() {
                    // Espera a que se cierre para refrescar
                  });
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notSelected() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.sentiment_dissatisfied,
          size: 40.0
        ),
        SizedBox(height: 8.0),
        Text('Aún no ha seleccionado la mesa', textAlign: TextAlign.center),
      ],
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
              'Ver mesas',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
            )
          ],
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
    );
  }

}