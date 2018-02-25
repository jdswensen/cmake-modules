if(__set_shared_lib_version)
  return()
endif()
set(__set_shared_lib_version INCLUDED)

include(GetGitVersion)
get_git_version(GIT_VERSION)

# Tell the user what version is being used
string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+" VERSION ${GIT_VERSION})
message(STATUS "Version: ${VERSION}")

# Set the version info for the library
set(GENERIC_LIB_VERSION ${VERSION})
string(SUBSTRING ${VERSION} 0 1 GENERIC_LIB_SOVERSION)
message(STATUS "SO Version: ${GENERIC_LIB_SOVERSION}")
