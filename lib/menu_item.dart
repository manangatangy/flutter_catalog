import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kidspend3/zoom_scaffold.dart';

// Now lets wrap each list item in an animator
// Change 'extends StatefulWidget' to ImplicitlyAnimatedWidget and
// also change 'extends State<' to AnimatedWidgetBaseState which requires
// implementing method forEachTween.   An ImplicitlyAnimatedWidget says
// 'something about me can be animated', ie some value can change.
// So we bring in the properties we're going to need.  This widget will
// wrap a menuListItem

class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {
  final Widget menuListItem;

  // Also need to know if we're sliding up/down etc, and what the duration should be
  final MenuState menuState;
  final Duration duration;
  final bool isSelected;

  AnimatedMenuListItem({
    this.menuState,
    this.menuListItem,
    this.duration,
    this.isSelected,
    curve,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimatedMenuListItemState createState() => new _AnimatedMenuListItemState();
}

class _AnimatedMenuListItemState
    extends AnimatedWidgetBaseState<AnimatedMenuListItem> {
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;

  // Animating two things
  Tween<double> _translation;
  Tween<double> _opacity;

  // The render tree is a long-lived structure that performs the writes to
  // the screen.  Cf. the widget tree which is short-lived.

  @override
  void forEachTween(visitor) {
    var slideTarget, opacityTarget;

    switch (widget.menuState) {
      case MenuState.closing:
      case MenuState.closed:
      // Set the slide/opacity 'goals'
        slideTarget = closedSlidePosition;
        opacityTarget = 0.0;
        break;
      case MenuState.open:
      case MenuState.opening:
        slideTarget = openSlidePosition;
        opacityTarget = 1.0;
        break;
    }
    // Adjust the tweens,
    _translation = visitor(
      _translation,
      slideTarget,
          (dynamic value) => Tween<double>(begin: value),
    );
    _opacity = visitor(
      _opacity,
      opacityTarget,
          (dynamic value) => Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Opacity(
          opacity: _opacity.evaluate(animation),
          child: Container(
            width: 5.0,
            height: 100.0 + 8.0 + 8.0,
            // The selection indicator is shown if the item is selected.
            color: widget.isSelected ? Colors.red : Colors.transparent,
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            _translation.evaluate(animation),
            0.0,
            0.0,
          ),
          child: widget.menuListItem,
        ),
      ],
    );
  }
}

class MenuListItem extends StatelessWidget {
  final String title;
  final ImageProvider imageProvider;
  final bool isSelected;
  final Function() onTap;
  final MenuState menuState;

  MenuListItem({
    this.title,
    this.imageProvider,
    this.isSelected,
    this.onTap,
    this.menuState,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      // The ink is drawn on the Material, which must therefore be in
      // front of the background image
      splashColor: Color(0x44000000),
      onTap: onTap,
      child: Container(
        // Put the menu item in a full width contained so that the full width is clickable
        // The width was previously double.infinity, however this conflicted with having a
        // parent Row for holding the selection-indicator, so reset with to screen width.
        width: screenWidth - 5.0,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 8.0, bottom: 8.0),
              // The image is show either if the item is not selected or it
              // the menu state is fully open (ie, animated has stopped).
              child: !isSelected || menuState == MenuState.open ? Image(
                image: imageProvider,
                fit: BoxFit.cover,
                width: 100.0,
                height: 100.0,
              ) : Container(
                width: 100.0,
                height: 100.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.red : Colors.white,
                  fontSize: 25.0,
                  fontFamily: 'bebas-neue',
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
