import 'package:debug_dot/debug_dot.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const DebugDot(
      menus: [
        // _DummyDebugMenu('UserID: 12345', Icons.person),
        // _DummyDebugMenu('Environment: Staging1', Icons.cloud),
        // _DummyDebugMenu('Version: 1.0.1', Icons.info),
        _SnackBarDebugMenu(), _ShowPageDebugMenu(), RemoveDebugDotDebugMenu(),
      ],
      child: _App(),
    ),
  );
}

// class _DummyDebugMenu extends DebugMenu {
//   @override
//   final String title;
//   @override
//   final IconData? icon;

//   const _DummyDebugMenu(this.title, this.icon);
// }

class _SnackBarDebugMenu extends DebugMenu {
  @override
  String get title => 'Show SnackBar';
  @override
  IconData? get icon => Icons.message;

  const _SnackBarDebugMenu();

  @override
  Route? onTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('This is a SnackBar')));
    return null;
  }
}

class _ShowPageDebugMenu extends DebugMenu {
  @override
  String get title => 'Show Page';

  const _ShowPageDebugMenu();

  @override
  Route? onTap(BuildContext context) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: Text('Debug Sub Page')),
        body: Center(child: Text('This is a page opened from Debug Menu.')),
      ),
    );
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Debug Dot Example', home: const _HomePage());
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debug Dot Example')),
      body: Center(child: Text('Hello, World!')),
    );
  }
}
