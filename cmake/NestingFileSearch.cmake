########################################################################################################################
#
# File search supporting nesting of files in the project and working also in MSVC
#
# Example:
#
# NestingFileSearch (SOME_HEADERS
#   RECURSIVE
#   DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/include" "${CMAKE_CURRENT_SOURCE_DIR}/generated"
#   EXTENSIONS ".h" ".hpp"
#   EXCLUDE_PATTERNS ".h.in" ".hpp.in" "internal"
# )
#
# In this case, NestingFileSearch will RECURSIVE (specified by the RECURSIVE parameter) all files with extensions ".h"
# and ".hpp" in directories "${CMAKE_CURRENT_SOURCE_DIR}/include" and "${CMAKE_CURRENT_SOURCE_DIR}/generated" will 
# exclude results with extensions ".h.in", ".hpp.in" and "internal" in the name or path all found files will be placed 
# in the SOME_HEADERS variable.
#
# Call arguments:
# OUTPUT - The variable into which the search results will be placed
# RECURSIVE - Search recursively
# APPEND - Supplement, not overwrite, the OUTPUT variable
# EXTENSIONS - File extensions to be found
# DIRECTORIES - Directories to be searched
# EXCLUDE_PATTERNS - A pattern that, if matched, will exclude the file from the search results.
#
########################################################################################################################

macro (NestingFileSearch OUTPUT)
    set (options
        RECURSIVE
        APPEND
    )
    set (oneValueArgs "")
    set (multiValueArgs
        EXTENSIONS
        DIRECTORIES
        EXCLUDE_PATTERNS
    )
    cmake_parse_arguments (NFS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Return error if unknown parameters are passed

    if (NFS_UNPARSED_ARGUMENTS)
        message (FATAL_ERROR "Unknown keywords given to NestingFileSearch(): ${NFS_UNPARSED_ARGUMENTS}")
    endif ()

    # Clear OUTPUT if no complement is required
    
    if (NOT NFS_APPEND)
        unset (OUTPUT)
    endif ()

    # Setting the search type recursive/non-recursive

    if (NFS_RECURSIVE)
        set (GLOB_TYPE GLOB_RECURSE)
    else ()
        set (GLOB_TYPE GLOB)
    endif ()

    # Directory traversal

    foreach (NFS_BASE_DIR ${NFS_DIRECTORIES})
        unset (NFS_LIST_DIRECTORIES)
        string (REGEX REPLACE "(.*/).*" "\\1" NFS_EXTERNAL_PATH "${NFS_BASE_DIR}")

        if (NFS_RECURSIVE)
            file (${GLOB_TYPE} NFS_LIST_DIRECTORIES LIST_DIRECTORIES TRUE "${NFS_BASE_DIR}/*")
        endif ()
        
        list (APPEND NFS_LIST_DIRECTORIES ${NFS_BASE_DIR})

        foreach (NFS_DIR ${NFS_LIST_DIRECTORIES})
            if (IS_DIRECTORY ${NFS_DIR})
                string (REGEX REPLACE "${NFS_EXTERNAL_PATH}(.*)" "\\1" NFS_GROUP_NAME "${NFS_DIR}")

                foreach (NFS_EXTENSION ${NFS_EXTENSIONS})
                    file (GLOB NFS_FILES_IN_DIRECTORY LIST_DIRECTORIES FALSE "${NFS_DIR}/*${NFS_EXTENSION}")
                endforeach ()

                if (MSVC)
                    source_group ("${NFS_GROUP_NAME}" FILES ${NFS_FILES_IN_DIRECTORY})
                endif ()

                list (APPEND ${OUTPUT} ${NFS_FILES_IN_DIRECTORY})
            endif ()
        endforeach ()
    endforeach ()

    foreach (PATTERN ${NFS_EXCLUDE_PATTERNS})
        foreach (VALUE ${${OUTPUT}})
            string (REGEX MATCH ${PATTERN} IS_MATCHED ${VALUE})

            if (NOT ${IS_MATCHED} STREQUAL "")
                list (REMOVE_ITEM ${OUTPUT} ${VALUE})
            endif ()
        endforeach ()
    endforeach ()

endmacro ()