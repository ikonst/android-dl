Android Dynamic Library Loader
==============================

This library works around Android's inability to resolve native (JNI) library dependencies.
Normally, unless you manually preload your JNI library's dependencies (by performing additional `System.loadLibrary` calls), you'll get a `LinkageError` exception.
For example, if your JNI library libfoo.so links with libgnustl_shared.so, you have to explicitly perform:

    System.loadLibrary("libstlport_shared");
    System.loadLibrary("foo");

This is what the Android NDK recommends doing (see `docs/CPLUSPLUS-SUPPORT.html`) and for merely a single dependency this isn't a big deal, but it can get unruly when you have a complicated codebase with a myriad of libraries.

Technically, this stems from the fact that your app's *lib* directory (i.e. `/data/data/com.company.foobar/lib`) is not in the Dalvik process' `LD_LIBRARY_PATH` environment variable. Moreover, the environment variable is only parsed at startup and there's no way to amend the list at runtime.

History
=======

This code originally comes from the LibreOffice lo-bootstrap.c file;
all of the irrelevant (LibreOffice-specific) code was removed and a different namespace was reinstated.
In addition, exception reporting was added.

Usage
=====

Append this to the end of your `jni/Android.mk` file:

<pre>
$(call import-module,android-dl)
</pre>

The android-dl directory should either be in a global path (pointed to by NDK_MODULE_PATH);
alternatively, you might choose to place it relative to your project.
For example, if your directory layout is:

     workspace/
       foobar/ <- your project
       android-dl/

this is what you should append to your Android.mk:

    $(call import-add-path,..)
    $(call import-module,android-dl)

In addition, add `android-dl` to your `LOCAL_SHARED_LIBRARIES`, e.g.:

    include $(CLEAR_VARS)

    LOCAL_MODULE := foo
    LOCAL_SRC_FILES := foo.c
    LOCAL_SHARED_LIBRARIES := bar baz android-dl

    include $(BUILD_SHARED_LIBRARY)

For more information about importing NDK modules, see `docs/IMPORT-MODULE.html` in the Android NDK tree.

For your Java code:

* Copy *src/android-dl* to your *src* directory.
* Within your main activity's `onCreate`, call `AndroidDl.initialize( getApplicationInfo().nativeLibraryDir )`.
* Within your Java code, use `AndroidDl.loadLibrary(libName)` instead of `System.loadLibrary(libName)`.

When you wish to load libraries within your native code:

* `#include <android-dl.h>`
* Use `android_dlopen(lib)` instead of `dlopen(lib)`.
