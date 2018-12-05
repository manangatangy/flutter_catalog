import 'package:flutter_catalog/blurry_artist/data/models.dart';

class MockData {
  static final Artist andy = new Artist(
    firstName: 'Andy',
    lastName: 'Fraser',
    avatar: 'assets/avatar.png',
    backdropPhoto: 'assets/backdrop.png',
    location: 'London, England',
    biography: 'Andrew McLan "Andy" Fraser was an English songwriter and bass '
        'guitarist whose career lasted over forty years, and includes two spells '
        'as a member of the rock band Free, which he helped found in 1968, aged 15.',
    videos: <Video>[
      new Video(
        title: 'Free - Mr. Big - Live at Granada Studios 1970',
        thumbnail: 'assets/video1_thumb.png',
        url: 'https://www.youtube.com/watch?v=_FhCilozomo',
      ),
      new Video(
        title: 'Free - Ride on a Pony - Live at Granada Studios 1970',
        thumbnail: 'assets/video2_thumb.png',
        url: 'https://www.youtube.com/watch?v=EDHNZuAnBoU',
      ),
      new Video(
        title: 'Free - Songs of Yesterday - Live at Granada Studios 1970',
        thumbnail: 'assets/video3_thumb.png',
        url: 'https://www.youtube.com/watch?v=eI1FT0a_bos',
      ),
      new Video(
        title: 'Free - I\'ll Be Creepin\' - Live at Granada Studios 1970',
        thumbnail: 'assets/video4_thumb.png',
        url: 'https://www.youtube.com/watch?v=3qK8O3UoqN8',
      ),
    ],
  );
}
