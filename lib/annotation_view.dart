import 'dart:convert';

import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teratour/ar_view_widget.dart';
import 'package:teratour/helpers.dart';
import 'package:teratour/wikitude/category.dart';
import 'package:teratour/wikitude/sample.dart';

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
      onTap: () async {
        // launchUrl(Uri.parse("https://francis365.github.io/Teratour-Web-AR2wotnk/"));

        var sample = await getSample("3d Model At Geo Location");

        if (sample == null) {
          showToast("Sample not found");
          return;
        }

        // showToast("Loading...");

        try {
          var isSupported = await _isDeviceSupporting(sample.requiredFeatures);

          if (!isSupported.success) {
            showToast("Device not supported: ${isSupported.message}");
            return;
          }

          var isGranted = await _requestARPermissions(sample.requiredFeatures);

          if (!isGranted.success) {
            showToast("Permission not granted: ${isGranted.message}");
            return;
          }

          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => ArViewWidget(
                position: annotation.position,
                sample: sample,
              ),
            ),
          );
        } catch (error) {
          showToast(error);
        }

        // if (isSupported.success) {}
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

  Future<String> _loadSamplesJson() async {
    return await rootBundle.loadString('samples/samples.json');
  }

  Future<Sample?> getSample(String name) async {
    String samplesJson = await _loadSamplesJson();
    List<dynamic> categoriesFromJson = json.decode(samplesJson);

    var categories = categoriesFromJson.map((element) {
      return Category.fromJson(element);
    });

    return Sample.findSampleByName([...categories], name);
  }

  Future<WikitudeResponse> _isDeviceSupporting(List<String> features) {
    return WikitudePlugin.isDeviceSupporting(features);
  }

  Future<WikitudeResponse> _requestARPermissions(List<String> features) {
    return WikitudePlugin.requestARPermissions(features);
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
