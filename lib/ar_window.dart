import 'package:ar_location_view/ar_location_view.dart';
// import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:teratour/annotation_view.dart';
import 'package:teratour/annotations.dart';

class ArWindow extends StatefulWidget {
  const ArWindow({super.key});

  @override
  State<ArWindow> createState() => _ArWindowState();
}

class _ArWindowState extends State<ArWindow> {
  List<Annotation> annotations = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ArLocationWidget(
            annotations: annotations,
            annotationViewBuilder: (context, annotation) {
              return AnnotationView(annotation: annotation as Annotation);
            },
            onLocationChange: (Position position) {
              if (annotations.isNotEmpty) {
                return;
              }

              Future.delayed(const Duration(seconds: 5), () {
                setState(() {
                  annotations = fakeAnnotation(
                    position: position,
                    distance: 1500,
                  );
                });
              });
            }),
        // GameWidget(game: MyGame())
      ],
    );
  }
}
