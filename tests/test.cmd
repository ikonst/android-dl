@echo off
setlocal

if not "%ANDROID_NDK_ROOT%"=="" PATH=%ANDROID_NDK_ROOT%;%PATH%
if not "%ANDROID_SDK_ROOT%"=="" PATH=%ANDROID_SDK_ROOT%\platform-tools;%PATH%

set DESTDIR=/data/local/tmp

REM build
call ndk-build NATIVE_TEST=1

REM deploy
for %%f in (libs\armeabi\*.so) do adb push %%f %DESTDIR%/
adb push libs\armeabi\android-dl_test %DESTDIR%/
adb shell chmod 775 %DESTDIR%/android-dl_test

REM test
adb shell "LD_LIBRARY_PATH=%DESTDIR% %DESTDIR%/android-dl_test"

endlocal
