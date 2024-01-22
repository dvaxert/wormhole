#include <gtest/gtest.h>
#include <wormhole/core.h>

TEST(CoreSimpleTestingClassTest, simple_test) {
	CoreSimpleTestingClass c{};
	ASSERT_EQ(c.GetFive(), 5);
}
