export 'debug_menu.dart';
export 'debug_dot_view.dart' show DebugDotPosition;

import 'debug_app.dart';
import 'debug_dot_view.dart';
import 'debug_menu.dart';
import 'package:flutter/widgets.dart';

class DebugDot extends StatefulWidget {
  final List<DebugMenu> menus;
  final DebugDotPosition initialPosition;
  final EdgeInsets padding;
  final IconData? closeIcon;
  final Widget child;

  const DebugDot({
    super.key,
    required this.menus,
    required this.child,
    this.initialPosition = DebugDotPosition.bottomRight,
    this.padding = const EdgeInsets.all(80),
    this.closeIcon,
  });

  static DebugDotState of(BuildContext context) {
    final state = context.findAncestorStateOfType<DebugDotState>();
    assert(state != null, 'No DebugDotState found in context');
    return state!;
  }

  @override
  State<DebugDot> createState() => DebugDotState();
}

class DebugDotState extends State<DebugDot> {
  final _overlayKey = GlobalKey<OverlayState>();
  OverlayEntry? _debugDotEntry;
  OverlayEntry? _debugAppEntry;

  IconData? get closeIcon => widget.closeIcon;

  OverlayState _overlayState() {
    final overlay = _overlayKey.currentState;
    assert(overlay != null, 'No OverlayState found in context');
    return overlay!;
  }

  void showDebugDot() {
    final entry = OverlayEntry(
      builder: (_) => DebugDotView(menus: widget.menus, initialPosition: widget.initialPosition, padding: widget.padding),
    );
    _overlayState().insert(entry);
    _debugDotEntry = entry;
  }

  void removeDebugDot() {
    _debugDotEntry?.remove();
    _debugDotEntry = null;
  }

  void showDebugApp() {
    final entry = OverlayEntry(builder: (context) => DebugApp(menus: widget.menus));
    _overlayState().insert(entry);
    _debugAppEntry = entry;
  }

  void removeDebugApp() {
    _debugAppEntry?.remove();
    _debugAppEntry = null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDebugDot();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        key: _overlayKey,
        initialEntries: [OverlayEntry(builder: (_) => widget.child)],
      ),
    );
  }
}
