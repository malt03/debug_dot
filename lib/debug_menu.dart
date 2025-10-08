import 'debug_app.dart';
import 'debug_dot.dart';
import 'package:flutter/material.dart';

abstract class DebugMenu {
  const DebugMenu();

  String get title;
  IconData? get icon => null;

  Route? onTap(BuildContext context) => null;
}

class RemoveDebugDotDebugMenu extends DebugMenu {
  @override
  String get title => 'Remove Debug Dot';
  @override
  IconData? get icon => Icons.delete_forever;

  const RemoveDebugDotDebugMenu();

  @override
  Route? onTap(BuildContext context) {
    DebugApp.of(context).close();
    DebugDot.of(context).removeDebugDot();
    return null;
  }
}
