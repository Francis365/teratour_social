-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.tasks.** { *; }

-keep class com.google.ar.sceneform.** { *; }
-dontwarn com.google.ar.sceneform.**

-keep class com.google.devtools.build.android.desugar.runtime.** { *; }
-dontwarn com.google.devtools.build.android.desugar.runtime.**
