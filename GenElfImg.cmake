if(__gen_elf_img)
    return()
endif()
set(__gen_elf_img INCLUDED)

function(gen_elf_img target_name target_source target_preprocessor_defines target_links target_link_depends)
    message(STATUS "Current source directory: ${CMAKE_CURRENT_SOURCE_DIR}")
    set(target_elf ${target_name}.elf)
    message(STATUS "target_source: ${target_source}")
    add_executable(${target_elf} ${target_source})
    target_compile_definitions(${target_elf} PRIVATE ${target_preprocessor_defines})
    target_link_libraries(${target_elf} ${target_links})
    set_property(TARGET ${target_elf} PROPERTY LINK_DEPENDS ${target_link_depends})
endfunction()

function(gen_elf_to_hex target output)
    add_custom_command(TARGET ${target} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} --gap-fill=0xff -O ihex $<TARGET_FILE:${target}> ${output}
    COMMENT "Building ${output} from ${target}")
endfunction()

function(gen_elf_to_bin target output)
    add_custom_command(TARGET ${target} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} --gap-fill=0xff -O binary $<TARGET_FILE:${target}> ${output}
    COMMENT "Building ${output} from ${target}")
endfunction()