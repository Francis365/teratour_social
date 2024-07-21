import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teratour/annotations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebAr extends StatefulWidget {
  final Annotation annotation;

  const WebAr({super.key, required this.annotation});

  @override
  State<WebAr> createState() => _WebArState();
}

class _WebArState extends State<WebAr> {
  late WebViewController _controller;

  bool isLoading = true;

  Future<bool> grantPermission() async {
    try {
      var status = await Permission.camera.status;
      if (status.isDenied) {
        // We haven't asked for permission yet or the permission has been denied before
        await Permission.camera.request();
      }

      status = await Permission.location.status;
      if (status.isDenied) {
        // We haven't asked for permission yet or the permission has been denied before
        await Permission.location.request();
      }
    } catch (error) {
      print(error);

      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();

    grantPermission().then((success) {
      _controller = WebViewController.fromPlatformCreationParams(
        const PlatformWebViewControllerCreationParams(),
        onPermissionRequest: (request) => request.grant(),
      )
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              // Pass the latitude and longitude dynamically after the page finishes loading
              _controller.runJavaScript(
                  'setCoordinates(${widget.annotation.position.latitude}, ${widget.annotation.position.longitude});');
            },
          ),
        )
        ..loadFlutterAsset("assets/ar.html");
      // ..loadRequest(
      //     Uri.parse("https://francis365.github.io/Teratour-Web-AR2wotnk/"));

      setState(() {
        isLoading = false;
      });
    });

    // var params = WebViewPlatform.instance is WebKitWebViewPlatform
    //     ? WebKitWebViewControllerCreationParams(
    //         allowsInlineMediaPlayback: true,
    //         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{})
    //     : const PlatformWebViewControllerCreationParams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return WebViewWidget(controller: _controller);
  }
}
