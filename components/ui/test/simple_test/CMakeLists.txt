# Find the dependencies

find_package(GTest REQUIRED)

# Configure test target

MakeTarget (
    NAME simple-ui-test
    TYPE TEST
    SOURCES 
        main.cc
        test.cc
    PROPERTIES
        FOLDER tests
    LINK_LIBRARIES
        wormhole::ui
        GTest::Main
        GTest::GTest
)
