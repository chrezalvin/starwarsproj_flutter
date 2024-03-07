import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:starwarsproj_flutter/configs/app_config.dart';
import 'package:starwarsproj_flutter/controller/home_controller.dart';
import 'package:starwarsproj_flutter/pages/favorites_page.dart';
import 'package:starwarsproj_flutter/widgets/entity_card.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final log = Logger("HomePage");

  HomePage({super.key});

  Widget selfWrappingCircularIndicator(){
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    controller.loadAssetManifest();
    controller.load();

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: Obx(() => NavigationRail(
              extended: controller.isExtend,
              selectedIndex: controller.currentPageIndex,
              leading: IconButton(
                icon: Icon(controller.isExtend ? Icons.arrow_back_ios : Icons.arrow_forward_ios),
                onPressed: controller.toggleExtend,
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red[400]),
                    onPressed: () => Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => FavoritesPage())
                              ),
                  ),
                ),
              ),

              onDestinationSelected: controller.setPageIndex,
              destinations: AppConfig.navList.map((e) => NavigationRailDestination(icon: Icon(e.icon), label: Text(e.label))).toList(),
            )),
          ),
          Expanded(
            child: Obx( () => 
              Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background/${controller.currentPageNav.type.toString().toLowerCase()}.png"),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                )
              ),
              padding: const EdgeInsets.all(4),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() => Text(
                          controller.currentPageNav.label,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 30,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      Obx(() => 
                        SearchBar(
                          controller: null,
                          onChanged: controller.setSearch,

                          leading: Obx(() => controller.isLoaded ? const Icon(Icons.search) : selfWrappingCircularIndicator()),
                          hintText: "Search ${controller.currentPageNav.label.toLowerCase()} by name",
                          constraints: const BoxConstraints(minHeight: 40, maxWidth: 400),
                        )
                      ),
                      const SizedBox(height: 10),
                      
                      Expanded(
                        child: Obx(() => controller.isLoaded ? GridView.extent(
                          maxCrossAxisExtent: 150,
                          padding: const EdgeInsets.all(4),
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          children: controller.pageRes?.results.map(
                            (e) => EntityCard(
                              title: e.name,
                              imgPath: controller.imageAssets[controller.currentPageNav.type]?[e.id],
                              defaultIcon: controller.currentPageNav.icon,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => e.createPage(controller.imageAssets[controller.currentPageNav.type]?[e.id]))
                              ),
                              isFavorite: controller.idIsFavorite(e.id),
                              onSetFavorite: ((){
                                controller.toggleFavourite(e);
                              }),
                            )).toList() ?? [],
                        ) : LayoutBuilder(
                          builder: (context, constraints) {
                            final double size = min(constraints.maxWidth * 0.5, 200);

                            return Center(
                              child: SizedBox(
                                width: size,
                                height: size,
                                child: const CircularProgressIndicator( strokeWidth: 10 )
                              )
                            );
                          }
                        )),
                      ),
                      Obx(() => 
                        Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          controller.pageRes?.previous != null ? IconButton(
                            onPressed: controller.prevPage,
                            color: Colors.blue,
                            icon: const Icon(Icons.arrow_back_ios),
                          ) : const SizedBox(),
                          Text(controller.pageNo.toString()),
                          controller.pageRes?.next != null ? IconButton(
                            onPressed: controller.nextPage,
                            color: Colors.blue,
                            icon: const Icon(Icons.arrow_forward_ios),
                          ) : const SizedBox()
                        ],
                      )
                      )
                    ],
                  );
                },
              ),
            )
            )
          )
        ],
      ),
    );
  }
}