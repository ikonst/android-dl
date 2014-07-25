ANDROID_DL_LOCAL_PATH := $(call my-dir)

$(call import-module,third_party/googletest)

# platform-12 defines Dl_info in <dlfcn.h>
ifeq (,$(call gte,$(APP_PLATFORM_LEVEL),12))
$(error Platform must be 12 or higher)
endif

include $(CLEAR_VARS)

LOCAL_PATH := $(ANDROID_DL_LOCAL_PATH)
LOCAL_MODULE := android-dl
LOCAL_SRC_FILES := \
	android-dl.cpp \
	jni.cpp \
	common.cpp
LOCAL_C_INCLUDES := $(LOCAL_PATH)/inc
# Avoid libstdc++ dependency -- we only use C++ as "better C"
LOCAL_CFLAGS += -W -Wall -nodefaultlibs -fno-rtti -fno-exceptions
LOCAL_LDLIBS := -llog
# Ensure our dependees can include <android-dl.h> too
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/inc

LOCAL_SHARED_LIBRARIES := dl log

include $(BUILD_SHARED_LIBRARY)

#
# googletest
#

ifeq ($(ANDROID_DL_TEST),1)

include $(CLEAR_VARS)

LOCAL_PATH := $(ANDROID_DL_LOCAL_PATH)
LOCAL_MODULE := android-dl_test
LOCAL_SRC_FILES := android-dl_test.cpp
LOCAL_SHARED_LIBRARIES := android-dl
LOCAL_STATIC_LIBRARIES := googletest_main

include $(BUILD_EXECUTABLE)

endif