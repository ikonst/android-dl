Android Dynamic Library Loader
==============================

This library works around Android's inability to resolve native (JNI) library dependencies.
This code originally comes from the LibreOffice lo-bootstrap.c file; all of the irrelevant
code was removed and a different namespace was reinstated. In addition, more thorough
exception reporting was added.

Normally, unless you manually preload your JNI library's dependencies (by performing additional System.loadLibrary calls), you'll get a LinkageError exception.
This stems from the fact that your *app/lib* path is not in the Dalvik process LD_LIBRARY_PATH environment variable.
Even the Android NDK recommends doing that -- e.g. see docs/CPLUSPLUS-SUPPORT.html.

Usage
=====

Within your jni/Android.mk file, add:

<pre>
$(call import-module,android-dl)
</pre>

and in your module, add:

<pre>
LOCAL_SHARED_LIBRARIES := ... android-dl ...
</pre>

For more information about importing NDK modules, see docs/IMPORT-MODULE.html in the Android NDK tree.

For your Java code:
* Copy src/android_dl to your src directory.
* From within your activity, call <pre>AndroidDl.initialize( getApplicationInfo().nativeLibraryDir )</pre>.
* Within your Java code, use <pre>AndroidDl.loadLibrary<pre> instead of <pre>System.loadLibrary</pre>.

Within your native code:
* #include <android-dl.h>
* Use <pre>android_dlopen</pre> instead of <pre>dlopen</pre>.