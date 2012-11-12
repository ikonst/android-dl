Android Dynamic Library Loader
==============================

This library works around Android's inability to resolve dependencies between your app's shared libraries (as opposed to dependency on system libraries such as *libc.so* and *liblog.so*).
For example, if you load a JNI shared library that depends on another library shipped in your app's *lib/* directory, you'll get a `LinkageError` exception unless you manually preload the dependencies (by performing additional `System.loadLibrary` calls), 
For example, if your JNI library *libfoo.so* links with *libgnustl_shared.so*, you have to explicitly perform:

    System.loadLibrary("libstlport_shared");
    System.loadLibrary("foo");
	
This is what the Android NDK recommends doing (see docs/CPLUSPLUS-SUPPORT.html) and for merely a single dependency this isn't a big deal, but it can get unruly when you have a complicated codebase with a myriad of libraries.

(Same goes for performing `dlopen` from within native code.)

Technically, this stems from the fact that your app's *lib/* directory (i.e. */data/data/com.company.foobar/lib/*) is not in the Dalvik process' *LD_LIBRARY_PATH* environment variable. Moreover, the environment variable is [only parsed at startup](https://groups.google.com/d/msg/android-ndk/m6OddFQINxs/sAQ34sFhJ7QJ) and there's no way to amend the list at runtime.

History
=======

This code originally comes from the LibreOffice *lo-bootstrap.c* file, with the following modifications:

* Only the dynamic library-related code was kept.
* A different namespace was reinstated.
* Exception reporting was added.
* Documentation.

Usage
=====

## Step 1: Import the NDK module

If the *android-dl* directory is in a global location (pointed to by the *NDK_MODULE_PATH* environment variable), this is what you should append to the end of your *jni/Android.mk* file:

<pre>
$(call import-module,android-dl)
</pre>

Alternatively, you might choose to place it relative to your project.
For example, if your directory layout is:

     workspace/
       android-dl/
       foobar/ <- your project
	     jni/
	       Android.mk

this is what you should append to your *jni/Android.mk* file:

    $(call import-add-path,..)
    $(call import-module,android-dl)

In addition, add `android-dl` to your `LOCAL_SHARED_LIBRARIES`, e.g.:

    include $(CLEAR_VARS)

    LOCAL_MODULE := foo
    LOCAL_SRC_FILES := foo.c
    LOCAL_SHARED_LIBRARIES := bar baz android-dl

    include $(BUILD_SHARED_LIBRARY)

For more information about importing NDK modules, see docs/IMPORT-MODULE.html in the Android NDK tree.

## Step 2: Add Java bindings and initialize

1. Copy *src/android-dl* to your *src/* directory.
1. Within your main activity's `onCreate`, call `AndroidDl.initialize( getApplicationInfo().nativeLibraryDir )`.

## Step 3: Use from your Java code

To load a JNI library, use `AndroidDl.loadLibrary(libName)` instead of `System.loadLibrary(libName)`.

## Step 4: Use from your native code

When you wish to load shared libraries from within your native code:

1. `#include <android-dl.h>`
1. Use `android_dlopen(lib)` instead of `dlopen(lib)`.
