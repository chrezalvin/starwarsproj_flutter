import 'dart:convert';

import 'package:starwarsproj_flutter/models/dataresults/base_swapi_result.dart';
import 'package:starwarsproj_flutter/models/dataresults/people.dart';
import 'package:starwarsproj_flutter/models/dataresults/planets.dart';
import 'package:starwarsproj_flutter/models/dataresults/vehicles.dart';

SwapiPage swapiPageFromJson(String str) => SwapiPage.fromJson(json.decode(str));

String swapiPageToJson(SwapiPage data) => json.encode(data.toJson());

class SwapiPage<T extends BaseSwapiResult> {
    int count;
    String? next;
    String? previous;
    List<T> results;

    SwapiPage({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory SwapiPage.fromJson(Map<String, dynamic> json) => SwapiPage(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<T>.from(json["results"].map((x){
          switch(T){
            case People: return People.fromJson(x) as T;
            case Planets: return Planets.fromJson(x) as T;
            case Vehicles: return Vehicles.fromJson(x) as T;
            default: throw UnimplementedError();
          }
        })),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<T>.from(results.map((x) => x.toJson())),
    };
}