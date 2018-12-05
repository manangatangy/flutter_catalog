import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidspend3/zoom_scaffold.dart';

class AnimatedMenuTitle extends ImplicitlyAnimatedWidget {
  final MenuState menuState;
  final Duration duration;

  AnimatedMenuTitle({
    this.menuState,
    this.duration,
    Curve curve,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimatedMenuTitleState createState() => _AnimatedMenuTitleState();
}

class _AnimatedMenuTitleState extends AnimatedWidgetBaseState<AnimatedMenuTitle> {
  final double closedPosition = -600.0;
  final double openPosition = -100.0;

  Tween<double> _translation;   // This is the thing that's being animated.

  @override
  void forEachTween(visitor) {
    var positionTarget = closedPosition;
    if (widget.menuState == MenuState.open || widget.menuState == MenuState.opening) {
      positionTarget = openPosition;
    }
    _translation = visitor(
      _translation,
      positionTarget,
          (dynamic value) => Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(
        -240.0,
        _translation.evaluate(animation),
        0.0,
      ),
      child: MenuTitle(),
    );
  }
}

class MenuTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi / 2.0,
      child: OverflowBox(
        // Renders beyond the screen real estate
        // Causes the rendering of the off-screen part of the text
        // which gets translated on screen to the left.
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Color(0x88444444),
              fontSize: 240.0,
              fontFamily: 'mermaid',
            ),
            textAlign: TextAlign.left,
            // Stops the text wrapping on to the next line
            softWrap: false,
          ),
        ),
      ),
    );
  }
}
