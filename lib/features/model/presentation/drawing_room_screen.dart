//lib/features/model/presentation/drawing_room_screen.dart
import 'package:flutter/material.dart';
import 'package:coloring_book/core/theme/app_color.dart';
import 'package:coloring_book/features/model/drawing_point.dart';

class DrawingRoomScreen extends StatefulWidget {
  const DrawingRoomScreen({Key? key}) : super(key: key);

  @override
  _DrawingRoomScreenState createState() => _DrawingRoomScreenState();
}

class _DrawingRoomScreenState extends State<DrawingRoomScreen> {
  var availableColor = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown,
  ];

  var historyDrawingPoints = <DrawingPoint>[];
  var drawingPoints = <DrawingPoint>[];

  var selectedColor = Colors.black;
  var selectedWidth = 2.0;

  DrawingPoint? currentDrawingPoint;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: Stack(
            children: [
              //---------------------------------------------------------- Canvas --------------------------------------------
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_getBackgroundImage()),
                    fit: BoxFit.cover,
                  ),
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) {
                    setState(() {
                      currentDrawingPoint = DrawingPoint(
                        id: DateTime.now().microsecondsSinceEpoch,
                        offsets: [
                          details.localPosition,
                        ],
                        color: selectedColor,
                        width: selectedWidth,
                      );

                      if (currentDrawingPoint == null) return;
                      drawingPoints.add(currentDrawingPoint!);
                      historyDrawingPoints = List.of(drawingPoints);
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      if (currentDrawingPoint == null) return;

                      currentDrawingPoint = currentDrawingPoint?.copyWith(
                        offsets: currentDrawingPoint!.offsets
                          ..add(details.localPosition),
                      );
                      drawingPoints.last = currentDrawingPoint!;
                      historyDrawingPoints = List.of(drawingPoints);
                    });
                  },
                  onPanEnd: (_) {
                    currentDrawingPoint = null;
                  },
                  child: CustomPaint(
                    painter: DrawingPainter(
                      drawingPoints: drawingPoints,
                      opacity: 0.8, // Set opacity to 80%
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
              ),

              //----------------------------------------------------- color pallet --------------------------------------------
              Positioned(
                top: isLandscape ? 16 : MediaQuery.of(context).padding.top,
                left: isLandscape ? 16 : 0,
                right: isLandscape ? 16 : 0,
                child: SizedBox(
                  height: isLandscape ? 80 : 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: availableColor.length,
                    separatorBuilder: (_, __) {
                      return const SizedBox(width: 8);
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = availableColor[index];
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: availableColor[index],
                            shape: BoxShape.circle,
                          ),
                          foregroundDecoration: BoxDecoration(
                            border: selectedColor == availableColor[index]
                                ? Border.all(
                                    color: AppColor.primaryColor, width: 4)
                                : null,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              //---------------------------------------------------- pencil size ----------------------
              Positioned(
                top: isLandscape
                    ? MediaQuery.of(context).padding.top + 16
                    : MediaQuery.of(context).padding.top + 80,
                right: isLandscape ? 0 : 0,
                bottom: isLandscape ? 150 : 0,
                child: RotatedBox(
                  quarterTurns: isLandscape ? 3 : 0,
                  child: Slider(
                    value: selectedWidth,
                    min: 1,
                    max: 20,
                    onChanged: (value) {
                      setState(() {
                        selectedWidth = value;
                      });
                    },
                  ),
                ),
              ),

              //---------------------------------------------------------- Reference Image --------------------------------------------
              Positioned(
                top: 16,
                right: 30,
                child: Image.asset(
                  _getReferenceImage(),
                  height: 140,
                  width: 140,
                ),
              ),
            ],
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Finish button
              FloatingActionButton(
                heroTag: "Finish",
                onPressed: () {
                  // Navigate back to the level screen
                  Navigator.of(context).pop();
                },
                backgroundColor: const Color.fromARGB(255, 99, 227, 103),
                child: const Icon(Icons.check),
              ),
              const SizedBox(width: 16),
              // Undo button
              FloatingActionButton(
                heroTag: "Undo",
                onPressed: () {
                  if (drawingPoints.isNotEmpty &&
                      historyDrawingPoints.isNotEmpty) {
                    setState(() {
                      drawingPoints.removeLast();
                    });
                  }
                },
                child: const Icon(Icons.undo),
              ),
              const SizedBox(width: 16),
              // Redo button
              FloatingActionButton(
                heroTag: "Redo",
                onPressed: () {
                  setState(() {
                    if (drawingPoints.length < historyDrawingPoints.length) {
                      final index = drawingPoints.length;
                      drawingPoints.add(historyDrawingPoints[index]);
                    }
                  });
                },
                child: const Icon(Icons.redo),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to get the background image based on the level
  String _getBackgroundImage() {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    switch (args?['level']) {
      case 2:
        return 'assets/ball empty.png';
      case 3:
        return 'assets/house.png';
      case 4:
        return 'assets/fish.png';
      default:
        return 'assets/apple empty.png';
    }
  }

  // Method to get the reference image based on the level
  String _getReferenceImage() {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    switch (args?['level']) {
      case 2:
        return 'assets/ball.png';
      case 3:
        return 'assets/house color.png';
      case 4:
        return 'assets/fish color.png';
      default:
        return 'assets/apple.png';
    }
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;
  final double opacity;

  DrawingPainter({required this.drawingPoints, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color.withOpacity(0.1) // Set opacity
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;

      for (var i = 0; i < drawingPoint.offsets.length; i++) {
        var notLastOffset = i != drawingPoint.offsets.length - 1;

        if (notLastOffset) {
          final current = drawingPoint.offsets[i];
          final next = drawingPoint.offsets[i + 1];
          canvas.drawLine(current, next, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
