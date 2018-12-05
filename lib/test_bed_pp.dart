import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math';
import 'package:sticky_headers/sticky_headers.dart';
import 'dart:async';

//void main() => runApp(TestBedApp());

class TestBedApp extends StatelessWidget {
  final appTitle = 'My testbed app';
  final appRoutes = <String, WidgetBuilder>{
    SandyShores.routeName: (BuildContext context) => SandyShores(),
    Logo4App.routeName: (BuildContext context) => Logo4App(),
    Logo5App.routeName: (BuildContext context) => Logo5App(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: HomePage(title: appTitle),
      routes: appRoutes,
    );
  }
}

class SandyShores extends StatelessWidget {
  static final routeName = '/SandyShores';
  @override
  Widget build(BuildContext context) {
    return new Container(
        child: Center(
          child: Text("You've landed on Sandy Shores"),
        )
    );
  }
}

class SpinningHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20.0,
      child: GestureDetector(
          child: ImageIcon(
              AssetImage("assets/alogo_claire_white.png")
          ),
          onTap: () {
            Scaffold.of(context).openDrawer();
          }
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
//            leading: ImageIcon(
//                AssetImage("assets/alogo_claire_white.png")
//            ),
            title: Text(title),
          ),
          drawer: StatefulDrawer(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('Expandable List'),
                  color: Colors.orange,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          HeaderPage(title: 'Expandable'))),
                ),
                SizedBox(height: 8.0),
                RaisedButton(
                  child: Text('Sticky List'),
                  color: Colors.orange,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          HeaderPage(title: 'Sticky'))),
                ),
                SizedBox(height: 8.0),
                RaisedButton(
                    child: Text(Logo5App.routeName),
                    color: Colors.orange,
                    onPressed: () {
                      Navigator.pushNamed(context, Logo5App.routeName);
                    }
                ),
                SizedBox(height: 8.0),
                RaisedButton(
                    child: Text(Logo4App.routeName),
                    color: Colors.orange,
                    onPressed: () {

                      var state = GlobalKey<DrawerControllerState>().currentState.toString();
                      print("state=$state");

                      Navigator.pushNamed(context, Logo4App.routeName);
                    }
                ),
              ],
            ),
          ),
        ),
        SpinningHome(),
      ],
    );
  }
}

class StatefulDrawer extends StatefulWidget {
  @override
  _StatefulDrawerState createState() => new _StatefulDrawerState();
}

class _StatefulDrawerState extends State<StatefulDrawer> {
  final _someKey = GlobalKey<DrawerControllerState>();

  @override
  Widget build(BuildContext context) {
    print("state=${_someKey.currentState}");

    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Header'),
              decoration: BoxDecoration(
                color:  Colors.lightBlue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings_backup_restore),
              title: Text(SandyShores.routeName),
              onTap: () {
                Navigator.popAndPushNamed(context, SandyShores.routeName);
              },
            ),
            ListTile(
              title: Text(Logo5App.routeName),
              onTap: () {
                Navigator.popAndPushNamed(context, Logo5App.routeName);
              },
            ),
          ],
        )
    );
  }
}

class HeaderPage extends StatelessWidget {
  final title;

  const HeaderPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: title == 'Expandable' ? ExpandableList() : StickyList(),
    );
  }
}

class ExpandableList extends StatelessWidget {
  final list = List.generate(10, (i) => 'Item $i');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, i) =>
          ExpansionTile(
            title: Text('Header. $i'),
            children: list.map((val) =>
                ListTile(
                  title: Text(val),
                )).toList(),
          ),
      itemCount: 5,
    );
  }
}

class StickyList extends StatelessWidget {
  final list = List.generate(10, (i) => 'Item $i');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, i) =>
          StickyHeader(
            overlapHeaders: true,
            header: DecoratedBox(
              child: Text('Header $i'),
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent
              ),
            ),
            content: Column(
              children: list.map((val) =>
                  ListTile(
                      title: Text(val)
                  )).toList(),
            ),
          ),
      itemCount: 5,
    );
  }
}

Future<bool> confirmDialog1(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Are you sure?'),
          actions: <Widget>[
            new FlatButton(
              child: const Text('YES'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            new FlatButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      });
}

// ------------------------------
class Logo4Widget extends StatelessWidget {
  // Leave out the height and width so it fills the animating parent
  build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Image.asset("assets/alogo_claire_white.png"),
//        child: FlutterLogo()
    );
  }
}

class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            return Container(
                height: animation.value,
                width: animation.value,
                child: Image.asset("assets/alogo_claire_white.png"));
          },
          child: child),
    );
  }
}

class Logo4App extends StatefulWidget {
  static final routeName = '/GrowingImage';

  _Logo4AppState createState() => _Logo4AppState();
}

class _Logo4AppState extends State<Logo4App> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this
    );
    final CurvedAnimation curve = CurvedAnimation(
        parent: controller, curve: Curves.easeIn
    );
    animation = Tween(begin: 0.0, end: 300.0).animate(curve);
    controller.forward();
  }

  Widget build(BuildContext context) {
    return GrowTransition(child: Logo4Widget(), animation: animation);
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

// ------------------------------
class AnimatedLogo extends AnimatedWidget {
  // Make the Tweens static because they don't change.
  static final _angleTween = Tween<double>(begin: 0.0, end: pi*2);
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1.0);
  static final _sizeTween = Tween<double>(begin: 50.0, end: 300.0);

  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Stack(
      children: <Widget>[
        Positioned(
          top: 10.0,
          left: 10.0,
          child: Transform.rotate(
            angle: _angleTween.evaluate(animation),
            child: Opacity(
              opacity: 1.0,
//          opacity: _opacityTween.evaluate(animation),
              child: Container(
//            margin: EdgeInsets.symmetric(vertical: 10.0),
                height: _sizeTween.evaluate(animation),
                width: _sizeTween.evaluate(animation),
                child: Image.asset("assets/alogo_claire_white.png"),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Logo5App extends StatefulWidget {
  static final routeName = '/SpinningGrowingImage';

  _Logo5AppState createState() => _Logo5AppState();
}

class _Logo5AppState extends State<Logo5App> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  Widget build(BuildContext context) {
    return AnimatedLogo(animation: animation);
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}
