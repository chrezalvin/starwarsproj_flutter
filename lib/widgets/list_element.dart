import 'package:flutter/material.dart';

class ListElement extends StatelessWidget{
  final String title;
  final Widget element;

  const ListElement({super.key, required this.title, required this.element});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title),
          element,
        ],
      ),
    );
  }
}