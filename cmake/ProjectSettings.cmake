########################################################################################################################
#
# This file describes functions for more convenient work with project settings
#
########################################################################################################################
#
# Function ProjectOption:
# It is used in a completely similar way to the normal option call. The additionally created value is written to an
# internal variable and can be output during the build process. The value can be displayed in the console using the
# ShowProjectSettings() call.
#
# Example:
# ProjectOption (BUILD_APPS "Build the application when building the project" ON)
#
# Call arguments:
# ProjectOption (NAME DESCRIPTION DEFAULT_VALUE)
#
########################################################################################################################
#
# Function ProjectVariable:
# Similar to ProjectOption, used to specify variables whose values can be specified by the user when building. The value
# can be displayed in the console using the ShowProjectSettings() call.
#
# Example:
# ProjectVariable (ADDITIONAL_CXX_FLAGS "Additional compilation flags for the project" "-Wall")
#
# Call arguments:
# ProjectVariable (NAME DESCRIPTION DEFAULT_VALUE)
#
########################################################################################################################
#
# Function AddDataToPrint:
# Used to add values that will later be displayed in the terminal using the ShowProjectSettings() function.
#
# Example:
# ProjectVariable (ADDITIONAL_CXX_FLAGS "Additional compilation flags for the project")
#
# AddDataToPrint(NAME DESCRIPTION)
#
########################################################################################################################
#
# Function ShowProjectSettings:
# Outputs all values added earlier using ProjectOption(), ProjectVariable() and AddDataToPrint() functions to the
# terminal in the form of a table.
#
# Example:
# ShowProjectSettings()
#
########################################################################################################################

include (FormatMessage)

########################################################################################################################

macro (ProjectOption OPTION_NAME OPTION_DESCRIPTION OPTION_DEFAULT_VALUE)
    option (${OPTION_NAME} ${OPTION_DESCRIPTION} ${OPTION_DEFAULT_VALUE})
    AddDataToPrint (${OPTION_NAME} ${OPTION_DESCRIPTION})
endmacro ()

########################################################################################################################

macro (ProjectVariable VARIABLE_NAME VARIABLE_DESCRIPTION VARIABLE_DEFAULT_VALUE)
    if (NOT DEFINED ${VARIABLE_NAME})
        set (${VARIABLE_NAME} ${VARIABLE_DEFAULT_VALUE})
    endif ()
    AddDataToPrint (${VARIABLE_NAME} ${VARIABLE_DESCRIPTION})
endmacro ()

########################################################################################################################

function (AddDataToPrint VALUE_NAME VALUE_DESCRIPTION)
        get_property (PRITNABLE_OPTIONS_TMP GLOBAL PROPERTY PRITNABLE_OPTIONS)

        if (NOT "${PRITNABLE_OPTIONS_TMP}" MATCHES ${VALUE_NAME})
            list (APPEND PRITNABLE_OPTIONS_TMP "${VALUE_NAME}:${VALUE_DESCRIPTION}")
            set_property (GLOBAL PROPERTY PRITNABLE_OPTIONS "${PRITNABLE_OPTIONS_TMP}")
        else ()
            message (WARNING "Value ${VALUE_NAME} already exists")
        endif ()
endfunction ()

########################################################################################################################

macro (ShowProjectSettings)
    get_property(SBO_PRITNABLE_OPTIONS GLOBAL PROPERTY PRITNABLE_OPTIONS)

    # Header

    FormatMessage (NOTICE ",{78:center:-}," "-")
    FormatMessage (NOTICE "|{78:center: }|" "${PROJECT_NAME} build settings")
    FormatMessage (NOTICE "|{78:center:-}|" "-")
    FormatMessage (NOTICE "|{22:center: }|{7:center: }|{47:center: }|" "Name" "Value" "Description")
    FormatMessage (NOTICE "|{78:center:-}|" "-")

    # Print values

    foreach(VALUE ${SBO_PRITNABLE_OPTIONS})
        string (FIND ${VALUE} ":" SBO_SEPARATOR_POSITION)
        
        math (EXPR DESCRIPTION_BEGIN "${SBO_SEPARATOR_POSITION} + 1" OUTPUT_FORMAT DECIMAL)
        string (SUBSTRING "${VALUE}" 0 ${SBO_SEPARATOR_POSITION} SBO_OPTION_NAME)
        string (SUBSTRING "${VALUE}" ${DESCRIPTION_BEGIN} -1 SBO_OPTION_DESCRIPTION)

        FormatMessage (NOTICE "| {20} |{7:center: }| {45} |" "${SBO_OPTION_NAME}" "${${SBO_OPTION_NAME}}" "${SBO_OPTION_DESCRIPTION}")
    endforeach()

    # End of table

    FormatMessage (NOTICE "`{78:center:-}`" "-")
endmacro ()