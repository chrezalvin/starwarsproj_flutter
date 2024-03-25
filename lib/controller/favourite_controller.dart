import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starwarsproj_flutter/configs/app_config.dart';
import 'package:starwarsproj_flutter/models/dataresults/base_swapi_result.dart';
import 'package:starwarsproj_flutter/models/dataresults/people.dart';
import 'package:starwarsproj_flutter/models/dataresults/planets.dart';
import 'package:starwarsproj_flutter/models/dataresults/swapi_model_builder.dart';
import 'package:starwarsproj_flutter/models/dataresults/vehicles.dart';

class FavouriteController extends GetxController{
  final Logger log = Logger("FavouriteController");
  SharedPreferences? sharedFavourite;
  
  final RxMap<Type, List<BaseSwapiResult>> _favourites = RxMap();
  final RxString _search = "".obs;
  final RxMap<Type, Map<int, String>> _imageAssets = RxMap();


  Future<void> _load<T extends BaseSwapiResult>() async{
    sharedFavourite = await SharedPreferences.getInstance();

    // for(var nav in AppConfig.navList){
      var favStr = sharedFavourite?.getString(T.toString());

      if(favStr != null){
        var json = jsonDecode(favStr);
        // print(json);

        if(json != null){
          var favList = List<dynamic>
          .from(json)
          .map((ele) => SwapiModelBuilder<T>.fromJson(ele).res)
          .whereType<T>()
          .toList();

          _favourites[T] = favList;
        }
      // }
    }
    return;
  }

  Future<void> load() async{
    await _load<People>();
    await _load<Vehicles>();
    await _load<Planets>();
  }

  Future<void> unfavorite(Type type, int id) async{
    var favList = _favourites[type] ?? [];
    favList.removeWhere((element) => element.id == id);
    _favourites[type] = favList;
    await sharedFavourite?.setString(type.toString(), jsonEncode(favList));
  }

    Future<void> loadAssetManifest() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final RegExp regex = RegExp(r"(\d+)");

    for(var nav in AppConfig.navList){
      var type = nav.type;
      Map<int, String> mapCollect = {};
      manifest
        .listAssets()
        .where(
          (element) => element
          .startsWith("assets/images/${nav.label.toLowerCase()}")
        )
        .toList()
        .forEach((e){
          var match = regex.firstMatch(e);
          if(match != null){
            mapCollect[int.parse(match.group(0) ?? "0")] = e;
          }
        });

      _imageAssets[type] = mapCollect;
    }
  }

  // getter
  Map<Type, List<BaseSwapiResult>> get favourites => _favourites.map((key, value) => MapEntry(key, value));
  Map<Type, Map<int, String>> get imageAssets => _imageAssets.map((key, value) => MapEntry(key, value));
  String get search => _search.value;

  // setter
  setSearch(String value) => _search.value = value;
}