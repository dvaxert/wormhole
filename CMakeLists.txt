cmake_minimum_required (VERSION 3.18)
project (wormhole VERSION 1.0.0 LANGUAGES CXX)

# Determine if wormhole is built as a subproject (using add_subdirectory) or if it is the master project.

if (NOT DEFINED WORMHOLE_MASTER_PROJECT)
  set (WORMHOLE_MASTER_PROJECT OFF)

  if (CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    set (WORMHOLE_MASTER_PROJECT ON)
  endif ()
endif ()


# Set an additional path to the CMake modules and connect them

list (APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(NestingFileSearch)
include(CMakeDependentOption)


# Options available for project customization

cmake_dependent_option (WORMHOLE_BUILD_SHARED_LIBS "Build the project as a dynamic library" "${BUILD_SHARED_LIBS}" "WORMHOLE_MASTER_PROJECT" ${WORMHOLE_MASTER_PROJECT})
cmake_dependent_option (WORMHOLE_BUILD_TESTING "Build tests for the project" "${BUILD_TESTING}" "WORMHOLE_MASTER_PROJECT" ${WORMHOLE_MASTER_PROJECT})

option (WORMHOLE_INSTALL "Generate a target for project installation" ON)
option (WORMHOLE_BUILD_EXAMPLE "Build examples for a project" OFF)
option (WORMHOLE_GENERATE_DOCUMENTATION "Generate documentation when building a project" OFF)
option (WORMHOLE_PEDANTIC "Enable the display of additional warnings" OFF)
option (WORMHOLE_WERROR "Handle all compiler warnings with errors" OFF)
option (WORMHOLE_MSVC_STATIC_RUNTIME "Link static runtime libraries" OFF)


# Configuring project output directories

if (WORMHOLE_MASTER_PROJECT)
  set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
  set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib) 
endif ( )    


# Configuring project build options

set (CMAKE_CXX_STANDARD 17)
set (CMAKE_CXX_STANDARD_REQUIRED ON)
set_property (GLOBAL PROPERTY USE_FOLDERS ON)
set_property (GLOBAL PROPERTY LINKER_LANGUAGE CXX)
string (APPEND CMAKE_DEBUG_POSTFIX "_dbg")


# Additional options for building on Windows  
if (WIN32)
    set (CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

    if (MSVC AND ${WORMHOLE_MSVC_STATIC_RUNTIME})
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

if (WORMHOLE_BUILD_TESTING)
    include (CTest)
    enable_testing ()
endif ()


# Importing additional CMake modules

if (WORMHOLE_INSTALL)
    include (GNUInstallDirs)
endif ()


# Adding subdirectories to the project

add_subdirectory (lib)

if (WORMHOLE_BUILD_TESTING)
    add_subdirectory (test)
endif ()

if (WORMHOLE_BUILD_EXAMPLE)
    add_subdirectory (example)
endif ()