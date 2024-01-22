# Find the dependencies

find_package(GTest REQUIRED)

# Configure test target

MakeTarget (
    NAME simple-windows-driver-test
    TYPE TEST
    SOURCES 
        main.cc
        test.cc
    PROPERTIES
        FOLDER tests
    LINK_LIBRARIES
        wormhole::driver
        GTest::Main
        GTest::GTest
)
