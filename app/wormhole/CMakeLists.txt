project(wormhole-app LANGUAGES CXX)

set (${PROJECT_NAME}_SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)

# Recursive search for library source files

NestingFileSearch (${PROJECT_NAME}_SOURCES
    RECURSIVE
    EXTENSIONS ".cc"
    DIRECTORIES "${${PROJECT_NAME}_SOURCES_DIR}"
)

# Creating a target for the application

MakeTarget (
    NAME wormhole-app
    TYPE APPLICATION
    SOURCES ${${PROJECT_NAME}_SOURCES}
    PROPERTIES
        OUTPUT_NAME wormhole
        FOLDER apps
    LINK_LIBRARIES
        PRIVATE
            wormhole::core
)
