########################################################################################################################
#
# Function for sending formatted messages to the terminal with the ability to substitute arguments according to the
# template.
#
# Opportunities:
# * Specifying the length of the argument to be inserted
# * Specifying the alignment of the argument
# * Specifies the filler to be used to fill in missing characters
#
# Example:
# FormatMessage (NOTICE "{10:right:*} {20:left:-} {30:center:!}" "Hello" "world" "!")
#
# The result of the call on the command line:
# "*****Hello world--------------- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#
# Template format:
# {lenght:align:filler}
#
# Template arguments can be omitted, but delimiters must be specified.
#
# The following variants of the template are considered correct:
# {} {:} {::} {::!} {1::!} {:left:!} {10} {10:left}
#
# Important! The number of arguments that are substituted must always match the number of arguments passed.
# The function ignores empty arguments. Maybe this will be fixed in the future.
#
# Call arguments:
# * TYPE - The argument corresponding to the [<mode>] argument in the message function.
# * FORMAT - Template in which the arguments will be substituted
# All subsequent arguments will be taken as arguments to populate the template
#
########################################################################################################################

function (FormatMessage TYPE FORMAT)
    unset (ARGUMENTS)
    foreach (VALUE ${ARGN})
        list (APPEND ARGUMENTS ${VALUE})
    endforeach ()
    
    # Calculate the required number of arguments

    string (REGEX MATCHALL "[{][^{]*[}]" MATCH_LIST "${FORMAT}")
    list (LENGTH MATCH_LIST FORMAT_SIZE)

    # Calculate the number of arguments passed

    list (LENGTH ARGUMENTS ARGUMENTS_COUNT)

    # If the number of arguments matches, we try to fill the template

    if (${FORMAT_SIZE} EQUAL ${ARGUMENTS_COUNT})
        string (REGEX MATCHALL "[{][^{]*[}]" MATCH_LIST "${FORMAT}")
        set (RESULT ${FORMAT})
        
        set (CURRENT_INDEX 0)
        foreach (MATCH ${MATCH_LIST})
            string (FIND ${RESULT} ${MATCH} REPLACE_BEGIN)
            string (LENGTH "${MATCH}" MATCH_LEN)
            string (LENGTH <string> <output_variable>)
            math (EXPR REPLACE_END "${REPLACE_BEGIN} + ${MATCH_LEN}" OUTPUT_FORMAT DECIMAL)


            # Get the prefix and postfix strings from the original string

            string (SUBSTRING ${RESULT} 0 ${REPLACE_BEGIN} RESULT_PREFIX)
            string (SUBSTRING ${RESULT} ${REPLACE_END} -1 RESULT_POSTFIX)

            math (EXPR FORMAT_STRING_END_POSITION "${MATCH_LEN} - 2" OUTPUT_FORMAT DECIMAL)
            string (SUBSTRING ${MATCH} 1 ${FORMAT_STRING_END_POSITION} FORMAT_STRING)
            string (LENGTH "${FORMAT_STRING}" FORMAT_STRING_LEN)

            ParseFormatString("${FORMAT_STRING}" LEN_VALUE ALIGN_VALUE FILLER_VALUE)

            # Obtaining and preparing the value for substitution
            list (GET ARGUMENTS ${CURRENT_INDEX} CURRENT_ARGUMENT)
            string (LENGTH ${CURRENT_ARGUMENT} CURRENT_ARGUMENT_LEN)


            # if there is a format description, fill in the template

            if ("${FORMAT_STRING_LEN}" GREATER "0")
                if (NOT DEFINED LEN_VALUE)
                    set (LEN_VALUE ${CURRENT_ARGUMENT_LEN})
                endif ()

                if (NOT DEFINED ALIGN_VALUE)
                    set (ALIGN_VALUE "left")
                endif ()

                if (NOT DEFINED FILLER_VALUE)
                    set (FILLER_VALUE " ")
                endif ()

                ApplyFormat (${CURRENT_ARGUMENT} ${LEN_VALUE} ${ALIGN_VALUE} ${FILLER_VALUE} CURRENT_ARGUMENT)
            endif ()


            # Replace the template with the value

            set (RESULT ${RESULT_PREFIX}${CURRENT_ARGUMENT}${RESULT_POSTFIX})


            # Increase the element count

            math (EXPR CURRENT_INDEX "${CURRENT_INDEX} + 1" OUTPUT_FORMAT DECIMAL)
        endforeach ()

        message (${TYPE} ${RESULT})

    # If the number of arguments does not match, we report an error

    else ()
        message (WARNING "The message format does not match the number of arguments: "
                            "FORMAT: \"${FORMAT}\", "
                            "FORMAT_SIZE: ${FORMAT_SIZE}, "
                            "ARGUMENTS: \"${ARGN}\", "
                            "ARGUMENTS_COUNT: ${ARGUMENTS_COUNT}"
        )
    endif ()

endfunction ()

########################################################################################################################
#
# This macro is designed to parse a template of text
#
# This is an internal macro for use in the FormatMessage function do not use it.
#
########################################################################################################################

