#include <gtest/gtest.h>
#include <wormhole/signal/telegram.h>

TEST(TelegramSimpleTestingClassTest, simple_test) {
	TelegramSimpleTestingClass c{};
	ASSERT_EQ(c.GetFive(), 5);
}
