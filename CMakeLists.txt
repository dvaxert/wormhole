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
ProjectOption (ENABLE_WERROR       "Handle all compiler warnings with errors"        OFF)
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
set_property (GLOBAL PROPERTY LINKER_LANGUAGE CXX)

########################################################################################################################
# Operation system specific project build settings
########################################################################################################################

if (MSVC) # TODO
    set (CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON) #TODO
    set_property (GLOBAL PROPERTY USE_FOLDERS ON)
    
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
# Adding subprojects
########################################################################################################################

message (STATUS "Configuring wormhole core")
add_subdirectory (core)
add_subdirectory (components)

if (BUILD_APPS)
    add_subdirectory (app)
endif ()

if (BUILD_DRIVER)
    add_subdirectory (os_specific)
endif ()
