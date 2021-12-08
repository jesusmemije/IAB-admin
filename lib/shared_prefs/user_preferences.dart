import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {

  static final PreferenciasUsuario _instance = PreferenciasUsuario._internal();

  factory PreferenciasUsuario(){
    return _instance;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void clear(){
    _prefs.clear();
  }

  // GET y SET
  bool get logeado {
    return _prefs.getBool('logeado') ?? false;
  }
  set logeado( bool value ) {
    _prefs.setBool('logeado', value);
  }

  int get idNovios {
    return _prefs.getInt('idNovios') ?? 0;
  }
  set idNovios( int value ) {
    _prefs.setInt('idNovios', value);
  }

  String get recepcionFecha {
    return _prefs.getString('recepcionFecha') ?? '';
  }
  set recepcionFecha( String value ) {
    _prefs.setString('recepcionFecha', value);
  }

}