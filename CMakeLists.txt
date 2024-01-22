cmake_minimum_required (VERSION 3.18)
project (wormhole
    VERSION 1.0.0
    DESCRIPTION "Application for creating p2p connections"
    HOMEPAGE_URL "https://github.com/dvaxert/wormhole"
    LANGUAGES CXX
)

########################################################################################################################
# Adding paths to cmake modules and connecting the required modules
########################################################################################################################

list (APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include (NestingFileSearch)
include (ProjectSettings)
include (MakeTarget)
include (GenerateDependenciesGraph)

########################################################################################################################
# Project build options
########################################################################################################################

ProjectOption (BUILD_APPS          "Build the application when building the project" ON)
ProjectOption (BUILD_SHARED_LIBS   "Build the project as a dynamic library"          ON)
ProjectOption (BUILD_DRIVER        "Build the driver when building the project"      ON)
ProjectOption (BUILD_TESTING       "Build tests for the project"                     OFF)
ProjectOption (BUILD_EXAMPLE       "Build examples for a project"                    OFF)
ProjectOption (BUILD_GRAPH         "Build graph of dependencies"                     OFF)
ProjectOption (BUILD_DOCUMENTATION "Generate documentation when building a project"  OFF)
ProjectOption (ENABLE_INSTALL      "Generate a target for project installation"      OFF)
ProjectOption (ENABLE_PEDANTIC     "Enable the display of additional warnings"       OFF)
ProjectOption (ENABLE_WALL         "Handle all compiler warnings with errors"        OFF)
ProjectOption (ENABLE_COVERAGE     "Run coverage"                                    OFF)
ProjectOption (ENABLE_SANITIZER    "Run static analysis"                             OFF)
ProjectOption (MSVC_STATIC_RUNTIME "Use static runtime on windows"                   OFF) # only for windows

########################################################################################################################
# Print current project settings
########################################################################################################################

ShowProjectSettings()

########################################################################################################################
# Project build settings
########################################################################################################################

set (CMAKE_CXX_STANDARD 17)
set (CMAKE_CXX_STANDARD_REQUIRED ON)
set (CMAKE_EXPORT_COMPILE_COMMANDS ON)
set_property (GLOBAL PROPERTY LINKER_LANGUAGE CXX)

########################################################################################################################
# Configuring project output directories
########################################################################################################################

set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib) 

########################################################################################################################
# Operation system specific project build settings
########################################################################################################################

if (MSVC) # TODO
    set (CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON) #TODO
    set_property (GLOBAL PROPERTY USE_FOLDERS ON)
    string (APPEND CMAKE_CXX_FLAGS " /MP")
    string (APPEND CMAKE_CXX_FLAGS_RELEASE " /Zi")
    
    string (APPEND CMAKE_DEBUG_POSTFIX "_dbg")

    if (MSVC AND ${MSVC_STATIC_RUNTIME})
        set (FLAG_VARS 
            CMAKE_CXX_FLAGS 
            CMAKE_CXX_FLAGS_DEBUG 
            CMAKE_CXX_FLAGS_RELEASE
            CMAKE_CXX_FLAGS_MINSIZEREL 
            CMAKE_CXX_FLAGS_RELWITHDEBINFO
        )

        foreach (FLAG_VAR ${FLAG_VARS})
            if (${FLAG_VAR} MATCHES "/MD")
                string (REGEX REPLACE "/MD" "/MT" ${FLAG_VAR} "${${FLAG_VAR}}")
            endif ()
        endforeach ()
        
        string (APPEND CMAKE_DEBUG_POSTFIX "_mt")
        string (APPEND CMAKE_RELEASE_POSTFIX "_mt")
    else ()
        string (APPEND CMAKE_DEBUG_POSTFIX "_md")
        string (APPEND CMAKE_RELEASE_POSTFIX "_md")
    endif ()
endif ()

########################################################################################################################
# Enable coverage
########################################################################################################################

if (ENABLE_COVERAGE AND UNIX)
    string (APPEND CMAKE_CXX_FLAGS " --coverage -g")
    
    set (FLAG_VARS 
        CMAKE_CXX_FLAGS 
        CMAKE_CXX_FLAGS_DEBUG 
        CMAKE_CXX_FLAGS_RELEASE
        CMAKE_CXX_FLAGS_MINSIZEREL 
        CMAKE_CXX_FLAGS_RELWITHDEBINFO
    )

    foreach (FLAG_VAR ${FLAG_VARS})
        if (${FLAG_VAR} MATCHES "O1|O2|O3")
            string (REGEX REPLACE "O1|O2|O3" "O0" ${FLAG_VAR} "${${FLAG_VAR}}")
        endif ()
    endforeach ()

    find_package(Threads REQUIRED)
endif ()

########################################################################################################################
# Enable Wall
########################################################################################################################

if (ENABLE_WALL)
    if (MSVC)
        string (APPEND CMAKE_CXX_FLAGS " /Wall")
    elseif (UNIX)
        string (APPEND CMAKE_CXX_FLAGS " -Wall")
    endif ()
endif ()

########################################################################################################################
# Enable pedantic
########################################################################################################################

if (ENABLE_PEDANTIC)
    if (MSVC)
        string (APPEND CMAKE_CXX_FLAGS " /W4")
    elseif (UNIX)
        string (APPEND CMAKE_CXX_FLAGS " -pedantic")
    endif ()
endif ()

########################################################################################################################
# Enable sanitizer
########################################################################################################################

if (ENABLE_SANITIZER)
    if (MSVC)
        string (APPEND CMAKE_CXX_FLAGS " /fsanitize=address")
    elseif (UNIX)
        string (APPEND CMAKE_CXX_FLAGS " -fsanitize=address")
    endif ()
endif ()

########################################################################################################################
# Setting additional values for testing
########################################################################################################################

if (BUILD_TESTING)
    include (CTest)
    enable_testing ()
endif ()

########################################################################################################################
# Adding subprojects
########################################################################################################################

add_subdirectory (core)
add_subdirectory (components)

if (BUILD_APPS)
    add_subdirectory (app)
endif ()

if (BUILD_DRIVER)
    add_subdirectory (os_specific)
endif ()

if (BUILD_GRAPH)
    GenerateDependenciesGraph (
        NAME ${PROJECT_NAME}
        FORMAT PNG
        OUTPUT_PATH ${CMAKE_BINARY_DIR}/doc
    )
endif ()

if (BUILD_DOCUMENTATION)
    find_package (Doxygen REQUIRED OPTIONAL_COMPONENTS dot mscgen dia)
    
    set (DOXYGEN_RECURSIVE YES)
    set (DOXYGEN_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/doc")
    set (DOXYGEN_GENERATE_HTML YES)
    set (DOXYGEN_INCLUDE_FILE_PATTERNS *.h *.cc *.dox)
    set (DOXYGEN_EXCLUDE_FILE_PATTERNS */test/*)

    doxygen_add_docs (wormhole-docs
        doc/doxyfiles
        app
        core
        components
        os_specific
        ALL
    )

endif ()