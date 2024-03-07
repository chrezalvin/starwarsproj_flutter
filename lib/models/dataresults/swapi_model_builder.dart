import 'package:starwarsproj_flutter/models/dataresults/base_swapi_result.dart';
import 'package:starwarsproj_flutter/models/dataresults/people.dart';
import 'package:starwarsproj_flutter/models/dataresults/planets.dart';
import 'package:starwarsproj_flutter/models/dataresults/vehicles.dart';

class SwapiModelBuilder<T extends BaseSwapiResult>{
  T? res;

  SwapiModelBuilder(this.res);

  factory SwapiModelBuilder.fromJson(Map<String, dynamic> json){

    late T swapi;
    switch(T){
      case People: swapi = People.fromJson(json) as T;
      case Vehicles: swapi = Vehicles.fromJson(json) as T;
      case Planets: swapi = Planets.fromJson(json) as T;
      default: UnimplementedError();
    }

    return SwapiModelBuilder(swapi);
  }
}