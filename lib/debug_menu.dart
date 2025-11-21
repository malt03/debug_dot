import 'debug_app.dart';
import 'debug_dot.dart';
import 'package:flutter/material.dart';

class DebugMenuInfo {
  final String title;
  final IconData? icon;

  const DebugMenuInfo({required this.title, this.icon});
}

abstract class DebugMenu {
  const DebugMenu();

  DebugMenuInfo info(BuildContext context);

  Route? onTap(BuildContext context) => null;
}

class RemoveDebugDotDebugMenu extends DebugMenu {
  const RemoveDebugDotDebugMenu();

  @override
  DebugMenuInfo info(BuildContext context) {
    return const DebugMenuInfo(title: 'Remove Debug Dot');
  }

  @override
  Route? onTap(BuildContext context) {
    DebugApp.of(context).close();
    DebugDot.of(context).removeDebugDot();
    return null;
  }
}
