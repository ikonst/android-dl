include $(CLEAR_VARS)

LOCAL_MODULE := android-dl
LOCAL_SRC_FILES := \
	android-dl/android-dl.cpp \
	android-dl/jni.cpp \
	android-dl/common.cpp
LOCAL_C_INCLUDES :=
# Avoid libstdc++ dependency -- we only use C++ as "better C"
LOCAL_CFLAGS += -W -Wall -nodefaultlibs -fno-rtti -fno-exceptions
LOCAL_LDLIBS := -llog

LOCAL_SHARED_LIBRARIES := dl log

include $(BUILD_SHARED_LIBRARY)
