APP_PLATFORM := android-14

ifeq ($(ANDROID_DL_TEST),1)
NDK_TOOLCHAIN_VERSION := clang
APP_STL := c++_shared
else
APP_STL := none
endif
