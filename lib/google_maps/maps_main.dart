import 'package:flutter/material.dart';
import 'animate_camera.dart';
import 'map_ui.dart';
import 'move_camera.dart';
import 'page.dart';
import 'place_marker.dart';
import 'scrolling_map.dart';

// Ref: https://github.com/flutter/plugins/tree/master/packages/google_maps_flutter/example
// Follow https://github.com/flutter/plugins/tree/master/packages/google_maps_flutter
// and get an api key !!!
// Console at https://console.cloud.google.com/apis/dashboard
// https://console.cloud.google.com/apis/dashboard?folder&project=api-9111391984561677101-76037&organizationId&duration=P4D
// This is where I can see the credentials;
// https://console.cloud.google.com/google/maps-apis/apis/maps-android-backend.googleapis.com/credentials?project=api-9111391984561677101-76037&duration=P4D

final List<Page> _allPages = <Page>[
  MapUiPage(),
  AnimateCameraPage(),
  MoveCameraPage(),
  PlaceMarkerPage(),
  ScrollingMapPage(),
];

class MapsBigDemo extends StatelessWidget {
  void _pushPage(BuildContext context, Page page) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(page.title)),
          body: page,
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GoogleMaps examples')),
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) => ListTile(
          leading: _allPages[index].leading,
          title: Text(_allPages[index].title),
          onTap: () => _pushPage(context, _allPages[index]),
        ),
      ),
    );
  }
}
