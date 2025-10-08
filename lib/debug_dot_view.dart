import 'bug_view.dart';
import 'debug_dot.dart';
import 'math.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

enum DebugDotPosition { topLeft, topRight, bottomLeft, bottomRight }

class DebugDotView extends StatefulWidget {
  const DebugDotView({super.key, required this.menus, required this.padding, required this.initialPosition});

  final List<DebugMenu> menus;
  final EdgeInsets padding;
  final DebugDotPosition initialPosition;

  @override
  State<DebugDotView> createState() => _DebugDotViewState();
}

const Size _bugSize = Size(20, 20);

class _DebugDotViewState extends State<DebugDotView> with SingleTickerProviderStateMixin {
  _DebugDotViewState();

  Offset? _position;
  Rect? _rect;
  late AnimationController _animationController;
  Animation<Offset>? _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, upperBound: double.infinity);
    _animationController.addListener(() {
      final animation = _animation;
      if (animation == null) return;
      setState(() {
        _position = animation.value;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final size = MediaQuery.of(context).size;
        final bottomRight = Offset(size.width, size.height) + widget.padding.bottomRight;
        _rect = Rect.fromPoints(widget.padding.topLeft, bottomRight);
        _position = switch (widget.initialPosition) {
          DebugDotPosition.topLeft => widget.padding.topLeft,
          DebugDotPosition.topRight => Offset(size.width, 0) + widget.padding.topRight,
          DebugDotPosition.bottomLeft => Offset(0, size.height) + widget.padding.bottomLeft,
          DebugDotPosition.bottomRight => bottomRight,
        };
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _runAnimation(Velocity velocity) {
    final position = _position;
    final rect = _rect;
    if (position == null || rect == null) return;
    final clampedPosition = smoothClampPoint(position, rect);
    final target = projectToRectEdge(p: clampedPosition, v: velocity.pixelsPerSecond, rect: rect);
    final vector = target - clampedPosition;
    if (vector == Offset.zero) return;

    final initialVelocity = velocity.pixelsPerSecond.distance / vector.distance;
    _animation = _animationController.drive(Tween(begin: clampedPosition, end: target));
    _animationController.reset();
    final spring = SpringDescription(mass: 0.5, stiffness: 1500, damping: 40);
    _animationController.animateWith(SpringSimulation(spring, 0, 1, initialVelocity, snapToEnd: true));
  }

  @override
  Widget build(BuildContext context) {
    final position = _position;
    final rect = _rect;
    if (position == null || rect == null) return const SizedBox.shrink();
    final clampedPosition = smoothClampPoint(position, rect);

    final decoration = ShapeDecoration(
      color: const Color(0xFF555555),
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: const Color(0xFFFFFFFF), width: 1),
      ),
      shadows: [BoxShadow(color: const Color(0x55000000), blurRadius: 4, offset: const Offset(0, 2))],
    );

    return Positioned(
      width: _bugSize.width,
      height: _bugSize.height,
      top: clampedPosition.dy - _bugSize.height / 2,
      left: clampedPosition.dx - _bugSize.width / 2,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position = position + details.delta;
          });
        },
        onPanEnd: (details) {
          _runAnimation(details.velocity);
        },
        onPanCancel: () {
          _runAnimation(Velocity.zero);
        },
        onTap: () {
          DebugDot.of(context).showDebugApp();
        },
        child: Opacity(
          opacity: 0.5,
          child: DecoratedBox(decoration: decoration, child: BugView()),
        ),
      ),
    );
  }
}
