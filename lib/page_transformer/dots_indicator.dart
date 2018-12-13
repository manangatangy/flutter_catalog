import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A dots indicator for a [PageView].
/// Prob looks rubbish unless PageView.scrollDirection is Axis.horizontal
///
class DotsIndicator extends AnimatedWidget {
  /// Creates a dots indicator. Provide the same [PageController] and
  /// itemCount that are used for the [PageView].  Optional callback
  /// for clicking a dot.
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onDotSelected,
    this.color = Colors.orange,
  }) : assert(controller != null),
        assert(itemCount != null),
        super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onDotSelected;

  /// The color of the dots.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (DotsIndicator._kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: DotsIndicator._kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: DotsIndicator._kDotSize * zoom,
            height: DotsIndicator._kDotSize * zoom,
            child: new InkWell(
              onTap: () => onDotSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
