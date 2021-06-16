import 'package:flutter/material.dart';

class FormFactorBreakpoints {
  static double desktop = 900;
  static double tablet = 600;
  static double handset = 300;
}

enum FormFactor { Desktop, Tablet, Handset, Watch }

extension ContextExtensions on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  Orientation get screenOrientation => mediaQuery.orientation;

  bool get screenIsLandscape => mediaQuery.orientation == Orientation.landscape;

  bool get screenIsPortrait => mediaQuery.orientation == Orientation.portrait;

  FormFactor get formFactor {
    // Use .shortestSide to detect device type regardless of orientation
    final deviceWidth = MediaQuery.of(this).size.shortestSide;
    if (deviceWidth > FormFactorBreakpoints.desktop) return FormFactor.Desktop;
    if (deviceWidth > FormFactorBreakpoints.tablet) return FormFactor.Tablet;
    if (deviceWidth > FormFactorBreakpoints.handset) return FormFactor.Handset;
    return FormFactor.Watch;
  }

  void closeKeyboard() => FocusScope.of(this).requestFocus(FocusNode());

  /// Push the given route onto the navigator.
  void pushRoute(
    Route route, {
    closeKeyboard = true,
    bool avoidDuplicateRoute = true,
  }) {
    if (closeKeyboard) this.closeKeyboard();

    if (avoidDuplicateRoute && route.isCurrent) {
      print(
          'INFO: New route is not pushed because it is already the current route!');
    } else {
      Navigator.of(this).push<void>(route);
    }
  }

  /// Push the given page onto the navigator.
  void pushPage(
    Widget page, {
    closeKeyboard = true,
    bool avoidDuplicatePage = true,
  }) {
    pushRoute(
      MaterialPageRoute(builder: (context) => page),
      closeKeyboard: closeKeyboard,
      avoidDuplicateRoute: avoidDuplicatePage,
    );
  }

  /// Pop the top-most route off the navigator and close the keyboard.
  void popPage() {
    closeKeyboard();
    Navigator.of(this).pop();
  }

  /// Whether the navigator can be popped.
  bool canPopPage() => Navigator.of(this).canPop();
}
