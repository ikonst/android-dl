Android Dynamic Library Loader
==============================

This library works around an Android (pre-4.3) [issue](https://code.google.com/p/android/issues/detail?id=34416) with finding shared library dependencies. Basically, before Android 4.3, your app's *lib/* directory was not in the linker's search path (a.k.a *LD_LIBRARY_PATH*).

`System.loadLibrary("foobar")` looks in your app's *lib/* for the library itself (i.e. *.../com.yourapp/lib/libfoo.so*) but this is not enough if your *libfoo.so* needs (also your own) *libbar.so*. NDK documentation encourages you to explicitly call `System.loadLibrary` for all your library dependencies (to preload them), but this is cumbersome and error-prone in a large codebases.

For example, if your JNI library *libfoo.so* links with *libgnustl_shared.so*, you have to explicitly perform:

    System.loadLibrary("gnustl_shared");
    System.loadLibrary("foo");

(Similar approach can be taken for `dlopen` from within native code.)

History
=======

This code originally comes from the LibreOffice *lo-bootstrap.c* file, with the following modifications:

* Only the dynamic library-related code was kept.
* A different namespace was reinstated.
* Exception reporting was added.
* Documentation.
* Testcases.

Usage from Java
===============

## Step 1: Import into Eclipse

Import the 'android-dl' project to your Eclipse workspace.

## Step 2: Add library reference

In your project's properties, add 'android-dl' as an Android library reference.

## Step 3: Use within your Java code

1. `import com.github.ikonst.android_dl.*;`

2. Within your main activity's `onCreate`, call `AndroidDl.initialize( getApplicationInfo().nativeLibraryDir )`.

3. To load a JNI library, use `AndroidDl.loadLibrary(libName)` instead of `System.loadLibrary(libName)`.

Usage from native code (optional)
=================================

If you wish to use *android-dl* from your native code (as a `dlopen` replacement), you need to import it into your `jni/Android.mk` and add it as your shared library dependency.

Note that until you invoke `AndroidDl.initialize` from your Java code, your *LD_LIBRARY_PATH* will be used for library search. In other words, if you use this library without calling `AndroidDl.initialize`, you might as well use `dlopen` directly.

## Step 1: Import the NDK module

If the *android-dl* directory is in a global location (pointed to by the *NDK_MODULE_PATH* environment variable), this is what you should append to the end of your *jni/Android.mk* file:

<pre>
$(call import-module,android-dl/jni)
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
    $(call import-module,android-dl/jni)

In addition, add `android-dl` to your `LOCAL_SHARED_LIBRARIES`, e.g.:

    include $(CLEAR_VARS)

    LOCAL_MODULE := foo
    LOCAL_SRC_FILES := foo.c
    LOCAL_SHARED_LIBRARIES := bar baz android-dl

    include $(BUILD_SHARED_LIBRARY)

For more information about importing NDK modules, see docs/IMPORT-MODULE.html in the Android NDK tree.

## Step 2: Use from your native code

When you wish to load shared libraries from within your native code:

1. `#include <android-dl.h>`
1. Use `android_dlopen(lib)` instead of `dlopen(lib)`.

Testing
=======

To test the JNI interface, import both the android-dl and the android-dl-test projects into ADT.
Run 'android-dl-test' to invoke the JUnit testcases.

To test the native interface (through GoogleTest), go to 'test' subdirectory and execute
`test.sh` (or `test.cmd` on Windows).
