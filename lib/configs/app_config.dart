import 'package:flutter/material.dart';
import 'package:starwarsproj_flutter/models/dataresults/people.dart';
import 'package:starwarsproj_flutter/models/dataresults/planets.dart';
import 'package:starwarsproj_flutter/models/dataresults/vehicles.dart';

enum PossiblePath{
  films, 
  people,
  planets,
  species,
  starships,
  vehicles,
}

class NavItemType{
  Type type;
  IconData icon;
  String label;

  NavItemType(this.type, this.icon, this.label);
}

class AppConfig{
  static String apiBaseUrl = "";
  static String ensevalGuardUrl = "";

  static List<NavItemType> navList = [
    NavItemType(People, Icons.people, "People"),
    NavItemType(Vehicles, Icons.car_rental, "Vehicles"),
    NavItemType(Planets, Icons.circle, "Planets")
  ];
}