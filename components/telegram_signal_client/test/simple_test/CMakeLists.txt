# Find the dependencies

find_package(GTest REQUIRED)

# Configure test target

MakeTarget (
    NAME simple-telegram-test
    TYPE TEST
    SOURCES 
        main.cc
        test.cc
    PROPERTIES
        FOLDER tests
    LINK_LIBRARIES
        wormhole::telegramsignal
        GTest::Main
        GTest::GTest
)
