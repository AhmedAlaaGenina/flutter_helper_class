import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class WhiteboardScreen extends StatefulWidget {
  const WhiteboardScreen({super.key});
  @override
  State<WhiteboardScreen> createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  List<DrawnShape> shapes = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;
  bool isBold = false;
  String selectedShape = 'Line';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whiteboard'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            color: Colors.grey[200],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.color_lens, color: selectedColor),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Select Color'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: selectedColor,
                              onColorChanged: (color) {
                                setState(() {
                                  selectedColor = color;
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.format_bold,
                        color: isBold ? Colors.black : Colors.grey),
                    onPressed: () {
                      setState(() {
                        isBold = !isBold;
                        strokeWidth = isBold ? 10.0 : 5.0;
                      });
                    },
                  ),
                  PopupMenuButton<int>(
                    icon: const Icon(Icons.brush),
                    onSelected: (value) {},
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false,
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Slider(
                                  min: 1.0,
                                  max: 10.0,
                                  value: strokeWidth,
                                  onChanged: (value) {
                                    setState(() {
                                      strokeWidth = value;
                                      isBold = (strokeWidth >= 7.0 &&
                                          strokeWidth <= 10.0);
                                    });
                                  },
                                ),
                                Text(
                                    'Stroke Width: ${strokeWidth.toStringAsFixed(1)}'),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: selectedShape,
                    items: <String>['Line', 'Rectangle', 'Circle']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedShape = value!;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.undo),
                    onPressed: () {
                      setState(() {
                        if (shapes.isNotEmpty) {
                          shapes.removeLast();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        shapes.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  shapes.add(DrawnShape(
                    shape: selectedShape,
                    color: selectedColor,
                    strokeWidth: strokeWidth,
                    points: [details.localPosition],
                  ));
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  if (shapes.isNotEmpty) {
                    shapes.last.points.add(details.localPosition);
                  }
                });
              },
              onPanEnd: (details) {},
              child: CustomPaint(
                painter: WhiteboardPainter(shapes),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawnShape {
  final String shape;
  final Color color;
  final double strokeWidth;
  final List<Offset> points;

  DrawnShape({
    required this.shape,
    required this.color,
    required this.strokeWidth,
    required this.points,
  });
}

class WhiteboardPainter extends CustomPainter {
  final List<DrawnShape> shapes;

  WhiteboardPainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var shape in shapes) {
      Paint paint = Paint()
        ..color = shape.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = shape.strokeWidth
        ..style = PaintingStyle.stroke;

      if (shape.shape == 'Line') {
        for (int i = 0; i < shape.points.length - 1; i++) {
          canvas.drawLine(shape.points[i], shape.points[i + 1], paint);
        }
      } else if (shape.shape == 'Rectangle') {
        if (shape.points.length > 1) {
          Offset topLeft = shape.points.first;
          Offset bottomRight = shape.points.last;
          canvas.drawRect(
            Rect.fromPoints(topLeft, bottomRight),
            paint,
          );
        }
      } else if (shape.shape == 'Circle') {
        if (shape.points.length > 1) {
          Offset center = shape.points.first;
          Offset lastPoint = shape.points.last;
          double radius = (center - lastPoint).distance;
          canvas.drawCircle(center, radius, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
