# TensorFlow Lite keep rules
-keep class org.tensorflow.** { *; }
-dontwarn org.tensorflow.**

# Required if using GPU Delegate
-keep class org.tensorflow.lite.gpu.** { *; }
-dontwarn org.tensorflow.lite.gpu.**

# Optional: to avoid missing class warnings
-keep class org.tensorflow.lite.nnapi.** { *; }
-dontwarn org.tensorflow.lite.nnapi.**
