import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:starwarsproj_flutter/models/dataresults/base_swapi_result.dart';
import 'package:starwarsproj_flutter/pages/planet_view.dart';

Planets planetFromJson(String str) => Planets.fromJson(json.decode(str));

String planetToJson(Planets data) => json.encode(data.toJson());

class Planets extends BaseSwapiResult{
    String rotationPeriod;
    String orbitalPeriod;
    String diameter;
    String climate;
    String gravity;
    String terrain;
    String surfaceWater;
    String population;
    List<String> residents;
    List<String> films;

    Planets({
        required super.name,
        required this.rotationPeriod,
        required this.orbitalPeriod,
        required this.diameter,
        required this.climate,
        required this.gravity,
        required this.terrain,
        required this.surfaceWater,
        required this.population,
        required this.residents,
        required this.films,
        required super.created,
        required super.edited,
        required super.url,
    });

    @override
    Widget createPage(String? imgPath) {
      return PlanetView(planet: this, imgUrl: imgPath,);
    }

    @override
    factory Planets.fromJson(Map<String, dynamic> json) => Planets(
        name: json["name"],
        rotationPeriod: json["rotation_period"],
        orbitalPeriod: json["orbital_period"],
        diameter: json["diameter"],
        climate: json["climate"],
        gravity: json["gravity"],
        terrain: json["terrain"],
        surfaceWater: json["surface_water"],
        population: json["population"],
        residents: List<String>.from(json["residents"].map((x) => x)),
        films: List<String>.from(json["films"].map((x) => x)),
        created: DateTime.parse(json["created"]),
        edited: DateTime.parse(json["edited"]),
        url: json["url"],
    );

    @override
    Map<String, dynamic> toJson() => {
        "name": name,
        "rotation_period": rotationPeriod,
        "orbital_period": orbitalPeriod,
        "diameter": diameter,
        "climate": climate,
        "gravity": gravity,
        "terrain": terrain,
        "surface_water": surfaceWater,
        "population": population,
        "residents": List<dynamic>.from(residents.map((x) => x)),
        "films": List<dynamic>.from(films.map((x) => x)),
        "created": created.toIso8601String(),
        "edited": edited.toIso8601String(),
        "url": url,
    };
}
