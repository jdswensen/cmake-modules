# - Returns a version string from Git tags
#
# This function inspects the annotated git tags for the project and returns a string
# into a CMake variable
#
#  get_git_version(<var>)
#
# - Example
#
# include(GetGitVersion)
# get_git_version(GIT_VERSION)
#
# Requires CMake 2.8.11+
find_package(Git)

if(__get_git_version)
  return()
endif()
set(__get_git_version INCLUDED)

function(get_git_version var)
  if(GIT_EXECUTABLE)
      execute_process(COMMAND ${GIT_EXECUTABLE} describe --match "v[0-9]*.[0-9]*.[0-9]*" --abbrev=8
          RESULT_VARIABLE status
          OUTPUT_VARIABLE GIT_VERSION
          ERROR_QUIET)
      if(${status})
          set(GIT_VERSION "v0.0.0")
      else()
          string(STRIP ${GIT_VERSION} GIT_VERSION)
          string(REGEX REPLACE "-[0-9]+-g" "-" GIT_VERSION ${GIT_VERSION})
      endif()

      # Work out if the repository is dirty
      execute_process(COMMAND ${GIT_EXECUTABLE} update-index -q --refresh
          OUTPUT_QUIET
          ERROR_QUIET)
      execute_process(COMMAND ${GIT_EXECUTABLE} diff-index --name-only HEAD --
          OUTPUT_VARIABLE GIT_DIFF_INDEX
          ERROR_QUIET)
      string(COMPARE NOTEQUAL "${GIT_DIFF_INDEX}" "" GIT_DIRTY)
      if (${GIT_DIRTY})
          set(GIT_VERSION "${GIT_VERSION}-dirty")
      endif()
  else()
      set(GIT_VERSION "v0.0.0")
  endif()

  message("-- git Version: ${GIT_VERSION}")
  set(${var} ${GIT_VERSION} PARENT_SCOPE)
endfunction()

function(get_git_version_discrete git_major git_minor git_patch)
    get_git_version(version_string)
    message(STATUS ${version_string})

    # execute_process(COMMAND ${GIT_EXECUTABLE} describe --abbrev=0 --tags
    #     WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    #     OUTPUT_VARIABLE version_string
    #     OUTPUT_STRIP_TRAILING_WHITESPACE)

    #string(REGEX MATCHALL "-.*$|[0-9]+" version_list ${version_string})
    #message(STATUS ${version_list})
    #list(GET ${version_list} 1 major)
    string(REGEX REPLACE "^v([0-9]+)\\..*" "\\1" major "${version_string}")
    string(REGEX REPLACE "^v[0-9]+\\.([0-9]+).*" "\\1" minor "${version_string}")
    string(REGEX REPLACE "^v[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" patch "${version_string}")

    message(STATUS ${major})
    message(STATUS ${minor})
    message(STATUS ${patch})

    set(git_major ${major} CACHE INTERNAL "git major version")
    set(${git_minor} 1 PARENT_SCOPE)
    set(git_patch ${patch} PARENT_SCOPE)
endfunction()
