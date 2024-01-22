project(wormhole-windows-driver LANGUAGES CXX)


set (${PROJECT_NAME}_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
set (${PROJECT_NAME}_SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)

# Recursive search for library source files

NestingFileSearch (${PROJECT_NAME}_HEADERS
    RECURSIVE
    EXTENSIONS ".h"
    DIRECTORIES "${${PROJECT_NAME}_INCLUDE_DIR}"
)

NestingFileSearch (${PROJECT_NAME}_SOURCES
    RECURSIVE
    EXTENSIONS ".cc"
    DIRECTORIES "${${PROJECT_NAME}_SOURCES_DIR}"
)

# Creating a target for the library

MakeTarget (
    NAME wormhole-windows-driver
    TYPE LIBRARY
    ALIAS wormhole::driver
    HEADERS
        PUBLIC
            ${${PROJECT_NAME}_HEADERS}
    SOURCES ${${PROJECT_NAME}_SOURCES}
    INCLUDE_DIRECTORIES
        PUBLIC
            ${${PROJECT_NAME}_INCLUDE_DIR}
    PROPERTIES
        OUTPUT_NAME whdriver
)

if (BUILD_TESTING)
    add_subdirectory (test)
endif ()
