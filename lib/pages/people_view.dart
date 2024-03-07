import 'package:flutter/material.dart';
import 'package:starwarsproj_flutter/models/dataresults/people.dart';

class PeopleView extends StatelessWidget{
  final Map<String, String> peopleMap = {};
  final String? imgUrl;

  PeopleView({super.key, this.imgUrl, required People people}){
    peopleMap["name"] = people.name;
    peopleMap["height"] = people.height;
    peopleMap["mass"] = people.mass;
    peopleMap["hairColor"] = people.hairColor;
    peopleMap["skinColor"] = people.skinColor;
    peopleMap["eyeColor"] = people.eyeColor;
    peopleMap["birthYear"] = people.birthYear;
    peopleMap["gender"] = people.gender;
    peopleMap["edited"] = "${DateTime.now().difference(people.edited).inDays} days ago";
  }

  @override
  Widget build(BuildContext context) {
    var peopleRow = peopleMap.entries.map(
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
          title: Text(peopleMap["name"] ?? "n/a"),
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
                      peopleMap["name"] ?? "n/a",
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
                                children: peopleRow,
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