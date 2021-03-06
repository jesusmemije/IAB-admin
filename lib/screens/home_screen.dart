import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invitacionaboda_admin/providers/guests_provider.dart';
import 'package:invitacionaboda_admin/screens/guests_screen.dart';
import 'package:invitacionaboda_admin/screens/resume_screen.dart';
import 'package:invitacionaboda_admin/screens/welcome_screen.dart';
import 'package:invitacionaboda_admin/shared_prefs/user_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //Instance the shared preferences
  final prefs = PreferenciasUsuario();

  int currentIndex = 1;
  final globalKey = GlobalKey<ScaffoldState>();

  final guestsProvider = GuestsProvider();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: globalKey,
      drawer: _crearDrawer(),
      drawerEnableOpenDragGesture: false,
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar( context ),
      floatingActionButton: SpeedDial(
        icon: FontAwesomeIcons.plus,
        activeIcon: FontAwesomeIcons.times,
        elevation: 8.0,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.qr_code),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            label: 'Scannear QR',
            onTap: () async {
              String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#e91e63', 'Cancelar', false, ScanMode.QR);
          
              if( barcodeScanRes == '-1' ) {
                return;
              }

              if ( !barcodeScanRes.contains('http') ) {
                Fluttertoast.showToast(msg: 'El resultado del QR no tiene una estructura v??lida');
                return;
              }

              var uri = Uri.dataFromString(barcodeScanRes);
              Map getParametro = uri.queryParameters;

              if ( !getParametro.containsKey('adc') ) {
                Fluttertoast.showToast(msg: 'El resultado del QR no es v??lido');
                return;
              }

              if ( getParametro['adc'] == '' ) {
                Fluttertoast.showToast(msg: 'El resultado del QR est?? vac??o');
                return;
              }
              
              var idInvitadoADB = int.parse( getParametro['adc'] );

              Map response = await guestsProvider.getDataQR(prefs.idNovios, idInvitadoADB);

              if (response['ok'] == false) {
                Fluttertoast.showToast(msg: 'No hay resultados');
                return;
              }

              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    color: Colors.transparent,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text( 
                            'Apodo: ' + response['apodo'] + '\n'
                            'Nombre: ' + response['nombre'] + '\n'
                            'A. Paterno: ' + response['aPaterno'] + '\n'
                            'A. Materno: ' + response['aMaterno'] + '\n'
                            'Mesa: ' + response['mesa'] + '\n'
                            'No. boletos: ' + response['boletos'] + '\n'
                            'Acompa??antes: ' + response['acompanantes'],
                            style: const TextStyle(height: 1.2),
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            child: const Text('Cerrar'),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.airline_seat_recline_normal_sharp),
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            label: 'Ver mesas',
            onTap: () {
              Navigator.pushNamed(context, '/guests_by_table');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_reaction_outlined),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Agregar invitado',
            onTap: () {
              Navigator.pushNamed(context, '/add_guest');
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _crearBottomNavigationBar( BuildContext context ) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: const Icon(FontAwesomeIcons.bars), onPressed: () {
              return globalKey.currentState!.openDrawer();
            }),
            IconButton(icon: const Icon(FontAwesomeIcons.home), color: currentIndex == 1 ? Theme.of(context).primaryColor : Colors.black87, onPressed: () {
              setState(() {
                currentIndex = 1;
              });
            },),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(FontAwesomeIcons.tasks), 
              color: currentIndex == 2 ? Theme.of(context).primaryColor : Colors.black, onPressed: () {
              setState(() {
                currentIndex = 2;
              });
            },),
            IconButton(
              icon: const Icon(FontAwesomeIcons.star), 
              color: currentIndex == 3 ? Theme.of(context).primaryColor : Colors.black, onPressed: () {
              setState(() {
                currentIndex = 3;
              });
            },),
          ],
        ),
      ),
    );
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 1:
        return const WelcomeScreen();
      case 2:
        return const GuestsScreen();
      case 3:
        return ResumeScreen();

      default:
        return const WelcomeScreen();
    }
  }

  Widget _crearDrawer() {
    return Drawer(
      elevation: 0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.asset(
                'assets/img/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            accountName: const Text( 'invitacionaboda.com' ),
            accountEmail: Text( prefs.correoRegistro ),
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
            title: const Text("Inicio"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(
                Icons.airline_seat_recline_normal_sharp,
                color: Colors.white,
              ),
            ),
            title: const Text("Ver mesas"),
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, '/guests_by_table');
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(
                Icons.add_reaction_outlined,
                color: Colors.white,
              ),
            ),
            title: const Text("Agregar invitados"),
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, '/add_guest');
            },
          ),
          const Divider(),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(
                Icons.help,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            title: const Text("Acerca de nosotros"),
            onTap: () {},
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            title: const Text("Cerrar sesi??n"),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => _buildAlertDialog()
              );
            },
          ),
          const ListTile(
            title: Text('1.2.0'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertDialog() {

    return AlertDialog(
      title: const Text('Cerrar sesi??n'),
      content: const Text("??Seguro que quieres cerrar la sesi??n?"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      actions: [
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        TextButton(
          child: const Text("Aceptar"),
          onPressed: () {
            prefs.clear();
            Navigator.pushNamedAndRemoveUntil(context, '/login', ModalRoute.withName('/login'));
          }
        ),
      ],
    );
  }

}
