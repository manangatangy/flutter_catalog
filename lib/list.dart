import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidspend3/zoom_scaffold.dart';

class ListDemoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter List Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListWidget(title: 'Flutter Demo Home Page'),
    );
  }
}

class MenuParent extends InheritedWidget {

  final MenuController _menuController;

  const MenuParent({
    Key key,
    MenuController menuController,
    Widget child,
  }) : this._menuController = menuController,
        super(key: key, child: child);

  get menuState => _menuController.state;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static MenuParent of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(MenuParent);
}


class ListWidget extends StatefulWidget {
  ListWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ListWidgetState createState() => new _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 200.0,
  );

  List<Widget> _items = new List.generate(40, (index) {
    return Container(
      color: (index % 2) == 0 ? Colors.red : Colors.blue,
      padding: EdgeInsets.all(10.0),
      child: Text("xxx item ${index}"),
    );
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.arrow_downward),
        onPressed: () {
//          setState(() {
//            _items.add(
//                Container(
//                  padding: EdgeInsets.all(10.0),
//                    child: Text("xxx item ${_items.length}"),
//                )
//            );
//          });
          _scrollController.jumpTo(
            0.0,
//            _scrollController.position.maxScrollExtent / 2.0,
//            duration: const Duration(milliseconds: 300),
//            curve: Curves.easeOut,
          );
        },
      ),
      body: new CustomScrollView(
        controller: _scrollController,
        slivers: [
          new SliverAppBar(
            title: new Text('Sliver App Bar'),
          ),
          new SliverList(
            delegate: new SliverChildBuilderDelegate(
                  (context, index) => _items[index],
              childCount: _items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemWidget extends StatefulWidget {
  final int index;

  ItemWidget({
    this.index,
  });

  @override
  _ItemWidgetState createState() => new _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: (widget.index % 2) == 0 ? Colors.red : Colors.blue,
      padding: EdgeInsets.all(10.0),
      child: Text("xxx item ${widget.index}"),
    );
  }
}
