project(wormhole-lib LANGUAGES CXX)


set (${PROJECT_NAME}_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
set (${PROJECT_NAME}_SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)

# Рекурсивный поиск исходных файлов библиотеки

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

# Создание цели для библиотеки

MakeTarget (
    NAME wormhole-lib
    TYPE LIBRARY
    ALIAS wormhole::core
    HEADERS
        PUBLIC
            ${${PROJECT_NAME}_HEADERS}
    SOURCES ${${PROJECT_NAME}_SOURCES}
    INCLUDE_DIRECTORIES
        $<BUILD_INTERFACE:${${PROJECT_NAME}_INCLUDE_DIR}>
        $<INSTALL_INTERFACE:include>
    PROPERTIES
        OUTPUT_NAME wormhole
)

if (BUILD_TESTING)
    add_subdirectory (test)
endif ()
