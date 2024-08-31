import 'dart:convert';
import 'dart:io';

import 'package:augmented_reality_plugin_wikitude/architect_widget.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teratour/helpers.dart';
import 'package:teratour/wikitude/applicationModelPois.dart';
import 'package:teratour/wikitude/poi.dart';
import 'package:teratour/wikitude/poiDetails.dart';
import 'package:teratour/wikitude/sample.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ArViewWidget extends StatefulWidget {
  final Sample sample;
  final Position position;

  const ArViewWidget({super.key, required this.sample, required this.position});

  @override
  State<ArViewWidget> createState() => _ArViewState();
}

class _ArViewState extends State<ArViewWidget> with WidgetsBindingObserver {
  late ArchitectWidget architectWidget;
  String wikitudeTrialLicenseKey =
      "oGYc5CZKhjdaz0NOVJqszpm1ieZlCoYoFLtT+ZqekwoXbaOQTFFtJgfmvi49k625yx2ZBkpR6jnarj6vPihgKOok9hZ5si01R0auvIS6fWEqWmCkCsXu9bXbhZbGFt7xKHnm9B3Uqo5C5WHysvUtZ2NcF0RMHATGN+VaCECC94RTYWx0ZWRfX6+xVJMMnhqKdG5xWDZ1d2TsdtmJ2CWaVzDrUsuT4l+vbAgSP2ZExRNr6ckdlsyK7UwCgFnl89yaj952dXgtIrusHcOB3NLSsL/tA7LI8+8z/VAPsQ4wFThvlOEC9vBE7siUPYDMoFoU4o5HGVaTMvkQPIFH0gcG2kTX/dNFYjVAuWnr3RIAkE24Hfy/7Q4CBZ4LWbZLLRiv2sT8fY+Jms9nbNGVQDl6ZImUvH5EVqcXD41nknGn9X/9ayyQKuFVustmPnriZn91SvwgqX4OAKWfL/zxJMN4AD0Z8I9UYKZFF4ioF+BzL4cSCyVP9PKvzVErSUScKHexzmc6LYmYKuupAb/C3Iw0cFNBFCHNsJqBUOfyDGPQV7Pv5b0p5bTJ+qqqtZ2SxpDInQ0JByVwz42V3DBS1hQRi1Q1uucsSNp4jRXAKjV8RYEP+q7y0IEg1fzSjrPYdeRuPxKA+91jb6MCczbFmy/90uwXhGN9rpBFfGlcK6ZaDpuCNjg1PCNz970JXozhgr+sx//GD0ZjXlGCtnH1U2Oa35l797aySJ+6E/YYJgTbghJU9w4Hsce0dS/+SDKanzpiKCio9v20qUfR6G5YM7eVG19UsLS7r+p2/LZt6fiTk2k=";
  late Sample sample;
  late Position position;
  String loadPath = "";
  bool loadFailed = false;

  @override
  void initState() {
    sample = widget.sample;
    position = widget.position;

    if (sample.path.contains("http://") || sample.path.contains("https://")) {
      loadPath = sample.path;
    } else {
      loadPath = "samples/${sample.path}";
    }

    // showToast("loading $loadPath");

    super.initState();

    WidgetsBinding.instance.addObserver(this);

    architectWidget = ArchitectWidget(
      onArchitectWidgetCreated: onArchitectWidgetCreated,
      licenseKey: wikitudeTrialLicenseKey,
      startupConfiguration: sample.startupConfiguration,
      features: sample.requiredFeatures,
    );

    WakelockPlus.enable();
  }

  @override
  void dispose() {
    architectWidget.pause();
    architectWidget.destroy();
    WidgetsBinding.instance.removeObserver(this);

    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        architectWidget.pause();
        break;
      case AppLifecycleState.resumed:
        architectWidget.resume();
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(sample.name)),
        body: WillPopScope(
          onWillPop: () async {
            if (defaultTargetPlatform == TargetPlatform.android &&
                !loadFailed) {
              bool? canWebViewGoBack = await architectWidget.canWebViewGoBack();
              if (canWebViewGoBack != null) {
                return !canWebViewGoBack;
              } else {
                return true;
              }
            } else {
              return true;
            }
          },
          child: Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: architectWidget),
        ));
  }

  Future<void> onArchitectWidgetCreated() async {
    await architectWidget.load(loadPath, onLoadSuccess, onLoadFailed);
    await architectWidget.resume();

    if (sample.requiredExtensions.contains("application_model_pois")) {
      List<Poi> pois =
          await ApplicationModelPois.prepareApplicationDataModel(position);
      architectWidget.callJavascript(
          "${"World.loadPoisFromJsonData(${jsonEncode(pois)}"});");
    }

    if ((sample.requiredExtensions.contains("screenshot") ||
        sample.requiredExtensions.contains("save_load_instant_target") ||
        sample.requiredExtensions.contains("native_detail"))) {
      architectWidget.setJSONObjectReceivedCallback(onJSONObjectReceived);
    }
  }

  Future<void> onJSONObjectReceived(Map<String, dynamic> jsonObject) async {
    if (jsonObject["action"] != null) {
      switch (jsonObject["action"]) {
        case "capture_screen":
          captureScreen();
          break;
        case "present_poi_details":
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PoiDetailsWidget(
                    id: jsonObject["id"],
                    title: jsonObject["title"],
                    description: jsonObject["description"])),
          );
          break;
        case "save_current_instant_target":
          final fileDirectory = await getApplicationDocumentsDirectory();
          final filePath = fileDirectory.path;
          final file = File('$filePath/SavedAugmentations.json');
          file.writeAsString(jsonObject["augmentations"]);
          architectWidget.callJavascript(
              "World.saveCurrentInstantTargetToUrl(\"$filePath/SavedInstantTarget.wto\");");
          break;
        case "load_existing_instant_target":
          final fileDirectory = await getApplicationDocumentsDirectory();
          final filePath = fileDirectory.path;
          final file = File('$filePath/SavedAugmentations.json');
          String augmentations;
          try {
            augmentations = await file.readAsString();
          } catch (e) {
            augmentations = "null";
          }
          architectWidget.callJavascript(
              "World.loadExistingInstantTargetFromUrl(\"$filePath/SavedInstantTarget.wto\",$augmentations);");
          break;
      }
    }
  }

  Future<void> captureScreen() async {
    WikitudeResponse captureScreenResponse =
        await architectWidget.captureScreen(true, "");
    if (captureScreenResponse.success) {
      architectWidget.showAlert(
          "Success", "Image saved in: ${captureScreenResponse.message}");
    } else {
      if (captureScreenResponse.message.contains("permission")) {
        architectWidget.showAlert("Error", captureScreenResponse.message, true);
      } else {
        architectWidget.showAlert("Error", captureScreenResponse.message);
      }
    }
  }

  Future<void> onLoadSuccess() async {
    loadFailed = false;

    showToast("Loaded Architect World");
  }

  Future<void> onLoadFailed(String error) async {
    loadFailed = true;
    architectWidget.showAlert("Failed to load Architect World", error);

    showToast("Failed to load Architect World: $error");
  }
}
