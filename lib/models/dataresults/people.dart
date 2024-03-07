import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:starwarsproj_flutter/models/dataresults/base_swapi_result.dart';
import 'package:starwarsproj_flutter/pages/people_view.dart';

People peopleFromJson(String str) => People.fromJson(json.decode(str));

String peopleToJson(People data) => json.encode(data.toJson());

class People extends BaseSwapiResult{
    String height;
    String mass;
    String hairColor;
    String skinColor;
    String eyeColor;
    String birthYear;
    String gender;
    String homeworld;
    List<String> films;
    List<dynamic> species;
    List<String> vehicles;
    List<String> starships;

    People({
        required super.name,
        required this.height,
        required this.mass,
        required this.hairColor,
        required this.skinColor,
        required this.eyeColor,
        required this.birthYear,
        required this.gender,
        required this.homeworld,
        required this.films,
        required this.species,
        required this.vehicles,
        required this.starships,
        required super.created,
        required super.edited,
        required super.url,
    });

    @override
    factory People.fromJson(Map<String, dynamic> json) =>   People(
        name: json["name"],
        height: json["height"],
        mass: json["mass"],
        hairColor: json["hair_color"],
        skinColor: json["skin_color"],
        eyeColor: json["eye_color"],
        birthYear: json["birth_year"],
        gender: json["gender"],
        homeworld: json["homeworld"],
        films: List<String>.from(json["films"].map((x) => x)),
        species: List<dynamic>.from(json["species"].map((x) => x)),
        vehicles: List<String>.from(json["vehicles"].map((x) => x)),
        starships: List<String>.from(json["starships"].map((x) => x)),
        created: DateTime.parse(json["created"]),
        edited: DateTime.parse(json["edited"]),
        url: json["url"],
    );

    @override
    Widget createPage(String? imgPath) {
      return PeopleView(people: this, imgUrl: imgPath,);
    }

    @override
    Map<String, dynamic> toJson() => {
        "name": name,
        "height": height,
        "mass": mass,
        "hair_color": hairColor,
        "skin_color": skinColor,
        "eye_color": eyeColor,
        "birth_year": birthYear,
        "gender": gender,
        "homeworld": homeworld,
        "films": List<dynamic>.from(films.map((x) => x)),
        "species": List<dynamic>.from(species.map((x) => x)),
        "vehicles": List<dynamic>.from(vehicles.map((x) => x)),
        "starships": List<dynamic>.from(starships.map((x) => x)),
        "created": created.toIso8601String(),
        "edited": edited.toIso8601String(),
        "url": url,
    };
}