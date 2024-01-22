########################################################################################################################
#
# Specialized function for shorter and more human-readable creation of build targets
#
# Example:
# MakeTarget (
#     NAME some-target
#     TYPE LIBRARY
#     ALIAS some::target
#     HEADERS
#         PUBLIC
#             <Public headers>
#         PRIVATE
#             <Private headers>
#     SOURCES <sources>
#     DEPENDS <the targets on which this target depends>
#     INCLUDE_DIRECTORIES [SYSTEM] [AFTER|BEFORE]
#         <INTERFACE|PUBLIC|PRIVATE> [items1...]
#         [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...]
#     LINK_LIBRARIES
#         PUBLIC
#             <Public link targets>
#         PRIVATE
#             <Private link targets>
#     PROPERTIES
#         item1 value1...
#     DEFINITIONS
#         "key1=value1"...
# )
#
# This call will create a library named some-target, the library type will be obtained from the BUILD_SHARED_LIBS
# option. An alias some::target will be created pointing to this library. Otherwise, all other actions are similar
# to the argument names.
#
# Important!
# * All arguments passed to LINK_LIBRARIES are automatically placed in DEPENDS and do not need to be duplicated.
# * If the target type is TEST, it will automatically be set to run from CTest.
# * Arguments passed to the INCLUDE_DIRECTORIES field are completely similar to the target_include_directories()
#   call.
# * The PUBLIC_HEADER property is automatically set for all public headers.
#
# Call arguments:
# * NAME - Target Name
# * TYPE - Target Type: APPLICATION, LIBRARY, TEST
# * ALIAS - Alias for this target
# * HEADERS - Project header files
# * SOURCES - Project source files
# * DEPENDS - Targets that must be compiled before this target can be compiled
# * INCLUDE_DIRECTORIES - Directories to be connected to this target
# * LINK_LIBRARIES - Targets linkable to this target
# * PROPERTIES - The properties of this target
# * DEFINITIONS - Definitions of this target
#
########################################################################################################################

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

    # Report an error if unknown arguments are passed

    if (MT_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Unknown keywords given to MakeTarget(): ${MT_UNPARSED_ARGUMENTS}")
    endif ()

    # Report an error if no target name is passed

    if (NOT DEFINED MT_NAME)
        message(FATAL_ERROR "You must enter the name of the target")
    endif ()

    # Report an error if the target type is not passed

    if (NOT DEFINED MT_TYPE)
        message(FATAL_ERROR "You must specify the target type APPLICATION, LIBRARY or TEST")
    endif ()
    
    # Report an error if an invalid target type is passed

    if (NOT "${MT_TYPE}" STREQUAL "APPLICATION" AND
        NOT "${MT_TYPE}" STREQUAL "LIBRARY" AND
        NOT "${MT_TYPE}" STREQUAL "TEST")
        message(FATAL_ERROR "You must specify the target type APPLICATION, LIBRARY or TEST")
    endif ()

    # Print message

    if ("${MT_TYPE}" STREQUAL "APPLICATION")
        message (STATUS "Comfiguring application ${MT_NAME}")
    elseif ("${MT_TYPE}" STREQUAL "TEST")
        message (STATUS "Comfiguring test ${MT_NAME}")
    elseif ("${MT_TYPE}" STREQUAL "LIBRARY")
        message (STATUS "Comfiguring library ${MT_NAME}")
    endif ()

    # Creating a target

    if ("${MT_TYPE}" STREQUAL "APPLICATION" OR "${MT_TYPE}" STREQUAL "TEST")
        add_executable (${MT_NAME})
        
        if (DEFINED MT_ALIAS)
            message (WARNING "ALIAS cannot be used for a executable file")
        endif ()
    else ()

        # Library type calculation

        if (BUILD_SHARED_LIBS)
            set (MT_LIBRARY_TYPE SHARED)
        else ()
            set (MT_LIBRARY_TYPE STATIC)
        endif ()

        add_library (${MT_NAME} ${MT_LIBRARY_TYPE})
        
        # Creating an alias

        if (NOT "${MT_ALIAS}" STREQUAL "")
            add_library (${MT_ALIAS} ALIAS ${MT_NAME})
        endif ()
    endif ()

    # Parsing of parameters passed to HEADERS

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

    # Including directories

    if (NOT "${MT_INCLUDE_DIRECTORIES}" STREQUAL "")
        set (options SYSTEM AFTER BEFORE)
        set (oneValueArgs "")
        set (multiValueArgs INTERFACE PUBLIC PRIVATE)
        cmake_parse_arguments (MT_INCLUDE_DIRECTORIES "${options}" "${oneValueArgs}" "${multiValueArgs}" ${MT_INCLUDE_DIRECTORIES})

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

    # Connecting compilation dependencies

    if (NOT "${MT_DEPENDS}" STREQUAL "")
        add_dependencies (${MT_NAME} ${MT_DEPENDS} ${MT_LINK_LIBRARIES})
    endif ()

    # Linking to external libraries

    if (NOT "${MT_LINK_LIBRARIES}" STREQUAL "")
        set (options "")
        set (oneValueArgs "")
        set (multiValueArgs INTERFACE PUBLIC PRIVATE)
        cmake_parse_arguments (MT_LINK_LIBRARIES "${options}" "${oneValueArgs}" "${multiValueArgs}" ${MT_LINK_LIBRARIES})

        target_link_libraries (${MT_NAME}
            INTERFACE ${MT_LINK_LIBRARIES_INTERFACE}
            PUBLIC ${MT_LINK_LIBRARIES_PUBLIC}
            PRIVATE ${MT_LINK_LIBRARIES_PRIVATE} ${MT_LINK_LIBRARIES_UNPARSED_ARGUMENTS}
        )
    endif ()

    # Setting properties

    if (NOT "${MT_PROPERTIES}" STREQUAL "")
        set_target_properties (${MT_NAME} PROPERTIES ${MT_PROPERTIES})
    endif ()

    # Setting compilation values

    if (NOT "${MT_DEFINITIONS}" STREQUAL "")
        add_compile_definitions (${MT_NAME} ${MT_DEFINITIONS})
    endif ()

    # Configure CTest startup if the goal is to test

    if ("${MT_TYPE}" STREQUAL "TEST")
        add_test (
            NAME ${MT_NAME}
            COMMAND $<TARGET_FILE:${MT_NAME}>
        )
    endif ()
endmacro ()