import 'package:flutter/material.dart';
import 'package:starwarsproj_flutter/models/dataresults/planets.dart';

class PlanetView extends StatelessWidget{
  final Map<String, String> planetMap = {};
  final String? imgUrl;

  PlanetView({super.key, this.imgUrl, required Planets planet}){
    planetMap["name"] = planet.name;
    planetMap["rotationPeriod"] = planet.rotationPeriod;
    planetMap["orbitalPeriod"] = planet.orbitalPeriod;
    planetMap["diameter"] = planet.diameter;
    planetMap["climate"] = planet.climate;
    planetMap["gravity"] = planet.gravity;
    planetMap["terrain"] = planet.terrain;
    planetMap["surfaceWater"] = planet.surfaceWater;
    planetMap["population"] = planet.population;
    planetMap["edited"] = "${DateTime.now().difference(planet.edited).inDays} days ago";
  }

  @override
  Widget build(BuildContext context) {
    var planetRow = planetMap.entries.map(
      (e) => Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(
            children: [
              Expanded(child: 
              Text(
                  e.key, 
                  textAlign: TextAlign.start, 
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ),
              Expanded(child: Text(e.value, textAlign: TextAlign.end,)),
            ],
          ),
        )
    ).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text(planetMap["name"] ?? "n/a"),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Image.asset(imgUrl ?? "", width: constraints.maxWidth,),
                    Text(
                      planetMap["name"] ?? "n/a",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Expanded(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                              width: constraints.maxWidth * 0.7,
                              child: Column(
                                children: planetRow,
                              ),
                            ),
                          )
                        );
                      }
                    ),
                  ]
                ),
              ),
            );
          }
        ),
      );
  }
}