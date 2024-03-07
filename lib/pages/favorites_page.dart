import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starwarsproj_flutter/configs/app_config.dart';
import 'package:starwarsproj_flutter/controller/favourite_controller.dart';
import 'package:starwarsproj_flutter/models/dataresults/base_swapi_result.dart';
import 'package:starwarsproj_flutter/widgets/entity_card.dart';

class FavoritesPage extends StatelessWidget{
  const FavoritesPage({super.key});

  List<Widget> listWidget(FavouriteController controller, BuildContext context, String search){
    List<Widget> list = [];

    for(var entry in controller.favourites.entries){
      Type type = entry.key;
      List<BaseSwapiResult> favList = entry.value;

      for(var fav in favList){
        if(search.isNotEmpty && !fav.name.toLowerCase().contains(search.toLowerCase())){
          continue;
        }

        final nav = AppConfig.navList.firstWhere((element) => element.type == type);
        final imgPath = controller.imageAssets[type]?[fav.id];

        list.add(
          EntityCard(
            title: fav.name,
            defaultIcon: nav.icon,
            imgPath: imgPath,
            isFavorite: true,
            onTap: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => fav.createPage(imgPath))
            ),
            onSetFavorite: () => controller.unfavorite(nav.type, fav.id),
          )
        );
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final FavouriteController controller = Get.put(FavouriteController());
    controller.loadAssetManifest();
    controller.load();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              SearchBar(
                controller: null,
                onChanged: controller.setSearch,
                leading: const Icon(Icons.search),
                hintText: "Search Favorite by name",
                constraints: const BoxConstraints(minHeight: 40, maxWidth: 400),
              ),
              const SizedBox(height: 15),
              Obx(() => 
                Flexible(
                  child: GridView.extent(
                    maxCrossAxisExtent: 150,
                    padding: const EdgeInsets.all(4),
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: listWidget(controller, context, controller.search),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}