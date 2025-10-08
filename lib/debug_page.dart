import 'debug_menu.dart';
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
        actions: [IconButton(icon: Icon(Icons.close), onPressed: close)],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final menu = menus[index];
          final icon = menu.icon;
          return Card(
            child: ListTile(
              leading: icon == null ? null : Icon(icon),
              title: Text(menu.title),
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