macro (ParseFormatString FORMAT_STRING OUT_LEN OUT_ALIGN OUT_FILLER)
    unset (${OUT_LEN})
    unset (${OUT_ALIGN})
    unset (${OUT_FILLER})

    string (LENGTH "${FORMAT_STRING}" PFS_FORMAT_STRING_LEN)

    if ("${PFS_FORMAT_STRING_LEN}" GREATER "0")
        string (FIND ${FORMAT_STRING} ":" PFS_FIRST_SEPARATOR_POSITION)

        math (EXPR PFS_ALIGN_VALUE_BEGIN_POSITION "${PFS_FIRST_SEPARATOR_POSITION} + 1" OUTPUT_FORMAT DECIMAL)
        string (SUBSTRING ${FORMAT_STRING} 0 ${PFS_FIRST_SEPARATOR_POSITION} PFS_LEN_VALUE)

        if ("${PFS_LEN_VALUE}" GREATER "0")
            set (${OUT_LEN} ${PFS_LEN_VALUE})
        endif ()

        if ("${PFS_FIRST_SEPARATOR_POSITION}" GREATER "0")
            string (SUBSTRING ${FORMAT_STRING} ${PFS_ALIGN_VALUE_BEGIN_POSITION} -1 PFS_POST_FIRST_SEPARATOR_STRING)
            string (LENGTH "${PFS_POST_FIRST_SEPARATOR_STRING}" PFS_POST_FIRST_SEPARATOR_STRING_LEN)

            if ("${PFS_POST_FIRST_SEPARATOR_STRING_LEN}" GREATER "0")
                string (FIND ${PFS_POST_FIRST_SEPARATOR_STRING} ":" PFS_SECOND_SEPARATOR_POSITION)
                math (EXPR PFS_FILLER_VALUE_BEGIN_POSITION "${PFS_SECOND_SEPARATOR_POSITION} + 1" OUTPUT_FORMAT DECIMAL)
                
                if ("${PFS_SECOND_SEPARATOR_POSITION}" GREATER "0")
                    string (SUBSTRING ${PFS_POST_FIRST_SEPARATOR_STRING} 
                        0 ${PFS_SECOND_SEPARATOR_POSITION} 
                        PFS_ALIGN_VALUE
                    )
                    
                    if (NOT ${PFS_ALIGN_VALUE} STREQUAL "left" AND
                        NOT ${PFS_ALIGN_VALUE} STREQUAL "right" AND
                        NOT ${PFS_ALIGN_VALUE} STREQUAL "center")
                        message (WARNING "Align can only have the values left, right or center")
                    else ()
                        set (${OUT_ALIGN} ${PFS_ALIGN_VALUE})
                    endif ()
                endif ()
                    
                string (SUBSTRING ${PFS_POST_FIRST_SEPARATOR_STRING} 
                    ${PFS_FILLER_VALUE_BEGIN_POSITION} -1 
                    PFS_POST_SECOND_SEPARATOR_STRING
                )
                string (LENGTH "${PFS_POST_SECOND_SEPARATOR_STRING}" PFS_POST_SECOND_SEPARATOR_STRING_LEN)
                
                if ("${PFS_POST_SECOND_SEPARATOR_STRING_LEN}" GREATER "0")
                    if ("${PFS_POST_SECOND_SEPARATOR_STRING_LEN}" GREATER "1")
                        message (WARNING "The filler must be 1 character")
                    else ()
                        set (${OUT_FILLER} ${PFS_POST_SECOND_SEPARATOR_STRING})
                    endif ()
                endif ()
            endif ()
        endif ()
    endif ()

endmacro ()

########################################################################################################################
#
# This macro is designed to fill the template with arguments
#
# This is an internal macro for use in the FormatMessage function do not use it.
#
########################################################################################################################

macro (ApplyFormat ARGUMENT LEN ALIGN FILLER OUT)
    unset (${LEN})
    unset (${ALIGN})
    unset (${FILLER})

    set (AF_ARGUMENT ${ARGUMENT})
    string (LENGTH ${AF_ARGUMENT} AF_ARGUMENT_LEN)

    if ("${LEN}" LESS "${AF_ARGUMENT_LEN}")
        string (SUBSTRING ${AF_ARGUMENT} 0 ${LEN} AF_ARGUMENT)

    elseif ("${LEN}" GREATER "${AF_ARGUMENT_LEN}")

        math (EXPR AF_DELTA_LEN "${LEN} - ${AF_ARGUMENT_LEN}" OUTPUT_FORMAT DECIMAL)

        if (${ALIGN} STREQUAL "left")
            string (REPEAT ${FILLER} ${AF_DELTA_LEN} AF_FILLER_POSTFIX)
            string (APPEND AF_ARGUMENT ${AF_FILLER_POSTFIX})

        elseif (${ALIGN} STREQUAL "right")
            string (REPEAT ${FILLER} ${AF_DELTA_LEN} AF_FILLER_PREFIX)
            set (AF_ARGUMENT ${AF_FILLER_PREFIX}${AF_ARGUMENT})

        elseif (${ALIGN} STREQUAL "center")
            math (EXPR AF_PREFIX_LEN "${AF_DELTA_LEN} / 2" OUTPUT_FORMAT DECIMAL)
            math (EXPR AF_POSTFIX_LEN "${AF_DELTA_LEN} - ${AF_PREFIX_LEN}" OUTPUT_FORMAT DECIMAL)

            string (REPEAT ${FILLER} ${AF_PREFIX_LEN} AF_FILLER_PREFIX)
            string (REPEAT ${FILLER} ${AF_POSTFIX_LEN} AF_FILLER_POSTFIX)

            set (AF_ARGUMENT ${AF_FILLER_PREFIX}${AF_ARGUMENT}${AF_FILLER_POSTFIX})
        endif()
    endif ()

    set (${OUT} ${AF_ARGUMENT})
endmacro ()