#include <gtest/gtest.h>
#include <wormhole_driver/wormhole_driver.h>

TEST(DriverSimpleTestingClassTest, simple_test) {
	DriverSimpleTestingClass c{};
	ASSERT_EQ(c.GetFive(), 5);
}
