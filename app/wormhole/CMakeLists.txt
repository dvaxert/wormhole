project(wormhole-app LANGUAGES CXX)

set (${PROJECT_NAME}_SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)

# Рекурсивный поиск исходных файлов библиотеки

NestingFileSearch (${PROJECT_NAME}_SOURCES
    RECURSIVE
    EXTENSIONS ".cc"
    DIRECTORIES "${${PROJECT_NAME}_SOURCES_DIR}"
)

# Создание цели для библиотеки

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
