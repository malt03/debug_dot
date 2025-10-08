import 'debug_dot.dart';
import 'debug_page.dart';
import 'package:flutter/material.dart';

class DebugApp extends StatefulWidget {
  const DebugApp({super.key, required this.menus});

  final List<DebugMenu> menus;

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DebugPage(menus: widget.menus, close: close),
      ),
    );
  }
}
