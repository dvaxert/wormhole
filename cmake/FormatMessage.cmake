

# {len:align:filler}

function (FormatMessage TYPE FORMAT)
    unset (ARGUMENTS)
    foreach (VALUE ${ARGN})
        list (APPEND ARGUMENTS ${VALUE})
    endforeach ()

    if ("${TYPE}" STREQUAL "NONE")
        set (TYPE "")
    endif ()
    
    # Расчитываем требуемое количество аргументов

    string (REGEX MATCHALL "[{][^{]*[}]" MATCH_LIST "${FORMAT}")
    list (LENGTH MATCH_LIST FORMAT_SIZE)

    # Расчитываем переданное количество аргументов
    list (LENGTH ARGUMENTS ARGUMENTS_COUNT)

    # Если количество не совпадает то сообщаем об ошибке (перевернуть условие)
    if (NOT ${FORMAT_SIZE} EQUAL ${ARGUMENTS_COUNT})
        message (AUTHOR_WARNING "The message format does not match the number of arguments: "
                                "FORMAT: \"${FORMAT}\", "
                                "FORMAT_SIZE: ${FORMAT_SIZE}, "
                                "ARGUMENTS: \"${ARGN}\", "
                                "ARGUMENTS_COUNT: ${ARGUMENTS_COUNT}"
        )
    else ()
        string (REGEX MATCHALL "[{][^{]*[}]" MATCH_LIST "${FORMAT}")
        set (RESULT ${FORMAT})
        
        set (CURRENT_INDEX 0)
        foreach (MATCH ${MATCH_LIST})
            string (FIND ${RESULT} ${MATCH} REPLACE_BEGIN)
            string (LENGTH "${MATCH}" MATCH_LEN)
            string (LENGTH <string> <output_variable>)
            math (EXPR REPLACE_END "${REPLACE_BEGIN} + ${MATCH_LEN}" OUTPUT_FORMAT DECIMAL)


            # Получаем префиксную и постфиксную строки из оригинальной строки
            string (SUBSTRING ${RESULT} 0 ${REPLACE_BEGIN} RESULT_PREFIX)
            string (SUBSTRING ${RESULT} ${REPLACE_END} -1 RESULT_POSTFIX)

            math (EXPR FORMAT_STRING_END_POSITION "${MATCH_LEN} - 2" OUTPUT_FORMAT DECIMAL)
            string (SUBSTRING ${MATCH} 1 ${FORMAT_STRING_END_POSITION} FORMAT_STRING)
            string (LENGTH "${FORMAT_STRING}" FORMAT_STRING_LEN)

            ParseFormatString("${FORMAT_STRING}" LEN_VALUE ALIGN_VALUE FILLER_VALUE)

            # Получаем и подготавливаем значение к подстановке
            list (GET ARGUMENTS ${CURRENT_INDEX} CURRENT_ARGUMENT)
            string (LENGTH ${CURRENT_ARGUMENT} CURRENT_ARGUMENT_LEN)


            # Есть описание формата
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


            # Заменяем шаблон значением
            set (RESULT ${RESULT_PREFIX}${CURRENT_ARGUMENT}${RESULT_POSTFIX})


            # Увеличиваем счетчик элементов
            math (EXPR CURRENT_INDEX "${CURRENT_INDEX} + 1" OUTPUT_FORMAT DECIMAL)
        endforeach ()

        message (${TYPE} ${RESULT})
    endif ()

endfunction ()

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
                    string (SUBSTRING ${PFS_POST_FIRST_SEPARATOR_STRING} 0 ${PFS_SECOND_SEPARATOR_POSITION} PFS_ALIGN_VALUE)
                    
                    if (NOT ${PFS_ALIGN_VALUE} STREQUAL "left" AND NOT ${PFS_ALIGN_VALUE} STREQUAL "right" AND NOT ${PFS_ALIGN_VALUE} STREQUAL "center")
                        message (AUTHOR_WARNING "Align can only have the values left, right or center")
                    else ()
                        set (${OUT_ALIGN} ${PFS_ALIGN_VALUE})
                    endif ()
                endif ()
                    
                string (SUBSTRING ${PFS_POST_FIRST_SEPARATOR_STRING} ${PFS_FILLER_VALUE_BEGIN_POSITION} -1 PFS_POST_SECOND_SEPARATOR_STRING)
                string (LENGTH "${PFS_POST_SECOND_SEPARATOR_STRING}" PFS_POST_SECOND_SEPARATOR_STRING_LEN)
                
                if ("${PFS_POST_SECOND_SEPARATOR_STRING_LEN}" GREATER "0")
                    if ("${PFS_POST_SECOND_SEPARATOR_STRING_LEN}" GREATER "1")
                        message (AUTHOR_WARNING "The filler must be 1 character")
                    else ()
                        set (${OUT_FILLER} ${PFS_POST_SECOND_SEPARATOR_STRING})
                    endif ()
                endif ()
            endif ()
        endif ()
    endif ()

endmacro ()

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