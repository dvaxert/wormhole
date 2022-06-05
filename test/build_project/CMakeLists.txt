
add_executable(build_test main.cc)

target_link_libraries(build_test wormhole)

add_test(
    NAME build_test
    COMMAND $<TARGET_FILE:build_test>
)