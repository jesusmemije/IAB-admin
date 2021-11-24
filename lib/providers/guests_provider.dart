import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:invitacionaboda_admin/models/guest_model.dart';

class GuestsProvider {

  final String _url = "http://www.invitacionaboda.com/WebService/v1";

  Future<List<GuestModel>> getGuests( int idNovios ) async {

    final url = '$_url/getGuests.php?idNovios=$idNovios';
    final resp = await http.get( Uri.parse(url) );

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<GuestModel> listGuests = [];

    // ignore: avoid_print
    print(decodedData);

    decodedData.forEach((id, guest) {

      final guestTemp = GuestModel.fromJson(guest);

      listGuests.add( guestTemp );

    });

    return listGuests;

  }

  Future<List<GuestModel>> searchGuest( int idNovios, String query ) async {

    final url = '$_url/getGuests.php?idNovios=$idNovios&query=$query';
    final resp = await http.get( Uri.parse(url) );

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<GuestModel> guests = [];

    decodedData.forEach((id, guest) {

      final guestTemp = GuestModel.fromJson(guest);
      guests.add( guestTemp );

    });

    return guests;

  }

  Future<bool> addGuest( GuestModel guestModel ) async {

    final url = '$_url/addGuest.php';

    final response = await http.post( Uri.parse(url), body: guestModelToJson(guestModel) );
    final decodedData = json.decode(response.body);

    // ignore: avoid_print
    print(decodedData);

    if ( decodedData['ok'] == true ) {
      return true;
    } else {
      return false;
    }

  }

  Future<bool> editGuest( GuestModel guestModel ) async {

    final url = '$_url/editGuest.php';

    final response = await http.post( Uri.parse(url), body: guestModelToJson(guestModel) );
    final decodedData = json.decode(response.body);

    // ignore: avoid_print
    print(decodedData);

    if ( decodedData['ok'] == true ) {
      return true;
    } else {
      return false;
    }

  } 

  Future<bool> deleteGuest( int idInvitado ) async {

    final url = '$_url/deleteGuest.php?idInvitado=$idInvitado';
    final response = await http.get( Uri.parse(url) );

    final decodedData = json.decode(response.body);

    // ignore: avoid_print
    print(decodedData);

    if ( decodedData['ok'] == true ) {
      return true;
    } else {
      return false;
    }

  }

  Future<bool> updateAssistence( int idInvitado, int asistioBoda) async {

    final url = '$_url/updateAssistence.php?idInvitado=$idInvitado&asistioBoda=$asistioBoda';
    final response = await http.get( Uri.parse(url) );

    final decodedData = json.decode(response.body);

    // ignore: avoid_print
    print(decodedData);

    if ( decodedData['ok'] == true ) {
      return true;
    } else {
      return false;
    }

  }

  Future<Map<String, dynamic>> getDataQR( int idNovios, int idInvitadoADB) async {

    final url = '$_url/getDataQR.php?idNovios=$idNovios&idInvitadoADB=$idInvitadoADB';
    var response = await http.get( Uri.parse(url) );

    final Map<String, dynamic> dataLogin = json.decode(response.body);

    return dataLogin;

  } 

}