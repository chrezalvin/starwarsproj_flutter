import 'package:starwarsproj_flutter/models/dataresults/base_swapi_result.dart';
import 'package:starwarsproj_flutter/models/swapi_page.dart';
import 'package:starwarsproj_flutter/provider/swapi.dart';

class SwapiService{
  final Swapi _api = Swapi();

  Future<SwapiPage<T>?> getByPage<T extends BaseSwapiResult>({int page = 1, String? search}) async{
    return _api.getbyPage<T>(page: page, search: search);
  }

  Future<T?> getById<T extends BaseSwapiResult>(int id){
    return _api.getById<T>(id);
  }
}