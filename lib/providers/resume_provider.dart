import 'dart:convert';
import 'package:http/http.dart' as http;

class ResumeProvider {

  final String _url = "http://www.invitacionaboda.com/WebService/v1";

  Future<List<dynamic>> getResume( int idNovios ) async {

    final url = '$_url/getResume.php?idNovios=$idNovios';
    var response = await http.get( Uri.parse(url) );

    final Map<String, dynamic> dataResume = json.decode(response.body);

    List<dynamic> data = dataResume["resume"];

    return data;

  }  

}