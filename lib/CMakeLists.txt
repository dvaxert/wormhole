# Create and configure a library target

# Define the library type
if(WORMHOLE_BUILD_SHARED_LIBS)
    set(WORMHOLE_LIBRARY_TYPE SHARED)
else()
    set(WORMHOLE_LIBRARY_TYPE STATIC)
endif()

add_library(wormhole ${WORMHOLE_LIBRARY_TYPE})
message(STATUS "WORMHOLE_LIBRARY_TYPE - ${WORMHOLE_LIBRARY_TYPE}")

# Describing the list of source files

set(WORMHOLE_PUBLIC_HEADERS
    include/wormhole/wormhole.h
)

set(WORMHOLE_PRIVATE_HEADERS
    include/wormhole/internal/wormhole_internal.h
)

set(WORMHOLE_SOURCES
    src/wormhole.cc
    src/internal/wormhole_internal.cc
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
        LIBRARY DESTINATION ${CMAKE_INSTALL_BINDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/wormhole
    )

endif()