# APP_PLATFORM := android-14
NDK_TOOLCHAIN_VERSION := clang
APP_STL := c++_shared
ifeq ($(NDK_TOOLCHAIN_VERSION),clang)
APP_CFLAGS += -Wno-extern-c-compat
endif
