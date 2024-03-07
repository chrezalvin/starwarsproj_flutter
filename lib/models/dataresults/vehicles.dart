import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:starwarsproj_flutter/models/dataresults/base_swapi_result.dart';
import 'package:starwarsproj_flutter/pages/vehicles_view.dart';

Vehicles welcomeFromJson(String str) => Vehicles.fromJson(json.decode(str));

String welcomeToJson(Vehicles data) => json.encode(data.toJson());

class Vehicles extends BaseSwapiResult{
    String model;
    String manufacturer;
    String costInCredits;
    String length;
    String maxAtmospheringSpeed;
    String crew;
    String passengers;
    String cargoCapacity;
    String consumables;
    String vehicleClass;
    List<String> pilots;
    List<String> films;

    Vehicles({
        required super.name,
        required this.model,
        required this.manufacturer,
        required this.costInCredits,
        required this.length,
        required this.maxAtmospheringSpeed,
        required this.crew,
        required this.passengers,
        required this.cargoCapacity,
        required this.consumables,
        required this.vehicleClass,
        required this.pilots,
        required this.films,
        required super.created,
        required super.edited,
        required super.url,
    });

    factory Vehicles.fromJson(Map<String, dynamic> json) => Vehicles(
        name: json["name"],
        model: json["model"],
        manufacturer: json["manufacturer"],
        costInCredits: json["cost_in_credits"],
        length: json["length"],
        maxAtmospheringSpeed: json["max_atmosphering_speed"],
        crew: json["crew"],
        passengers: json["passengers"],
        cargoCapacity: json["cargo_capacity"],
        consumables: json["consumables"],
        vehicleClass: json["vehicle_class"],
        pilots: List<String>.from(json["pilots"].map((x) => x)),
        films: List<String>.from(json["films"].map((x) => x)),
        created: DateTime.parse(json["created"]),
        edited: DateTime.parse(json["edited"]),
        url: json["url"],
    );

    @override
    Widget createPage(String? imgPath) {
      return VehiclesView(vehicle: this, imgUrl: imgPath,);
    }

    @override
    Map<String, dynamic> toJson() => {
        "name": name,
        "model": model,
        "manufacturer": manufacturer,
        "cost_in_credits": costInCredits,
        "length": length,
        "max_atmosphering_speed": maxAtmospheringSpeed,
        "crew": crew,
        "passengers": passengers,
        "cargo_capacity": cargoCapacity,
        "consumables": consumables,
        "vehicle_class": vehicleClass,
        "pilots": List<dynamic>.from(pilots.map((x) => x)),
        "films": List<dynamic>.from(films.map((x) => x)),
        "created": created.toIso8601String(),
        "edited": edited.toIso8601String(),
        "url": url,
    };
}
