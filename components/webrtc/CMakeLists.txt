project(wormhole-webrtc LANGUAGES CXX)

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
    NAME wormhole-webrtc
    TYPE LIBRARY
    ALIAS wormhole::webrtc
    HEADERS
        PUBLIC
            ${${PROJECT_NAME}_HEADERS}
    SOURCES ${${PROJECT_NAME}_SOURCES}
    INCLUDE_DIRECTORIES
        $<BUILD_INTERFACE:${${PROJECT_NAME}_INCLUDE_DIR}>
        $<INSTALL_INTERFACE:include>
    PROPERTIES
        OUTPUT_NAME webrtc
        FOLDER components
    LINK_LIBRARIES
        PUBLIC
            wormhole::core
)

if (BUILD_TESTING)
    add_subdirectory (test)
endif ()
