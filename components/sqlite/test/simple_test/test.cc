#include <gtest/gtest.h>
#include <wormhole/sqlite/sqlite.h>

TEST(SqliteSimpleTestingClassTest, simple_test) {
	SqliteSimpleTestingClass c{};
	ASSERT_EQ(c.GetFive(), 5);
}
