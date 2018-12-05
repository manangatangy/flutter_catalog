import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kidspend3/menu.dart';
import 'package:kidspend3/menu_title.dart';
import 'package:kidspend3/menu_item.dart';
import 'package:kidspend3/zoom_scaffold.dart';

final menuScreenKey = GlobalKey(debugLabel: 'MenuScreen');

class MenuScreen extends StatefulWidget {
  final MenuController menuController;
  final String selectedItemId;
  final Function(String) onMenuItemSelected;
  final List<MenuItem> menuItems;

  MenuScreen({
    this.menuController,
    this.selectedItemId,
    this.onMenuItemSelected,
    this.menuItems,
    // By providing a key to the ctor, we can then ask to fetch the
    // state object associated with that key. This is allowed because
    // no other widget may have this key.
  }) : super(key: menuScreenKey);

  @override
  _MenuScreenState createState() => new _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  AnimationController titleAnimationController;

  @override
  void initState() {
    super.initState();
    titleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    titleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/dark_grunge_bk.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        // Background of material must be transparent so that the ink can be seen
        color: Colors.transparent,
        child: Stack(
          children: [
            createMenuTitle(widget.menuController),
            createMenuItems(widget.menuController, widget.menuItems),
          ],
        ),
      ),
    );
  }

  createMenuTitle(MenuController menuController) {
    return AnimatedMenuTitle(
      menuState: menuController.state,
      duration: Duration(
        milliseconds: 1000,
      ),
      curve: Curves.bounceOut,
    );
  }

  createMenuTitleUsingAnimatedBuilder(MenuController menuController) {
    switch (menuController.state) {
      case MenuState.open:
      case MenuState.opening:
        titleAnimationController.forward();
        break;
      case MenuState.closed:
      case MenuState.closing:
        titleAnimationController.reverse();
        break;
    }
    // Instead of returning the built widget, return a builder.
    return AnimatedBuilder(
        animation: titleAnimationController,
        // This child is the static definition of the menu-title and it will
        // be animated by the builder method.
        child: MenuTitle(),
        // The builder function will be run every time the animation changes.
        // The child passed to this builder is the child field of the
        // AnimatedBuilder
        builder: (BuildContext context, Widget child) {
          return Transform(
            transform: Matrix4.translationValues(
              // -80.0 is the offset to the left
              -240.0,
              -100 + 500.0 * (titleAnimationController.value - 1.0),
              0.0,
            ),
            child: child,
          );
        });
  }

  Interval incrementedInterval(int index, double incr) {
    var begin = 0.3 + index * incr;
    var end = begin + 0.2;
    return Interval(begin, end > 1.0 ? 1.0 : end, curve: Curves.easeOut);
  }

  createMenuItems(MenuController menuController, List<MenuItem> menuItems) {
    final incr = 0.5 / menuItems.length;
    return Padding(
      // The origin here is below the system status bar
      padding: EdgeInsets.only(top: 200.0),
      child: ListView(
        controller: widget.menuController.scrollController,
        children: Iterable.generate(
            menuItems.length,
                (int index) =>
                AnimatedMenuListItem(
                  menuState: menuController.state,
                  isSelected: menuItems[index].id == widget.selectedItemId,
                  duration: Duration(
                    milliseconds: menuController.state == MenuState.closing ? 200 : 600,
                  ),
                  curve: menuController.state == MenuState.closing
                      ? Curves.easeIn
                      : incrementedInterval(index, incr),
                  menuListItem: MenuListItem(
                      title: menuItems[index].title,
                      imageProvider: menuItems[index].imageProvider,
                      isSelected: menuItems[index].id == widget.selectedItemId,
                      menuState: menuController.state,
                      onTap: () {
                        widget.onMenuItemSelected(menuItems[index].id);
                        menuController.close();
                      }),
                ))
            .toList(),
      ),
    );
  }
}

