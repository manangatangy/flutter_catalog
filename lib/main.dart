import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_catalog/blurry_artist/blurry_artist.dart';
import 'package:flutter_catalog/google_maps/maps_main.dart';
import 'package:flutter_catalog/google_maps/simple_map.dart';
import 'package:flutter_catalog/zoom_menu/zoom_app.dart';

void main() {
  runApp(MaterialApp(
    home: AppHome(), // becomes the route named '/'
    // Neat trick to convert a list into a map
    // ref: https://stackoverflow.com/a/21306450/1402287
    routes: Map.fromIterable(catalogEntries, key: (v) => v[0], value: (v) => v[1]),
  ));
}

class CatalogEntry {
  String title;
  WidgetBuilder builder;
  
  CatalogEntry(
    this.title,
    this.builder,
  );
  // ref: https://stackoverflow.com/a/19643821/1402287
  operator [](int i) => (i == 0) ? title : builder;
}

final catalogEntries = [
  CatalogEntry('/ZoomMenuApp', (BuildContext context) => ZoomMenuApp()),
  CatalogEntry('/BlurryArtistApp', (BuildContext context) => BlurryArtistApp()),
  CatalogEntry('/SimpleMapApp', (BuildContext context) => SimpleMapApp()),
  CatalogEntry('/MapsBigDemo', (BuildContext context) => MapsBigDemo()),
];

class AppHome extends StatelessWidget {

  // ref: https://flutter.io/docs/development/ui/navigation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("David's Flutter Catalog")),
      body: ListView(
        children: List.generate(catalogEntries.length, (index) =>
            ListTile(
              title: Text(catalogEntries[index].title),
              onTap: () => Navigator.pushNamed(context, catalogEntries[index].title),
            )
        ),
      ),
    );
  }

}
