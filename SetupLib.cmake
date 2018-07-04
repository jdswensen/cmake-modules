if(__setup_lib)
  return()
endif()

# Get Git tags and set lib version
include(SetSharedLibVersion)
set(__setup_lib INCLUDED)

function(setup_lib)
    set(options "")
    set(one_value_args LIBRARY_NAME)
    set(multi_value_args LIBRARY_SRC LIBRARY_LINKS)
    cmake_parse_arguments(setup_lib "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

    message(STATUS "Setting up library: ${setup_lib_LIBRARY_NAME}")

    add_library(${setup_lib_LIBRARY_NAME} SHARED ${setup_lib_LIBRARY_SRC})

    # Define header files for library
    target_include_directories(${setup_lib_LIBRARY_NAME} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
        PRIVATE src
    )

    # Link libraries
    target_link_libraries(${setup_lib_LIBRARY_NAME} ${LIBRARY_LINKS})
    set_target_properties(${PROJECT_NAME}
        PROPERTIES
        VERSION ${GENERIC_LIB_VERSION}
        SOVERSION ${GENERIC_LIB_SOVERSION}
    )

    # Installation location
    install(TARGETS ${setup_lib_LIBRARY_NAME} EXPORT lib${setup_lib_LIBRARY_NAME}-config
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )

endfunction()
