

include (FormatMessage)

macro (ProjectOption OPTION_NAME OPTION_DESCRIPTION OPTION_DEFAULT_VALUE)
    option (${OPTION_NAME} ${OPTION_DESCRIPTION} ${OPTION_DEFAULT_VALUE})
    AddDataToPrint (${OPTION_NAME} ${OPTION_DESCRIPTION})
endmacro ()

macro (ProjectVariable VARIABLE_NAME VARIABLE_DESCRIPTION VARIABLE_DEFAULT_VALUE)
    if (NOT DEFINED ${VARIABLE_NAME})
        set (${VARIABLE_NAME} ${VARIABLE_DEFAULT_VALUE})
    endif ()
    AddDataToPrint (${VARIABLE_NAME} ${VARIABLE_DESCRIPTION})
endmacro ()

function (AddDataToPrint OPTION_NAME OPTION_DESCRIPTION)
        get_property (PRITNABLE_OPTIONS_TMP GLOBAL PROPERTY PRITNABLE_OPTIONS)

        if (NOT "${PRITNABLE_OPTIONS_TMP}" MATCHES ${OPTION_NAME})
            list (APPEND PRITNABLE_OPTIONS_TMP "${OPTION_NAME}:${OPTION_DESCRIPTION}")
            set_property (GLOBAL PROPERTY PRITNABLE_OPTIONS "${PRITNABLE_OPTIONS_TMP}")
        else ()
            message (AUTHOR_WARNING "Option ${OPTION_NAME} already exists")
        endif ()
endfunction ()

macro (ShowProjectSettings)
    get_property(SBO_PRITNABLE_OPTIONS GLOBAL PROPERTY PRITNABLE_OPTIONS)

    # Заголовок
    FormatMessage (NONE ",{78:center:-}," "-")
    FormatMessage (NONE "|{78:center: }|" "${PROJECT_NAME} build settings")
    FormatMessage (NONE "|{78:center:-}|" "-")
    FormatMessage (NONE "|{22:center: }|{7:center: }|{47:center: }|" "Name" "Value" "Description")
    FormatMessage (NONE "|{78:center:-}|" "-")

    # Печать опций
    foreach(VALUE ${SBO_PRITNABLE_OPTIONS})
        string (FIND ${VALUE} ":" SBO_SEPARATOR_POSITION)
        
        math (EXPR DESCRIPTION_BEGIN "${SBO_SEPARATOR_POSITION} + 1" OUTPUT_FORMAT DECIMAL)
        string (SUBSTRING "${VALUE}" 0 ${SBO_SEPARATOR_POSITION} SBO_OPTION_NAME)
        string (SUBSTRING "${VALUE}" ${DESCRIPTION_BEGIN} -1 SBO_OPTION_DESCRIPTION)

        FormatMessage (NONE "| {20} |{7:center: }| {45} |" "${SBO_OPTION_NAME}" "${${SBO_OPTION_NAME}}" "${SBO_OPTION_DESCRIPTION}")
    endforeach()

    # Конец таблицы
    FormatMessage (NONE "`{78:center:-}`" "-")
endmacro ()