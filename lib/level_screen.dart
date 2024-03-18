// level_screen.dart

import 'package:flutter/material.dart';
import 'core/route/app_route_name.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRouteName.drawingRoom);
              },
              child: Text('Level 1'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRouteName.drawingRoom, arguments: {
                  'level': 2, // Indicate level 2
                });
              },
              child: Text('Level 2'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRouteName.drawingRoom, arguments: {
                  'level': 3, // Indicate level 3
                });
              },
              child: Text('Level 3'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRouteName.drawingRoom, arguments: {
                  'level': 4, // Indicate level 4
                });
              },
              child: Text('Level 4'),
            ),
          ],
        ),
      ),
    );
  }
}
