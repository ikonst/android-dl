#include <gtest/gtest.h>

#include <android-dl.h>

TEST(AndroidDlTest, OpenNonExistent)
{
	EXPECT_EQ(NULL, android_dlopen("nonexistent.so"));
}
