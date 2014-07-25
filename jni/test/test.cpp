#include <gtest/gtest.h>

#include <android-dl.h>

TEST(AndroidDlTest, OpenNonExistent)
{
	EXPECT_EQ(NULL, android_dlopen("nonexistent.so"));
}

TEST(AndroidDlTest, OpenTest)
{
	void * lib = android_dlopen("libandroid-dl_testlib.so");
	EXPECT_TRUE(lib != NULL);
}
