
# File search which allows to save nesting of files in the project when working in MSVC

macro (NestingFileSearch OUTPUT)
    set (options RECURSIVE APPEND)
    set (oneValueArgs EXTENSION DIRECTORY)
    set (multiValueArgs "")
    cmake_parse_arguments (NFS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Returns an error if the passed values are incorrect

    if (NFS_UNPARSED_ARGUMENTS)
        message (FATAL_ERROR "Unknown keywords given to NestingFileSearch(): ${NFS_UNPARSED_ARGUMENTS}")
    endif ()

    if (NOT NFS_APPEND)
        unset (OUTPUT)
    endif ()

    if (NFS_RECURSIVE)
        set (GLOB_TYPE GLOB_RECURSE)
    else ()
        set (GLOB_TYPE GLOB)
    endif ()

    string (REGEX REPLACE "(.*/).*" "\\1" NFS_EXTERNAL_PATH "${NFS_DIRECTORY}")
    file (${GLOB_TYPE} NFS_LIST_DIRECTORIES LIST_DIRECTORIES TRUE "${NFS_DIRECTORY}/*")
    list (APPEND NFS_LIST_DIRECTORIES ${NFS_DIRECTORY})

    foreach (NFS_DIRECTORY ${NFS_LIST_DIRECTORIES})
        if (IS_DIRECTORY ${NFS_DIRECTORY})
            string (REGEX REPLACE "${NFS_EXTERNAL_PATH}(.*)" "\\1" NFS_GROUP_NAME "${NFS_DIRECTORY}")

            file (GLOB NFS_FILES_IN_DIRECTORY LIST_DIRECTORIES FALSE "${NFS_DIRECTORY}/*${NFS_EXTENSION}")

            if (MSVC)
                source_group ("${NFS_GROUP_NAME}" FILES ${NFS_FILES_IN_DIRECTORY})
            endif ()

            list (APPEND ${OUTPUT} ${NFS_FILES_IN_DIRECTORY})
        endif ()
    endforeach ()

endmacro ()