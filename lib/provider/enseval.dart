import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

class Enseval{
  final log = Logger("Enseval");

  Uri translateLogin(String username, String password){
    // return Uri.parse("https://guard.enseval.com/for_api/reads.php?key=PquNF&nik=240200221");
    // return Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?s=Arrabiata");
    return Uri.https("guard.enseval.com", "/for_api/reads.php", {
      "key": password,
      "nik": username
    });
  }

  Future<dynamic> login(String username, String password) async{
    http.Client client = http.Client();
    Uri url = translateLogin(username, password);

    log.info("get from API with url: $url");

    var res = await client.get(url);
    if(res.statusCode != 200){
      return null;
    }

    log.info("Response: ${res.statusCode}");

    var json = jsonDecode(res.body);

    // check if EmpName is available
    if(json["EmpName"] != null){
      return json;
    }
    else {
      throw Exception("Invalid username or password");
    }
  }
}