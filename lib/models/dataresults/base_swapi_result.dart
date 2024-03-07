import 'package:flutter/material.dart';

class BaseSwapiResult {
    String name;
    DateTime created;
    DateTime edited;
    String url;

    BaseSwapiResult({
        required this.name,
        required this.created,
        required this.edited,
        required this.url,
    });

    factory BaseSwapiResult.fromJson(Map<String, dynamic> json) => BaseSwapiResult(
        name: json["name"],
        created: DateTime.parse(json["created"]),
        edited: DateTime.parse(json["edited"]),
        url: json["url"],
    );

    int get id{
      // get id from url
      //                              vvvv this
      // https://swapi.dev/api/people/[11]/
      RegExp regex = RegExp(r'(\d+)');
      var match = regex.firstMatch(url);
      return int.parse(match?[0] ?? "0");
    }

    Widget createPage(String? imgPath){
      return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: Column(
          children: [
            Text(name),
            Text(created.toString()),
            Text(edited.toString()),
          ]
        ),
      );
    }

    Map<String, dynamic> toJson() => {
        "name": name,
        "created": created.toIso8601String(),
        "edited": edited.toIso8601String(),
        "url": url,
    };
}