import 'package:flutter/material.dart';
import 'package:teratour/examples/cloudanchorexample.dart';
import 'package:teratour/web_ar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'annotations.dart';

class AnnotationView extends StatelessWidget {
  const AnnotationView({
    super.key,
    required this.annotation,
  });

  final Annotation annotation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // launchUrl(Uri.parse("https://francis365.github.io/Teratour-Web-AR2wotnk/"));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CloudAnchorWidget(annotation: annotation),
          ),
        );
      },
      child: FittedBox(
        fit: BoxFit.contain,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                // padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: typeFactory(annotation.type),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    annotation.type.toString().substring(15),
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${annotation.distanceFromUser.toInt()} m',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget typeFactory(AnnotationType type) {
    IconData iconData = Icons.ac_unit_outlined;
    Color color = Colors.teal;
    switch (type) {
      case AnnotationType.pharmacy:
        iconData = Icons.local_pharmacy_outlined;
        color = Colors.red;
        break;
      case AnnotationType.hotel:
        iconData = Icons.hotel_outlined;
        color = Colors.green;
        break;
      case AnnotationType.library:
        iconData = Icons.library_add_outlined;
        color = Colors.blue;
        break;
    }
    return Icon(
      iconData,
      size: 24,
      color: color,
    );
  }
}
