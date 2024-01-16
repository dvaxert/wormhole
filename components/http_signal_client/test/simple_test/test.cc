#include <gtest/gtest.h>
#include <wormhole/signal/http.h>

TEST(HttpSimpleTestingClassTest, simple_test) {
	HttpSimpleTestingClass c{};
	ASSERT_EQ(c.GetFive(), 5);
}
