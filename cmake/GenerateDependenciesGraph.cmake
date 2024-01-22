########################################################################################################################
#
# Function for automatic generation of the project dependency graph
#
# Example:
# GenerateDependenciesGraph (
#   NAME ${PROJECT_NAME}
#   FORMAT PNG
#   OUTPUT_PATH ${CMAKE_BINARY_DIR}
# )
#
# As a result, the build will generate an image file in FORMAT format named NAME and it will be saved to the OUTPUT_PATH
# path.
#
# Available output formats: PNG, JPG, GIF, SVG, SVGZ, FIG, MIF, HPGL, PCL, IMAP, CMAPX, ISMAP, CMAP
#
# Call arguments:
# * NAME - Output file name
# * FORMAT - The format in which you want to save the image
# * OUTPUT_PATH - The path where you want to save the generated file
#
########################################################################################################################

find_program (DOT_EXECUTABLE dot)

if (DOT_EXECUTABLE)

    message (STATUS "Found Dot: ${DOT_EXECUTABLE}")

    function (GenerateDependenciesGraph)
        set (options "")
        set (oneValueArgs NAME FORMAT OUTPUT_PATH)
        set (multiValueArgs "")
        cmake_parse_arguments (GDG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        if (NFS_UNPARSED_ARGUMENTS)
            message (FATAL_ERROR "Unknown keywords given to GenerateDependenciesGraph(): ${GDG_UNPARSED_ARGUMENTS}")
        endif ()

        if ("${GDG_NAME}" STREQUAL "")
            message (FATAL_ERROR "It is necessary to specify the output file name in the GenerateDependenciesGraph() "
                                 "function.")
        endif ()

        if ("${GDG_FORMAT}" STREQUAL "")
            message (FATAL_ERROR "It is necessary to specify the output file format in the GenerateDependenciesGraph() "
                                 "function. Available options: PNG, JPG, GIF, SVG, SVGZ, FIG, MIF, HPGL, PCL, IMAP, "
                                 "CMAPX, ISMAP, CMAP")
        endif ()

        if ("${GDG_OUTPUT_PATH}" STREQUAL "")
            message (FATAL_ERROR "It is necessary to specify the path where you want to save the file")
        endif ()

        set (GDG_CORRECT_FORMATS PNG JPG GIF SVG SVGZ FIG MIF HPGL PCL IMAP CMAPX ISMAP CMAP)
        set (GDG_IS_FORMAT_CORRECT FALSE)
        foreach (VAL ${GDG_CORRECT_FORMATS})
            if ("${VAL}" STREQUAL "${GDG_FORMAT}")
                set (GDG_IS_FORMAT_CORRECT TRUE)
            endif ()
        endforeach ()
        
        if (NOT ${GDG_IS_FORMAT_CORRECT})
            message (FATAL_ERROR 
                     "An incorrect file format was passed to the GenerateDependenciesGraph() function: ${GDG_FORMAT}")
        endif ()

        string (TOLOWER "${GDG_FORMAT}" GDG_OUTPUT_FORMAT)

        add_custom_target (dependencies-graph ALL
            COMMAND ${CMAKE_COMMAND} --graphviz=${CMAKE_BINARY_DIR}/dot/${GDG_NAME}.dot .
            COMMAND ${CMAKE_COMMAND} -E make_directory ${GDG_OUTPUT_PATH}
            COMMAND ${DOT_EXECUTABLE}
                    -T${GDG_OUTPUT_FORMAT} ${CMAKE_BINARY_DIR}/dot/${GDG_NAME}.dot 
                    -o ${GDG_OUTPUT_PATH}/${GDG_NAME}.${GDG_OUTPUT_FORMAT}
            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
        )
        
        set_target_properties (dependencies-graph PROPERTIES FOLDER Doc)

    endfunction ()

else ()

    function (GenerateDependenciesGraph)
        message (WARNING "Dot required for GenerateDependenciesGraph()")
    endfunction ()

endif ()