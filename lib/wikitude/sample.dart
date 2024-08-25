import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:collection/collection.dart';
import 'package:teratour/wikitude/category.dart';

class Sample {
  final List<String> requiredExtensions;
  final String name;
  final String path;
  final List<String> requiredFeatures;
  final StartupConfiguration startupConfiguration;

  const Sample(
      {required this.requiredExtensions,
      required this.name,
      required this.path,
      required this.requiredFeatures,
      required this.startupConfiguration});

  static Sample? findSampleByName(
      List<Category> categories, String sampleName) {
    for (var category in categories) {
      final sample = category.samples.firstWhereOrNull(
        (sample) => sample.name == sampleName,
      );
      if (sample != null) {
        return sample;
      }
    }
    return null;
  }

  factory Sample.fromJson(Map<String, dynamic> jsonMap) {
    var requiredExtensionsFromJson = jsonMap['required_extensions'];
    List<String> requiredExtensionsList = [];
    if (requiredExtensionsFromJson != null) {
      requiredExtensionsList = List<String>.from(requiredExtensionsFromJson);
    }

    var requiredFeaturesFromJson = jsonMap['requiredFeatures'];
    List<String> requiredFeaturesList = [];
    if (requiredFeaturesFromJson != null) {
      requiredFeaturesList = List<String>.from(requiredFeaturesFromJson);
    }

    var exampleStartupConfiguration = jsonMap['startupConfiguration'];
    StartupConfiguration startupConfigurationItem = StartupConfiguration();
    if (exampleStartupConfiguration != null) {
      CameraPosition? cameraPosition;
      switch (exampleStartupConfiguration["camera_position"]) {
        case "back":
          cameraPosition = CameraPosition.BACK;
          break;
        case "front":
          cameraPosition = CameraPosition.FRONT;
          break;
        case "default":
          cameraPosition = CameraPosition.DEFAULT;
          break;
      }

      CameraResolution? cameraResolution;
      switch (exampleStartupConfiguration["camera_resolution"]) {
        case "sd_640x480":
          cameraResolution = CameraResolution.SD_640x480;
          break;
        case "hd_1280x720":
          cameraResolution = CameraResolution.HD_1280x720;
          break;
        case "full_hd_1920x1080":
          cameraResolution = CameraResolution.FULL_HD_1920x1080;
          break;
        case "auto":
          cameraResolution = CameraResolution.AUTO;
          break;
      }

      CameraFocusMode? cameraFocusMode;
      switch (exampleStartupConfiguration["camera_focus_mode"]) {
        case "once":
          cameraFocusMode = CameraFocusMode.ONCE;
          break;
        case "continuous":
          cameraFocusMode = CameraFocusMode.CONTINUOUS;
          break;
        case "off":
          cameraFocusMode = CameraFocusMode.OFF;
          break;
      }

      startupConfigurationItem = StartupConfiguration(
          cameraPosition: cameraPosition,
          cameraResolution: cameraResolution,
          cameraFocusMode: cameraFocusMode);
    }

    return Sample(
        requiredExtensions: requiredExtensionsList,
        name: jsonMap["name"],
        path: jsonMap["path"],
        requiredFeatures: requiredFeaturesList,
        startupConfiguration: startupConfigurationItem);
  }
}