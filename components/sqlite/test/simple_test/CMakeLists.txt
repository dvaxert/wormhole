# Find the dependencies

find_package(GTest REQUIRED)

# Configure test target

MakeTarget (
    NAME simple-sqlite-test
    TYPE TEST
    SOURCES 
        main.cc
        test.cc
    PROPERTIES
        FOLDER tests
    LINK_LIBRARIES
        wormhole::sqlite
        GTest::Main
        GTest::GTest
)
