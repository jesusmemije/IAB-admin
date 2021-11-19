import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invitacionaboda_admin/providers/resume_provider.dart';
import 'package:invitacionaboda_admin/shared_prefs/user_preferences.dart';

class ResumeScreen extends StatelessWidget {
  ResumeScreen({ Key? key }) : super(key: key);

  final resumeProvider = ResumeProvider();
  final prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _crearAppBar(context),
      body: _crearListado(),
    );
  }

  Widget _crearListado() {

    return FutureBuilder(
      future: resumeProvider.getResume( prefs.idNovios ),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {

        final resume = snapshot.data;

        if (snapshot.hasData) {
          if ( resume!.isNotEmpty ) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Número de invitaciones: " + resume[0]["invitaciones"] + '\n'
                            "Invitaciones enviadas: " + resume[0]["invitacionEnviada"] + '\n'
                            "No. de boletos: " + resume[0]["boletos"] + '\n'
                            "Boletos confirmados: " + resume[0]["boletosConfirmados"] + '\n'
                            "Códigos QR enviados: " + resume[0]["QREnviado"] + '\n'
                            "Códigos QR confirmados: " + resume[0]["QRConfirmado"] + '\n'
                            "Asistencias confirmadas: " + resume[0]["Asistira"] + '\n'
                            "Asistencias confirmadas sólo a misa: " + resume[0]["soloMisa"] + '\n',
                            style: const TextStyle(
                              height: 1.4,
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
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
                    Text( 'No se encontró resumen', textAlign: TextAlign.center),
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
            Text('Resumen',
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