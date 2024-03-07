import 'package:flutter/material.dart';
import 'package:starwarsproj_flutter/models/dataresults/vehicles.dart';

class VehiclesView extends StatelessWidget{
  final Map<String, String> vehicleMap = {};
  final String? imgUrl;

  VehiclesView({super.key, this.imgUrl, required Vehicles vehicle}){
    vehicleMap["name"] = vehicle.name;
    vehicleMap["model"] = vehicle.model;
    vehicleMap["manufacturer"] = vehicle.manufacturer;
    vehicleMap["costInCredits"] = vehicle.costInCredits;
    vehicleMap["length"] = vehicle.length;
    vehicleMap["maxAtmospheringSpeed"] = vehicle.maxAtmospheringSpeed;
    vehicleMap["crew"] = vehicle.crew;
    vehicleMap["passengers"] = vehicle.passengers;
    vehicleMap["cargoCapacity"] = vehicle.cargoCapacity;
    vehicleMap["consumables"] = vehicle.consumables;
    vehicleMap["vehicleClass"] = vehicle.vehicleClass;
    // vehicleMap["pilots"] = vehicle.pilots.toString();
    vehicleMap["edited"] = "${DateTime.now().difference(vehicle.edited).inDays} days ago";
  }

  @override
  Widget build(BuildContext context) {
    var vehicleRow = vehicleMap.entries.map(
      (e) => 
        Container(
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
          title: Text(vehicleMap["name"] ?? "n/a"),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Image.asset(imgUrl ?? "", height: 200,),
                    Text(
                      vehicleMap["name"] ?? "n/a",
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
                                children: vehicleRow,
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