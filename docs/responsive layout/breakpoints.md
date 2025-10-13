# Breakpoints & Size Classes

Define consistent width breakpoints so your UI can switch among **phone, tablet, desktop** layouts.

## Recommended Breakpoints

- **Compact** (phone): `< 600`
- **Medium** (tablet): `600 – 1024`
- **Expanded** (desktop): `> 1024`

These values are pragmatic defaults. Adjust to your app’s density and design language.

## Size Class Helper

```dart
enum SizeClass { compact, medium, expanded }

class AppBreakpoints {
  static const double compactMax = 600;
  static const double mediumMax  = 1024;
}

extension AppSizeClass on SizeClass {
  static SizeClass fromWidth(double width) {
    if (width < AppBreakpoints.compactMax) return SizeClass.compact;
    if (width < AppBreakpoints.mediumMax)  return SizeClass.medium;
    return SizeClass.expanded;
  }
}
```

## How to Branch Layouts

```dart
Widget build(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  final size  = AppSizeClass.fromWidth(width);

  switch (size) {
    case SizeClass.compact:   return PhoneScaffold(...);
    case SizeClass.medium:    return TabletScaffold(...);
    case SizeClass.expanded:  return DesktopScaffold(...);
  }
}
```

### Notes
- **Orientation**: target **portrait** on phones; tablets/desktops usually have enough width regardless of orientation.
- **Alternative**: use `LayoutBuilder`’s `constraints.maxWidth` if you need a local breakpoint within a subtree.