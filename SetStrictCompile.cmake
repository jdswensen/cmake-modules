if(__set_strict_compile)
  return()
endif()
set(__set_strict_compile INCLUDED)

# Enable strict compiler settings
set(compiler_warnings "\
-Wall \
-Wextra \
-Werror \
-Wshadow \
-Wpointer-arith \
-Wcast-qual \
-Wcast-align \
-Wstrict-prototypes \
-Wmissing-prototypes \
-Wwrite-strings \
-Wswitch-default \
-Wconversion \
-Wundef \
")
