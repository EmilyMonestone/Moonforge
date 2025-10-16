import 'package:flutter/material.dart';

/// UI Constants for the Sandi App
/// This file centralizes all UI-related constants like spacing, sizing, etc.
/// to ensure consistency across the app.

/// Spacing Constants
class Spacing {
  /// Standard spacing values
  static const double none = 0.0;
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  /// Common padding values
  static const EdgeInsets noneAll = EdgeInsets.all(none);
  static const EdgeInsets sAll = EdgeInsets.all(s);
  static const EdgeInsets mAll = EdgeInsets.all(m);
  static const EdgeInsets lAll = EdgeInsets.all(l);

  /// Common horizontal padding
  static const EdgeInsets sHorizontal = EdgeInsets.symmetric(horizontal: s);
  static const EdgeInsets mHorizontal = EdgeInsets.symmetric(horizontal: m);
  static const EdgeInsets lHorizontal = EdgeInsets.symmetric(horizontal: l);

  /// Common vertical padding
  static const EdgeInsets sVertical = EdgeInsets.symmetric(vertical: s);
  static const EdgeInsets mVertical = EdgeInsets.symmetric(vertical: m);
  static const EdgeInsets lVertical = EdgeInsets.symmetric(vertical: l);

  /// Common combined padding
  static const EdgeInsets sHorizontalMVertical = EdgeInsets.symmetric(
    horizontal: s,
    vertical: m,
  );
  static const EdgeInsets mHorizontalSVertical = EdgeInsets.symmetric(
    horizontal: m,
    vertical: s,
  );
  static const EdgeInsets lHorizontalMVertical = EdgeInsets.symmetric(
    horizontal: l,
    vertical: m,
  );

  /// Common directional padding
  static const EdgeInsets sBottom = EdgeInsets.only(bottom: s);
  static const EdgeInsets mBottom = EdgeInsets.only(bottom: m);
  static const EdgeInsets lBottom = EdgeInsets.only(bottom: l);
  static const EdgeInsets xlBottom = EdgeInsets.only(bottom: xl);

  static const EdgeInsets sLeft = EdgeInsets.only(left: s);
  static const EdgeInsets mLeft = EdgeInsets.only(left: m);

  static const EdgeInsets sRight = EdgeInsets.only(right: s);
  static const EdgeInsets mRight = EdgeInsets.only(right: m);

  static const EdgeInsets sTop = EdgeInsets.only(top: s);
  static const EdgeInsets mTop = EdgeInsets.only(top: m);
}

/// Sizing Constants
class Sizing {
  /// Standard width values
  static const double xxs = 40.0;
  static const double xs = 80.0;
  static const double s = 120.0;
  static const double m = 240.0;
  static const double l = 360.0;
  static const double xl = 480.0;
  static const double xxl = 600.0;

  /// Standard height values
  static const double xxsHeight = 20.0;
  static const double xsHeight = 40.0;
  static const double sHeight = 50.0;
  static const double mHeight = 60.0;
  static const double lHeight = 80.0;
  static const double xlHeight = 120.0;

  // Specific sizes
  static const double infoContainerWidth = (m * 2 + Spacing.m) + Spacing.m * 2;
}

/// Layout Constants
class Layout {
  /// Breakpoints for responsive design
  static const double kBreakpoint = 600.0;
}

/// Table Constants
class TableSizing {
  /// Column widths
  static const double kActionColumnWidth = 50.0;
  static const double kCheckboxColumnWidth = 50.0;
  static const double kFilterWidth = 250.0;
  static const double kFilterHeight = 40.0;

  /// Row heights
  static const double rowHeight = 50.0;

  /// Component heights
  static const double dataPagerHeight = 60.0;
  static const double searchFieldHeight = 50.0;
}

/// Window Constants
class WindowSizing {
  /// Window caption heights
  static const double kWindowCaptionHeight = 40.0;
  static const double kWindowCaptionHeightBig = 56.0;
}

/// Notification Constants
class NotificationConstants {
  /// Standard notification durations
  static const Duration shortDuration = Duration(seconds: 2);
  static const Duration defaultDuration = Duration(seconds: 4);
  static const Duration longDuration = Duration(seconds: 6);
  static const Duration veryLongDuration = Duration(seconds: 8);

  /// Special notification durations
  static const Duration errorDuration = longDuration;
  static const Duration warningDuration = longDuration;
  static const Duration successDuration = shortDuration;
  static const Duration infoDuration = shortDuration;

  /// Notification positions
  static const Alignment topRight = Alignment.topRight;
  static const Alignment topLeft = Alignment.topLeft;
  static const Alignment bottomRight = Alignment.bottomRight;
  static const Alignment bottomLeft = Alignment.bottomLeft;
  static const Alignment center = Alignment.center;
}
