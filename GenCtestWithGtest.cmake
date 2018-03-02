if(__gen_ctest_with_gtest)
    return()
endif()
set(__gen_ctest_with_gtest INCLUDED)

function(gen_ctest_with_gtest)
    set(options "")
    set(one_value_args COMPONENT_NAME)
    set(multi_value_args TEST_SOURCE TEST_LINKS EXTRA_INCLUDE TEST_ARGS)
    cmake_parse_arguments(gen_ctest_with_gtest "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})


    include_directories(${gen_ctest_with_gtest_EXTRA_INCLUDE})

    # Set short aliases
    set(src_links ${gen_ctest_with_gtest_TEST_LINKS} pthread gtest)
    set(test_src ${gen_ctest_with_gtest_TEST_SOURCE})
    set(exe_name test-${PROJECT_NAME}-${gen_ctest_with_gtest_COMPONENT_NAME})

    # Separate args into list in case they were passes as a single string
    set(test_arg_list ${gen_ctest_with_gtest_TEST_ARGS})
    separate_arguments(test_arg_list)

    # Prepend xml output option
    set(test_args --gtest_output=xml:results/UNITTESTS-${exe_name}.junit.xml ${test_arg_list})

    # Generate test executable
    add_executable(${exe_name} ${test_src})
    target_link_libraries(${exe_name} ${src_links})
    add_test(${exe_name} ${exe_name} ${test_args})

    install(TARGETS ${exe_name}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}/${PROJECT_NAME}
    )
endfunction()
