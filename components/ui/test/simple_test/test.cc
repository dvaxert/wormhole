#include <gtest/gtest.h>
#include <wormhole/ui/ui.h>

TEST(UiSimpleTestingClassTest, simple_test) {
	UiSimpleTestingClass c{};
	ASSERT_EQ(c.GetFive(), 5);
}
