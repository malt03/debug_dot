import 'debug_dot.dart';
import 'debug_page.dart';
import 'package:flutter/material.dart';

typedef MaterialAppBuilder = Widget Function(BuildContext context, Widget home);

class DebugApp extends StatefulWidget {
  const DebugApp({super.key, required this.menus, required this.appBuilder});

  final List<DebugMenu> menus;
  final MaterialAppBuilder appBuilder;

  static DebugAppState of(BuildContext context) {
    final state = context.findAncestorStateOfType<DebugAppState>();
    assert(state != null, 'No DebugAppState found in context');
    return state!;
  }

  @override
  State<DebugApp> createState() => DebugAppState();
}

const Duration _animationDuration = Duration(milliseconds: 300);

class DebugAppState extends State<DebugApp> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  void close() {
    setState(() {
      _opacity = 0.0;
    });
    Future.delayed(_animationDuration, () {
      if (!mounted) return;
      DebugDot.of(context).removeDebugApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: _animationDuration,
      child: widget.appBuilder(
        context,
        DebugPage(menus: widget.menus, close: close),
      ),
    );
  }
}
