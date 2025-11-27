# Keep OkHttp (required by uCrop)
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# Keep Okio
-keep class okio.** { *; }
-dontwarn okio.**

# Keep uCrop
-keep class com.yalantis.ucrop.** { *; }
-dontwarn com.yalantis.ucrop.**

# Keep Glide (used internally)
-keep class com.bumptech.glide.** { *; }
-dontwarn com.bumptech.glide.**