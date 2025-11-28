import 'debug_dot.dart';
import 'package:flutter/material.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key, required this.menus, required this.close});

  final List<DebugMenu> menus;
  final VoidCallback close;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Menu'),
        actions: [IconButton(icon: const _CloseIcon(), onPressed: close)],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final menu = menus[index];
          final info = menu.info(context);
          return Card(
            child: ListTile(
              leading: info.icon == null ? null : Icon(info.icon),
              title: Text(info.title),
              onTap: () {
                final route = menu.onTap(context);
                if (route == null) return;
                Navigator.of(context).push(route);
              },
            ),
          );
        },
        itemCount: menus.length,
      ),
    );
  }
}

class _CloseIcon extends StatelessWidget {
  const _CloseIcon();

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color ?? Colors.black;
    return CustomPaint(
      size: const Size(32, 32),
      painter: _CloseIconPainter(color: color),
    );
  }
}

class _CloseIconPainter extends CustomPainter {
  final Color color;

  _CloseIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final margin = 8.0;
    canvas.drawLine(
      Offset(margin, margin),
      Offset(size.width - margin, size.height - margin),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(margin, size.height - margin),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CloseIconPainter oldDelegate) =>
      color != oldDelegate.color;
}
