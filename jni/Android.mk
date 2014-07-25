LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

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
