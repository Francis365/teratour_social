// enum Samples {
//   // Image Tracking
//   imageOnTarget(
//     category: 'Image Tracking',
//     path: '01_ImageTracking_1_ImageOnTarget/index.html',
//     requiredFeatures: ['image_tracking'],
//     cameraPosition: 'back',
//     cameraResolution: 'auto',
//   ),
//   differentTargets(
//     category: 'Image Tracking',
//     path: '01_ImageTracking_2_DifferentTargets/index.html',
//     requiredFeatures: ['image_tracking'],
//     cameraPosition: 'back',
//     cameraResolution: 'auto',
//   ),
//   interactivityImageTracking(
//     category: 'Image Tracking',
//     path: '01_ImageTracking_3_Interactivity/index.html',
//     requiredFeatures: ['image_tracking'],
//     cameraPosition: 'back',
//     cameraResolution: 'auto',
//   ),
//   // ... add the rest of the Image Tracking samples

//   // Advanced Image Tracking
//   gestures(
//     category: 'Advanced Image Tracking',
//     path: '02_AdvancedImageTracking_1_Gestures/index.html',
//     requiredFeatures: ['image_tracking'],
//     requiredExtensions: ['screenshot'],
//     cameraPosition: 'back',
//     cameraResolution: 'auto',
//   ),
//   distanceToTarget(
//     category: 'Advanced Image Tracking',
//     path: '02_AdvancedImageTracking_2_DistanceToTarget/index.html',
//     requiredFeatures: ['image_tracking'],
//     cameraPosition: 'back',
//     cameraResolution: 'auto',
//   ),
//   // ... add the rest of the Advanced Image Tracking samples

//   // Multiple Targets
//   multipleTargets(
//     category: 'Multiple Targets',
//     path: '03_MultipleTargets_1_MultipleTargets/index.html',
//     requiredFeatures: ['image_tracking'],
//     cameraPosition: 'back',
//     cameraResolution: 'auto',
//   ),
//   // ... add the rest of the Multiple Targets samples

//   // Continue adding all other categories similarly...

//   // Example for another category
//   poiAtLocation(
//     category: 'Point of Interest',
//     path: '08_PointOfInterest_1_PoiAtLocation/index.html',
//     requiredFeatures: ['geo'],
//     cameraPosition: 'back',
//     cameraResolution: 'auto',
//   );

//   final String category;
//   final String path;
//   final List<String> requiredFeatures;
//   final List<String>? requiredExtensions;
//   final Map<String, dynamic> startupConfiguration;
//   final String cameraPosition;
//   final String? cameraResolution;

//   const Samples({
//     required this.category,
//     required this.path,
//     required this.requiredFeatures,
//     this.requiredExtensions,
//     required this.cameraPosition,
//     this.cameraResolution,
//     required this.startupConfiguration,
//   });
// }
