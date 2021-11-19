import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: globalKey,
      drawer: _crearDrawer(),
      drawerEnableOpenDragGesture: false,
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar( context ),
      floatingActionButton: FloatingActionButton(
        elevation: 8.0,
        child: const Icon(FontAwesomeIcons.qrcode),
        onPressed: (){}
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
        return GuestsScreen();
      case 3:
        return ResumeScreen();

      default:
        return const WelcomeScreen();
    }
  }

  Widget _crearDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 50.0,
              ),
            ),
            accountName: Text( 'Invitación a boda' ),
            accountEmail: Text( 'example@mail.com' ),
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            title: const Text("Profile Settings"),
            onTap: () {},
          ),
          const ListTile(
            leading: CircleAvatar(
              child: Icon(
                Icons.cached,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            title: Text("Recenceter"),
          ),
          const Divider(),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(
                Icons.help_outline,
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
                Icons.settings,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            title: const Text("Configuración"),
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
            title: const Text("Cerrar sesión"),
            onTap: () {
              prefs.clear();
              Navigator.pushNamedAndRemoveUntil(context, '/login', ModalRoute.withName('/login'));
            },
          ),
        ],
      ),
    );
  }
}