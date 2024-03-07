import 'dart:async';
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
import 'package:starwarsproj_flutter/models/swapi_page.dart';
import 'package:starwarsproj_flutter/service/swapi_service.dart';

class HomeController extends GetxController{
  final Logger log = Logger("HomeController");

  Timer? _timer;
  final Rxn<SwapiPage> _pageRes = Rxn();
  SharedPreferences? sharedFavourite;
  RxInt _pageNo = 1.obs;
  final RxInt _currentPageIndex = 0.obs;
  final RxBool _isLoaded = false.obs;
  final RxBool _isExtend = false.obs;
  final RxString _search = "".obs;
  final RxMap<Type, RxList<BaseSwapiResult>> _favIds = RxMap();
  final RxBool _isLoadingSharedPreferences = false.obs;

  final RxMap<Type, Map<int, String>> _imageAssets = RxMap();

  // getter
  SwapiPage? get pageRes => _pageRes.value;
  int get pageNo => _pageNo.value;
  int get currentPageIndex => _currentPageIndex.value;
  bool get isLoaded => _isLoaded.value;
  bool get isExtend => _isExtend.value;
  String get search => _search.value;
  NavItemType get currentPageNav => AppConfig.navList[_currentPageIndex.value];
  Map<Type, Map<int, String>> get imageAssets => _imageAssets.map((key, value) => MapEntry(key, value));
  List<BaseSwapiResult> get favIds => _favIds[AppConfig.navList[_currentPageIndex.value].type] ?? [];
  bool get isLoadingSharedPreferences => _isLoadingSharedPreferences.value;

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

  // setter
  Future<void> _load<T extends BaseSwapiResult>() async{
    setLoaded(false);
    // _favIds.clear();

    if(sharedFavourite == null){
      sharedFavourite = await SharedPreferences.getInstance();
      
      for(var nav in AppConfig.navList){
        Type type = nav.type;

        if(sharedFavourite!.containsKey(type.toString())){
          var json = jsonDecode(sharedFavourite!.getString(type.toString())!);
          var favList = List<dynamic>
            .from(json)
            .map((ele) => SwapiModelBuilder<T>.fromJson(ele).res)
            .whereType<T>()
            .toList();

          _favIds[type] = favList.obs;

          log.info("loaded ${_favIds[type]!.length} amount of data from $type sharedPreferences");
        }
        else{
          log.info("sharedpreference ${type.toString()} not found, creating one");
          // if the type sharedpreference is not found, create one with empty list
          await sharedFavourite?.setString(type.toString(), jsonEncode([]));
          _favIds[type] = List<BaseSwapiResult>.empty().obs;
        }
      }
    }

    final SwapiService swapiService = SwapiService();

    var res = await swapiService.getByPage<T>(page: _pageNo.value, search: _search.value);
    _pageRes.value = res;

    setLoaded(true);
  }

  Future<void> load() async{
    switch(AppConfig.navList[_currentPageIndex.value].type){
      case People: await _load<People>(); break;
      case Vehicles: await _load<Vehicles>(); break;
      case Planets: await _load<Planets>(); break;
      default: throw UnimplementedError();
    }
  }

  Future<void> nextPage() async{ ++_pageNo; await load(); }
  Future<void> prevPage() async{ --_pageNo; await load(); }

  setPageIndex(int index){ 
    _currentPageIndex.value = index;
    resetState();
    load();
  }

  Future<void> toggleFavourite(BaseSwapiResult swapiRes) async{
    if(isLoadingSharedPreferences){
      return;
    }

    setLoadingSharedPreferences(true);

    final idMap = favIds.map((element) => element.id);
    final targId = swapiRes.id;
    final currentType = AppConfig.navList[_currentPageIndex.value].type;

    if(idMap.contains(targId)){
      log.info("removing #$targId ${swapiRes.name} [${currentType.toString()}] from sharedpreference");
      int find = idMap.firstWhere((element) => element == targId, orElse: () => -1,);

      if(find != -1){
        _favIds[currentType]!.value = _favIds[currentType]!.where((p0) => p0.id != targId).toList();
      }
    }
    else{
      log.info("adding #$targId ${swapiRes.name} [${currentType.toString()}] to sharedpreference");
      _favIds[currentType]!.add(swapiRes);
    }

    log.info(_favIds);

    // replaces the old one
    await sharedFavourite?.setString(currentType.toString(), jsonEncode(favIds));
    setLoadingSharedPreferences(false);
  }

  // bool idIsFavorite(int id) => false;
  bool idIsFavorite(int id) => favIds.map((e) => e.id).contains(id);

  setLoaded(bool loaded){ _isLoaded.value = loaded; }
  setLoadingSharedPreferences(bool isLoading){ _isLoadingSharedPreferences.value = isLoading; }

  toggleExtend(){ _isExtend.value = !_isExtend.value; }

  resetState(){
    _search.value = "";
    _pageNo.value = 1;
  }

  setSearch(String term){ 
    setLoaded(false);
    _search.value = term;

    if(_timer == null){
      _timer = Timer(const Duration(milliseconds: 500), () {
        load();
      });
    }
    else{
      _timer!.cancel();
      _timer = Timer(const Duration(milliseconds: 500), () {
        load();
      });
    }
  }
}