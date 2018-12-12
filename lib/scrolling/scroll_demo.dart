// ref for SliverAppBar:
// https://docs.flutter.io/flutter/material/SliverAppBar-class.html
// https://medium.com/flutter-io/slivers-demystified-6ff68ab0296f
// refs for PageView:
// https://docs.flutter.io/flutter/widgets/PageView-class.html
// https://iirokrankka.com/2017/09/23/bringing-the-pagetransformer-from-android-to-flutter/


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScrollDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScrollDemoPage(),
    );
  }
}

class ScrollDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,

              title: Text("Collapsing Toolbar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),

              background: Image.network(
                "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                fit: BoxFit.cover,
              ),
            ),
          ),


          // Should use SliverFixedExtentList because more efficient
//          SliverFixedExtentList(
//            itemExtent: 150.0,
//            delegate: SliverChildListDelegate(
//              [
//                Container(color: Colors.red),
//                Container(color: Colors.purple),
//                Container(color: Colors.green),
//                Container(color: Colors.orange),
//                Container(color: Colors.yellow),
//                Container(color: Colors.pink),
//              ],
//            ),
//          ),

          SliverList(
            delegate: new SliverChildListDelegate(
              List.generate(50, (index) =>
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('item number $index'),
                  )),
            ),
          ),


//        SliverPersistentHeader(
//          pinned: true,
//          floating: false,
//          delegate: HeroHeader(
//            layoutGroup: layoutGroup,
//            onLayoutToggle: onLayoutToggle,
//            minExtent: 100.0,
//            maxExtent: 350.0,
//          ),
//        ),

        ],
      ),
    );
  }

}

