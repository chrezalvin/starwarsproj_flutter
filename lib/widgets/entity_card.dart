import 'package:flutter/material.dart';

class EntityCard extends StatefulWidget {
  final String title;
  final void Function()? onTap;
  final String? imgPath;
  final bool isFavorite;
  final void Function()? onSetFavorite;
  final IconData defaultIcon;

  const EntityCard({
    super.key,
    required this.title,
    this.imgPath,
    this.onTap,
    this.defaultIcon = Icons.people,
    this.isFavorite = false,
    this.onSetFavorite,
  });

  @override
  State<EntityCard> createState() => _EntityCardState();
}

class _EntityCardState extends State<EntityCard> {
  Widget loadImage(){
    var imgPath = widget.imgPath;

      if(imgPath != null){
          return Image.asset(
            imgPath, 
            errorBuilder: (context, error, stackTrace) {
              return FittedBox(child: Icon(widget.defaultIcon));
          });
      }
      return FittedBox(child: Icon(widget.defaultIcon));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Card(
          clipBehavior: Clip.hardEdge,
          shadowColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: loadImage(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 6,
          top: 6,
          child: SizedBox(
            child: IconButton(
              icon: Icon(
                Icons.favorite, 
                color: widget.isFavorite ? Colors.red[400] : Colors.grey[400],
              ),
              onPressed: widget.onSetFavorite,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            )
          ),
        )
      ],
    );
  }
}