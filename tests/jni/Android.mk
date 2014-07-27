LOCAL_PATH := $(call my-dir)

#
# googletest-based native tester
#

ifeq ($(NATIVE_TEST),1)

include $(CLEAR_VARS)

LOCAL_MODULE := android-dl_test
LOCAL_SRC_FILES := native_test.cpp
LOCAL_SHARED_LIBRARIES := android-dl
LOCAL_STATIC_LIBRARIES := googletest_main
# Make sure we can import android-dl
$(call import-add-path,$(LOCAL_PATH)/../../..)

include $(BUILD_EXECUTABLE)

endif

#
# a library for the Java or native (GoogleTest) tester to load
#

include $(CLEAR_VARS)

LOCAL_MODULE := android-dl_testlib
LOCAL_SRC_FILES := lib.cpp
LOCAL_CFLAGS := -fvisibility=hidden

include $(BUILD_SHARED_LIBRARY)

#
# import modules at the end, since they clobber LOCAL_PATH
#

$(call import-module,third_party/googletest)
ifeq ($(NATIVE_TEST),1)
$(call import-module,android-dl/jni)
endif
