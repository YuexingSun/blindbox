# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

#fastJson
-keep class com.alibaba.fastjson.**{*;}
-dontwarn com.alibaba.fastjson.**

#OkHttp3
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

-keep class okio.** { *; }
-dontwarn okio.**

# android X
-keep class com.google.android.material.** {*;}
-keep class androidx.** {*;}
-keep public class * extends androidx.**
-keep interface androidx.** {*;}
-dontwarn com.google.android.material.**
-dontnote com.google.android.material.**
-dontwarn androidx.**

# 极光
-dontoptimize
-dontpreverify

-dontwarn cn.jpush.**
-keep class cn.jpush.** { *; }
-dontwarn cn.jiguang.**
-keep class cn.jiguang.** { *; }

-dontwarn cn.com.chinatelecom.**
-keep class cn.com.chinatelecom.** { *; }
-dontwarn com.ct.**
-keep class com.ct.** { *; }
-dontwarn a.a.**
-keep class a.a.** { *; }
-dontwarn com.cmic.**
-keep class com.cmic.** { *; }
-dontwarn com.unicom.**
-keep class com.unicom.** { *; }
-dontwarn com.sdk.**
-keep class com.sdk.** { *; }

-dontwarn com.sdk.**
-keep class com.sdk.** { *; }

#PictureSelector 2.0 https://github.com/LuckSiege/PictureSelector/blob/master/README_CN.md
-keep class com.luck.picture.lib.** { *; }

#Ucrop
-dontwarn com.yalantis.ucrop**
-keep class com.yalantis.ucrop** { *; }
-keep interface com.yalantis.ucrop** { *; }

# glide
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep class * extends com.bumptech.glide.module.AppGlideModule {
 <init>(...);
}
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}
-keep class com.bumptech.glide.load.data.ParcelFileDescriptorRewinder$InternalRewinder {
  *** rewind();
}

-keepclassmembers class * implements androidx.viewbinding.ViewBinding {
  public static ** inflate(...);
  public static ** bind(***);
}

 #高德 定位
#-keep class com.amap.api.location.**{*;}
#-keep class com.amap.api.fence.**{*;}
#-keep class com.autonavi.aps.amapapi.model.**{*;}
#
# #高德3d地图
#-keep class com.amap.api.maps.**{*;}
#-keep class com.autonavi.**{*;}
#-keep class com.amap.api.trace.**{*;}
#
# #高德导航
#-keep class com.amap.api.navi.**{*;}
#-keep class com.alibaba.mit.alitts.*{*;}
#-keep class com.google.**{*;}
#
# #搜索：
#-keep class com.amap.api.services.**{*;}

 # banner https://github.com/zhpanvip/BannerViewPager/wiki/06.%E5%BF%AB%E9%80%9F%E5%BC%80%E5%A7%8B
 -keep class androidx.recyclerview.widget.**{*;}
 -keep class androidx.viewpager2.widget.**{*;}

# 如果使用了 单类注入，即不定义接口实现 IProvider，需添加下面规则，保护实现
# -keep class * implements com.alibaba.android.arouter.facade.template.IProvider

#微信开放sdk
-keep class com.tencent.mm.opensdk.** {
    *;
}

-keep class com.tencent.wxop.** {
    *;
}

-keep class com.tencent.mm.sdk.** {
    *;
}

#Bugly
-dontwarn com.tencent.bugly.**
-keep public class com.tencent.bugly.**{*;}
