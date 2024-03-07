import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:starwarsproj_flutter/configs/app_config.dart';
import 'package:starwarsproj_flutter/models/dataresults/base_swapi_result.dart';
import 'package:starwarsproj_flutter/models/dataresults/people.dart';
import 'package:starwarsproj_flutter/models/dataresults/planets.dart';
import 'package:starwarsproj_flutter/models/dataresults/swapi_model_builder.dart';
import 'package:starwarsproj_flutter/models/dataresults/vehicles.dart';
import 'package:starwarsproj_flutter/models/swapi_page.dart';

import 'package:http/http.dart' as http;

  enum PossiblePath{
    films, 
    people,
    planets,
    species,
    starships,
    vehicles,
  }

class Swapi{
  final log = Logger('Swapi');

  String translatePathEnumToPath(PossiblePath path){
    switch(path){
      case PossiblePath.films: return "films";
      case PossiblePath.people: return "people";
      case PossiblePath.planets: return "planets";
      case PossiblePath.species: return "species";
      case PossiblePath.starships: return "starships";
      case PossiblePath.vehicles: return "vehicles";
      default: throw UnimplementedError();
    }
  }

  String translateTypeToPathEnum(Type type){
    switch(type){
      case People: return "people";
      case Vehicles: return "vehicles";
      case Planets: return "planets";
      default: throw UnimplementedError();
    }
  }

  Uri translateUriPage<T extends BaseSwapiResult>(
    {
      required int page, 
      String? search
    }){
    String path = translateTypeToPathEnum(T);
    String url = "${AppConfig.apiBaseUrl}/$path?page=$page";
    if(search != null && search.isNotEmpty){
      url += "&search=$search";
    }
    return Uri.parse(url);
  }

  Uri translateUrlPage(PossiblePath path, int page){
    String url = "${AppConfig.apiBaseUrl}/${translatePathEnumToPath(path)}?page=$page";
    return Uri.parse(url);
  }

  Uri translateUriId<T extends BaseSwapiResult>(int id){
    String path = translateTypeToPathEnum(T);
    String url = "${AppConfig.apiBaseUrl}/$path/$id";
    return Uri.parse(url);
  }

  Uri translateUrlId(PossiblePath path, int id){
    String url = "${AppConfig.apiBaseUrl}/${translatePathEnumToPath(path)}/$id";
    return Uri.parse(url);
  }

  Future<SwapiPage<T>?> getbyPage<T extends BaseSwapiResult>({int page = 1, String? search}) async{
    http.Client client = http.Client();
    Uri url = translateUriPage<T>(page: page, search: search);

    log.info("get from API with url: $url");

    var res = await client.get(url);
    var json = jsonDecode(res.body);
    if(res.statusCode != 200){
      return null;
    }

    return SwapiPage<T>.fromJson(json);
  }

  Future<T?> getById<T extends BaseSwapiResult>(int id) async{
    http.Client client = http.Client();
    Uri url = translateUriId(id);

    log.info("get from API with url: $url");

    var res = await client.get(url);
    var json = jsonDecode(res.body);
    if(res.statusCode != 200){
      return null; 
    }

    return SwapiModelBuilder<T>.fromJson(json).res;
  }
}