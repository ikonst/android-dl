LOCAL_PATH := $(call my-dir)

# googletest-based tester

include $(CLEAR_VARS)

LOCAL_MODULE := android-dl_test
LOCAL_SRC_FILES := test.cpp
LOCAL_SHARED_LIBRARIES := android-dl
LOCAL_STATIC_LIBRARIES := googletest_main

include $(BUILD_EXECUTABLE)

# a library for the tester to load

include $(CLEAR_VARS)

LOCAL_MODULE := android-dl_testlib
LOCAL_SRC_FILES := lib.cpp

include $(BUILD_SHARED_LIBRARY)

# import modules at the end, since they clobber LOCAL_PATH

$(call import-module,third_party/googletest)
