import 'package:flutter_catalog/blurry_artist/ui/artist_details_animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ref: https://iirokrankka.com/2018/03/14/orchestrating-multiple-animations-into-visual-enter-animation/

class BlurryArtistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new ArtistsDetailsAnimator(),
    );
  }
}
