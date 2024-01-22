#include <gtest/gtest.h>
#include <wormhole/webrtc/webrtc.h>

TEST(WebrtcSimpleTestingClassTest, simple_test) {
	WebrtcSimpleTestingClass c{};
	ASSERT_EQ(c.GetFive(), 5);
}
