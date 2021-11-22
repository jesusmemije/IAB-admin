import 'package:flutter/material.dart';
import 'package:invitacionaboda_admin/screens/add_guest_screen.dart';
import 'package:invitacionaboda_admin/screens/screens.dart';
import 'package:invitacionaboda_admin/shared_prefs/user_preferences.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final prefs = PreferenciasUsuario();
    var logeado = prefs.logeado;

    return MaterialApp(
      initialRoute: logeado == false ? '/login' : '/home',
      debugShowCheckedModeBanner: false,
      routes: {
        '/login'     : ( _ ) => const LoginScreen(),
        '/home'      : ( _ ) => const HomeScreen(),
        '/welcome'   : ( _ ) => const WelcomeScreen(),
        '/guests'    : ( _ ) => GuestsScreen(),
        '/resume'    : ( _ ) => ResumeScreen(),
        '/add_guest' : ( _ ) => const AddGuestScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
    );
  }
}