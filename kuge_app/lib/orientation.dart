import 'package:flutter/material.dart';

extension OrientationContext on BuildContext {
  ///
  /// check current application orientation is landscape.
  ///
  bool get isLandscape => MediaQuery.of(this).isLandscape;
  bool get isPortrait => !isLandscape;
  
  NavigatorState get rootNavigator => Navigator.of(this, rootNavigator: true);
  NavigatorState get primaryNavigator =>  Navigator.of(this);
  NavigatorState get secondaryNavigator =>  Navigator.of(this);
}

extension _MediaData on MediaQueryData {
  bool get isLandscape => orientation == Orientation.landscape;
}
