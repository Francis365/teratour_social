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
    // Future<void> requestCameraPermission() async {
    //   final status = await Permission.camera.request();
    //   if (status == PermissionStatus.granted) {
    //     // Permission granted.
    //   } else if (status == PermissionStatus.denied) {
    //     // Permission denied.
    //   } else if (status == PermissionStatus.permanentlyDenied) {
    //     // Permission permanently denied.
    //   }
    // }

    return Stack(
      fit: StackFit.expand,
      children: [
        Material(
          child: ArLocationWidget(
              annotations: annotations,
              annotationViewBuilder: (context, annotation) {
                return AnnotationView(annotation: annotation as Annotation);
              },
              onLocationChange: (Position position) {
                if (annotations.isNotEmpty) {
                  return;
                }

                Future.delayed(const Duration(seconds: 1), () {
                  setState(() {
                    annotations = fakeAnnotation(
                      position: position,
                      distance: 1500,
                      numberMaxPoi: 5,
                    );
                  });
                });
              }),
        ),
        // GameWidget(game: MyGame())
      ],
    );
  }
}
