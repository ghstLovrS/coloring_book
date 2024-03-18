//lib/core/route/app_route.dart
import 'package:coloring_book/core/route/app_route_name.dart';
import 'package:flutter/material.dart';
import 'package:coloring_book/level_screen.dart';
import 'package:coloring_book/features/model/presentation/drawing_room_screen.dart';

class AppRoute {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteName.drawingRoom:
        return MaterialPageRoute(
          builder: (_) => const DrawingRoomScreen(),
          settings: settings,
        );
      case AppRouteName.levelScreen: // Add case for level screen route
        return MaterialPageRoute(
          builder: (_) => const LevelScreen(),
          settings: settings,
        );
      case "/template":
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => const SizedBox(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
    }

    return null;
  }
}
