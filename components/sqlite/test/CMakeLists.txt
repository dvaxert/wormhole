# Process all subdirectories that have CMakeLists.txt as subprojects

file (GLOB APP_LIST LIST_DIRECTORIES true RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}"  "*")

foreach (DIR ${APP_LIST})
    if (IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${DIR}")
        if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${DIR}/CMakeLists.txt")
            add_subdirectory (${DIR})
        else ()
            message (WARNING "Not found CMakeLists.txt in ${DIR}")
        endif ()
    endif ()
endforeach ()