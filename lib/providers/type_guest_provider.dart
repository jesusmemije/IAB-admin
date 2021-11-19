import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:invitacionaboda_admin/models/type_guest_model.dart';

class TypeGuestProvider {

  final String _url = "http://www.invitacionaboda.com/WebService/v1";

  Future<List<TypeGuestModel>> getGuests( int idNovios ) async {

    final url = '$_url/getTypeGuest.php?idNovios=$idNovios';
    final resp = await http.get( Uri.parse(url) );

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<TypeGuestModel> listTypeGuest = [];

    decodedData.forEach((id, typeGuest) {

      final guestTypeTemp = TypeGuestModel.fromJson(typeGuest);
      listTypeGuest.add( guestTypeTemp );

    });

    return listTypeGuest;

  }

}