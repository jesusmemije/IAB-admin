import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invitacionaboda_admin/providers/guests_provider.dart';
import 'package:invitacionaboda_admin/shared_prefs/user_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final prefs = PreferenciasUsuario();

  final guestsProvider = GuestsProvider();

  bool validateDate = false;

  @override
  Widget build(BuildContext context) {

    var dateBoda = DateTime.tryParse( prefs.recepcionFecha );
    if( dateBoda != null ) {
      DateTime dateNow = DateTime.now();
      validateDate = dateNow.isAfter(dateBoda);
    }

    return Scaffold(
      appBar: _crearAppBar(context),
      body: infoWelcome(),
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
            Text('IAB Admin',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
          ],
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget infoWelcome() {
    
    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text(
                "Invitación a boda.com",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6.0),
              const Text(
                "COMPARTIMOS TUS EMOCIONES",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontStyle: FontStyle.italic
                ),
              ),
              const SizedBox(height: 24.0),
              Card(
                elevation: 12,
                child: Image.asset(
                  'assets/img/welcome.png',
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24.0),
              validateDate ? _showTotalAssists() : Container()
            ],
          ),
        ],
      )
    );
  }

  Widget _showTotalAssists() {

    return FutureBuilder<Map>(
        future: guestsProvider.getTotalAssists( prefs.idNovios ),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {

          final data = snapshot.data;

          if (snapshot.hasData) {
            if ( data!.isNotEmpty ) {
              return Card(
                elevation: 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  child: Center(
                    child: Column(
                      children: [
                        const Text('Total de personas que asisten'),
                        const SizedBox(height: 8),
                        Text(data['totalAssists'].toString(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700))
                      ],
                    )
                  )
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
}