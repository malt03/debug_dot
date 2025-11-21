# debug_dot

A Flutter package that provides a floating debug dot for easy access to development tools and debug options during app development.

## Features

- **Floating Debug Dot**: A draggable bug icon that floats on your app screen
- **Customizable Debug Menu**: Add your own debug menu items with custom actions
- **Easy Integration**: Simply wrap your app with the `DebugDot` widget

## Screenshots

<img src="https://raw.githubusercontent.com/malt03/debug_dot/refs/heads/main/screenshots/home.png" width="300" alt="Home Screen with Debug Dot"> <img src="https://raw.githubusercontent.com/malt03/debug_dot/refs/heads/main/screenshots/menu.png" width="300" alt="Debug Menu">

## Usage

### Basic Usage

Wrap your app with the `DebugDot` widget and provide a list of debug menu items:

```dart
import 'package:debug_dot/debug_dot.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const DebugDot(
      menus: [
        YourDebugMenuA(),
        YourDebugMenuB(),
        RemoveDebugDotDebugMenu(), // Built-in menu to remove the debug dot
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: MyHomePage(),
    );
  }
}
```

### Custom Debug Menu Items

Create custom debug menu items by extending the `DebugMenu` class:

```dart
class SnackBarDebugMenu extends DebugMenu {
  const SnackBarDebugMenu();

  @override
  DebugMenuInfo info(BuildContext context) {
    return const DebugMenuInfo(title: 'Show SnackBar', icon: Icons.message);
  }

  @override
  Route? onTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Debug message!')),
    );
    return null; // Return null for actions that don't navigate
  }
}

class DebugPageMenu extends DebugMenu {
  const DebugPageMenu();

  @override
  DebugMenuInfo info(BuildContext context) {
    return const DebugMenuInfo(title: 'Show Page', icon: Icons.pageview);
  }

  @override
  Route? onTap(BuildContext context) {
    return MaterialPageRoute(
      builder: (context) => DebugSettingsPage(),
    );
  }
}
```

## Development

This package is designed specifically for development and debugging purposes. Consider removing or conditionally including the debug dot in production builds:

```dart
Widget buildApp() {
  if (kDebugMode) {
    return DebugDot(
      menus: [...],
      child: MyApp(),
    );
  }
  return MyApp();
}
```
