

macro (MakeTarget)
    set (options "")
    set (oneValueArgs
        NAME
        TYPE
        ALIAS
    )
    set (multiValueArgs
        HEADERS
        SOURCES
        DEPENDS
        INCLUDE_DIRECTORIES
        LINK_LIBRARIES
        PROPERTIES
        DEFINITIONS
    )
    cmake_parse_arguments (MT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Если переданы неизвестные аргументы

    if (MT_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to MakeTarget(): ${MT_UNPARSED_ARGUMENTS}")
    endif ()

    # Если не передано имя цели

    if (NOT DEFINED MT_NAME)
        message(FATAL_ERROR "You must enter the name of the target")
    endif ()

    # Если не передан тип таргета

    if (NOT DEFINED MT_TYPE)
        message(FATAL_ERROR "You must specify the target type APPLICATION, LIBRARY or TEST")
    endif ()
    
    # Если передан некорректный тип таргета

    if (NOT "${MT_TYPE}" STREQUAL "APPLICATION" AND
        NOT "${MT_TYPE}" STREQUAL "LIBRARY" AND
        NOT "${MT_TYPE}" STREQUAL "TEST")
        message(FATAL_ERROR "You must specify the target type APPLICATION, LIBRARY or TEST")
    endif ()

    # Создаем таргет

    if ("${MT_TYPE}" STREQUAL "APPLICATION" OR "${MT_TYPE}" STREQUAL "TEST")
        add_executable (${MT_NAME})
        
        if (DEFINED MT_ALIAS)
            message (AUTHOR_WARNING "ALIAS cannot be used for a executable file")
        endif ()
    else ()

        # Расчет типа библиотеки

        if (BUILD_SHARED_LIBS)
            set (MT_LIBRARY_TYPE SHARED)
        else ()
            set (MT_LIBRARY_TYPE STATIC)
        endif ()

        add_library (${MT_NAME} ${MT_LIBRARY_TYPE})
        
        # Создание алиаса

        if (NOT "${MT_ALIAS}" STREQUAL "")
            add_library (${MT_ALIAS} ALIAS ${MT_NAME})
        endif ()
    endif ()

    # Парсим хедеры

    if (NOT "${MT_HEADERS}" STREQUAL "")
        set (options "")
        set (oneValueArgs "")
        set (multiValueArgs
            PUBLIC
            PRIVATE
        )
        cmake_parse_arguments (MT_HEADERS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${MT_HEADERS})
        
        if (MT_HEADERS_UNPARSED_ARGUMENTS)
            message(FATAL_ERROR "Unknown keywords given to MakeTarget HEADERS: ${MT_HEADERS_UNPARSED_ARGUMENTS}")
        endif ()

        set_target_properties (${MT_NAME} PROPERTIES
            PUBLIC_HEADER ${MT_HEADERS_PUBLIC}
        )

    endif ()

    target_sources (${MT_NAME}
        PUBLIC
            ${MT_HEADERS_PUBLIC}
        PRIVATE
            ${MT_HEADERS_PRIVATE}
            ${MT_SOURCES}
    )

    # Подключение директорий

    if (NOT "${MT_INCLUDE_DIRECTORIES}" STREQUAL "")
        set (options SYSTEM AFTER BEFORE)
        set (oneValueArgs "")
        set (multiValueArgs INTERFACE PUBLIC PRIVATE)
        cmake_parse_arguments (MT_INCLUDE_DIRECTORIES "${options}" "${oneValueArgs}" "${multiValueArgs}" ${MT_HEADERS})

        unset (MT_INCLUDE_DIRECTORIES_ARGUMENTS)
        if (MT_INCLUDE_DIRECTORIES_SYSTEM)
            string (APPEND MT_INCLUDE_DIRECTORIES_ARGUMENTS "SYSTEM ")
        endif ()

        if (MT_INCLUDE_DIRECTORIES_AFTER)
            string (APPEND MT_INCLUDE_DIRECTORIES_ARGUMENTS "AFTER ")
        endif ()
        
        if (MT_INCLUDE_DIRECTORIES_BEFORE)
            string (APPEND MT_INCLUDE_DIRECTORIES_ARGUMENTS "BEFORE ")
        endif ()

        target_include_directories (${MT_NAME} ${MT_INCLUDE_DIRECTORIES_ARGUMENTS}
            INTERFACE ${MT_INCLUDE_DIRECTORIES_INTERFACE}
            PUBLIC ${MT_INCLUDE_DIRECTORIES_PUBLIC}
            PRIVATE ${MT_INCLUDE_DIRECTORIES_PRIVATE}
        )
    endif ()

    # Подключение зависимостей компиляции

    if (NOT "${MT_DEPENDS}" STREQUAL "")
        add_dependencies (${MT_NAME} ${MT_DEPENDS} ${MT_LINK_LIBRARIES})
    endif ()

    # Линковка со внешними библиотеками

    if (NOT "${MT_LINK_LIBRARIES}" STREQUAL "")
        target_link_libraries (${MT_NAME} ${MT_LINK_LIBRARIES})
    endif ()

    # Установка значений

    if (NOT "${MT_PROPERTIES}" STREQUAL "")
        set_target_properties (${MT_NAME} PROPERTIES ${MT_PROPERTIES})
    endif ()

    # Установка значений компиляции

    if (NOT "${MT_DEFINITIONS}" STREQUAL "")
        add_compile_definitions (${MT_NAME} ${MT_DEFINITIONS})
    endif ()

    # Настраиваем запуск через CTest если цель - тест

    if ("${MT_TYPE}" STREQUAL "TEST")
        add_test (
            NAME ${MT_NAME}
            COMMAND $<TARGET_FILE:${MT_NAME}>
        )
    endif ()

    #message (STATUS "MT_NAME - ${MT_NAME}" )
    #message (STATUS "MT_TYPE - ${MT_TYPE}" )
    #message (STATUS "MT_LIBRARY_TYPE - ${MT_LIBRARY_TYPE}" )
    #message (STATUS "MT_ALIAS - ${MT_ALIAS}" )
    #message (STATUS "MT_HEADERS_PUBLIC - ${MT_HEADERS_PUBLIC}")
    #message (STATUS "MT_HEADERS_PRIVATE - ${MT_HEADERS_PRIVATE}")
    #message (STATUS "MT_SOURCES - ${MT_SOURCES}" )
    #message (STATUS "MT_DEPENDS - ${MT_DEPENDS}" )
    #message (STATUS "MT_INCLUDE_DIRECTORIES - ${MT_INCLUDE_DIRECTORIES}" )
    #message (STATUS "MT_LINK_LIBRARIES - ${MT_LINK_LIBRARIES}" )
    #message (STATUS "MT_PROPERTIES - ${MT_PROPERTIES}" )
    #message (STATUS "MT_DEFINITIONS - ${MT_DEFINITIONS}" )
    #message (STATUS "MT_INCLUDE_DIRECTORIES_ARGUMENTS - ${MT_INCLUDE_DIRECTORIES_ARGUMENTS}" )
    #message (STATUS "MT_INCLUDE_DIRECTORIES_INTERFACE - ${MT_INCLUDE_DIRECTORIES_INTERFACE}" )
    #message (STATUS "MT_INCLUDE_DIRECTORIES_PUBLIC - ${MT_INCLUDE_DIRECTORIES_PUBLIC}" )
    #message (STATUS "MT_INCLUDE_DIRECTORIES_PRIVATE - ${MT_INCLUDE_DIRECTORIES_PRIVATE}" )
endmacro ()