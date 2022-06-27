# Create and configure a library target

# Define the library type
if (WORMHOLE_BUILD_SHARED_LIBS)
    set (WORMHOLE_LIBRARY_TYPE SHARED)
else ()
    set (WORMHOLE_LIBRARY_TYPE STATIC)
endif ()

add_library (wormhole ${WORMHOLE_LIBRARY_TYPE})
message (STATUS "WORMHOLE_LIBRARY_TYPE - ${WORMHOLE_LIBRARY_TYPE}")

# Describing the list of source files

NestingFileSearch (WORMHOLE_PUBLIC_HEADERS
    EXTENSION ".h"
    DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

NestingFileSearch (WORMHOLE_PRIVATE_HEADERS
    EXTENSION ".h"
    DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/wormhole/internal"
)

NestingFileSearch (WORMHOLE_SOURCES
    RECURSIVE
    EXTENSION ".cc"
    DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/src"
)

target_sources(wormhole
    PUBLIC 
        ${WORMHOLE_PUBLIC_HEADERS}
    PRIVATE
        ${WORMHOLE_PRIVATE_HEADERS}
        ${WORMHOLE_SOURCES}
)

target_include_directories(wormhole
    PUBLIC 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

set_target_properties(wormhole
    PROPERTIES
        PUBLIC_HEADER ${WORMHOLE_PUBLIC_HEADERS}
)


# Create an installation target

if(WORMHOLE_INSTALL)

    install(
        TARGETS wormhole
        EXPORT wormhole-targets
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_BINDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/wormhole
    )

endif()