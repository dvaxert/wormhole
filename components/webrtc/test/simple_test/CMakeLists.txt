# Find the dependencies

find_package(GTest REQUIRED)

# Configure test target

MakeTarget (
    NAME simple-webrtc-test
    TYPE TEST
    SOURCES 
        main.cc
        test.cc
    PROPERTIES
        FOLDER tests
    LINK_LIBRARIES
        wormhole::webrtc
        GTest::Main
        GTest::GTest
)
