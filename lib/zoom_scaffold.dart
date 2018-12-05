import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ZoomScaffold extends StatefulWidget {
  final ImageProvider leadingImageProvider;
  final int leadingImageListIndex;
  final ZoomScaffoldBuilder menuScreenBuilder;
  final Screen contentScreen;

  ZoomScaffold({
    this.leadingImageProvider,
    this.leadingImageListIndex,
    this.menuScreenBuilder,
    this.contentScreen,
  });

  @override
  _ZoomScaffoldState createState() => new _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold> with TickerProviderStateMixin {

  bool isClosed = false;

  MenuController menuController;
  // Use non-linear curves, with the down curve making all
  // the change before 0.3
  Curve scaleDownCurve = Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = Interval(0.0, 0.7, curve: Curves.easeOut);
  Curve slideInCurve = Interval(0.0, 1.0, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();
    menuController = MenuController(
      vsync: this,
    )
    ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    menuController.dispose();   // deregister the listeners
    super.dispose();
  }

  createLeadingIcon() {
    return spinZoomAndSlideLeadingImage(
      widget.leadingImageProvider,
      widget.leadingImageListIndex,
    );
  }

  createContentDisplay() {
    return zoomAndSlideContent(
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: widget.contentScreen.backgroundImage,
              colorFilter: new ColorFilter.mode(
                Colors.blue.withOpacity(0.7),
                BlendMode.darken,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 40.0,
                  left: 160.0,
                  child: Text(
                    widget.contentScreen.title,
                    style: TextStyle(
                      fontFamily: 'bebas-neue',
                      fontSize: 25.0,
                    ),
                  )
              ),
              widget.contentScreen.contentBuilder(context),
            ],
          ),
        )
    );
  }

  zoomAndSlideContent(Widget content) {
    // Use non-linear curves
    var slidePercent, scalePercent;
    switch (menuController.state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(menuController.percentOpen);
        scalePercent = scaleDownCurve.transform(menuController.percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(menuController.percentOpen);
        break;
    }

    // Slides to the right, when opening menu
    // These animations are now curved
    final slideAmount = 350.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius = 10.0 * menuController.percentOpen;

    // When closed, use un-transformed content.
    return Transform(
      transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: Container(
        // Shadow around the content
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0x44000000),
              offset: const Offset(0.0, 5.0),
            ),
          ],
        ),
        child: ClipRRect(
          // Rounded corners on the content
            borderRadius: BorderRadius.circular(cornerRadius),
            child: content
        ),
      ),
    );
  }

  spinZoomAndSlideLeadingImage(ImageProvider imageProvider, int imageListIndex) {
    final listOffsetY = menuController.scrollController.hasClients ? menuController.scrollController.offset : 0.0;

    // The origin here is from above the system status bar !
    // This is 24.0 from the origin of the mane list
    // Spins and slides downwards when opening menu
    final closeSize = 50.0;
    final openSize = 100.0;       // from menu_screen.dart:123

    final closeOffsetX = 10.0;     // Position in the app-bar
    final openOffsetX = 20.0;      // from menu_screen.dart
    // Add an extra 25 above so I can see where it is (must also have isVis forced true below)
    final closeOffsetY = 30.0;    // Position in the app-bar
    // TBD - from menu item number
    // The 8.0 values are the padding top and bottom of list items
    final openOffsetY = 208.0 + 24.0 + imageListIndex * (8.0 + 100.0 + 8.0)
        - listOffsetY;

    final imageSize = closeSize + (openSize - closeSize) * menuController.percentOpen;

    final slideAmountX = closeOffsetX + (openOffsetX - closeOffsetX) * menuController.percentOpen;
    final slideAmountY = closeOffsetY + (openOffsetY - closeOffsetY) * menuController.percentOpen;
    final spinAngle = 2 * pi * menuController.percentOpen;

    // When closed, use un-transformed content.
    // When open, widget is effectively gone
    bool isVis = menuController.state != MenuState.open;
    return isVis ? Transform(
      transform: Matrix4.translationValues(
          slideAmountX ,
          slideAmountY,
          0.0,
      )
        ..rotateZ(spinAngle),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          menuController.toggle();
        },
        child: Image(
          image: imageProvider,
          fit: BoxFit.cover,
          width: imageSize,
          height: imageSize,
        ),
      ),
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    // This essentially build the entire scaffold.
    // It is all assembled under a ZoomScaffoldMenuController, which says
    // find me a MenuController from under the state widget, and pass it into
    // the builder function, which will then pass it on to the menu screen,
    // which now needs to be a builder also.

    // Need a material to prevent yellow underlined content
    // https://stackoverflow.com/a/49967268/1402287
    return ZoomScaffoldMenuController(
      builder: (BuildContext context, MenuController menuController) => Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            widget.menuScreenBuilder(context, menuController),
            createContentDisplay(),
            createLeadingIcon(),
          ],
        ),
      ),
    );
  }
}

// This class allows the MenuScreen to 'know'it's in the ZoomScaffold
// and 'reach up' to access the MenuController.
class ZoomScaffoldMenuController extends StatelessWidget {
  final ZoomScaffoldBuilder builder;

  // Whoever calls this method is saying that somewhere above them in the
  // widget tree is a _ZoomScaffoldState.
  getMenuController(BuildContext context) {
    final scaffoldState = context.ancestorStateOfType(
      TypeMatcher<_ZoomScaffoldState>()
    ) as _ZoomScaffoldState;
    return scaffoldState.menuController;
  }

  ZoomScaffoldMenuController({
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, getMenuController(context));
  }
}

// Maybe need a ZoomScaffoldMenuControllerState and make ZoomScaffoldMenuController
// into a Stateful widget ?
// The state holds a MenuController, fetched in initState() using getMenuController
// and then a listener is added (also removed in dispose) and the listener
// simply calls setState.  This means that every time the menuController changes/
// it forces the ZoomScaffoldMenuController to rerun its build function
// which will rerun our builder.


// There's a function that takes in a BuildContext and a MenuController
// and it returns a Widget.  The menu system will provide one of these
// anonymous functions, and returns the Widget to be used as the menu screen.
typedef Widget ZoomScaffoldBuilder(
  BuildContext context,
  MenuController menuController,
);

class Screen {
  final String title;
  final AssetImage backgroundImage;
  final WidgetBuilder contentBuilder;

  Screen({
    this.title,
    this.backgroundImage,
    this.contentBuilder,
  });
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;

  // this replaces the percentOpen field but we still need a getter for it
  final AnimationController _animationController;
  MenuState state = MenuState.closed;
  // Used for menu list control
  ScrollController scrollController = new ScrollController();

  MenuController({
    this.vsync,
  }) : _animationController = AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 500)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        // each AnimationStatus correspond to a controller state
        switch (status) {
          case AnimationStatus.forward: // just started from 0.0
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse: // just started from reverse at 1.0
            state = MenuState.closing;
            break;
          case AnimationStatus.completed: // just reached 1.0
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed: // just reached 0.0 from reverse
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
//    state = MenuState.open;
//    percentOpen = 1.0;
//    notifyListeners();
  }

  close() {
    _animationController.reverse();
//    state = MenuState.closed;
//    percentOpen = 0.0;
//    notifyListeners();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }

}
enum MenuState {
  closed,
  opening,
  open,
  closing,
}