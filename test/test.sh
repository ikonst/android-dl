#!/bin/shell

DESTDIR=/data/local/tmp

# build
ndk-build NATIVE_TEST=1

# deploy
for f in libs/armeabi/*.so; do adb push $f $DESTDIR/; done
adb push libs/armeabi/android-dl_test $DESTDIR/
adb shell chmod 775 $DESTDIR/android-dl_test

# test
adb shell "LD_LIBRARY_PATH=$DESTDIR $DESTDIR/android-dl_test"
