# Add `include(../../../glew_hook.cmake)` as the last line to the top-level CMakeLists.txt file of the glew build dir.

# NOTE: Variables used from the CMakeLists.txt that includes us: GLEW_DIR, GLEW_LIB_NAME

set(LAB132_TOOLBOX_GLEW_POSTFIX_DEBUG          "-debug"   CACHE STRING "e.g. glew-debug.dll")
set(LAB132_TOOLBOX_GLEW_POSTFIX_RELEASE        ""         CACHE STRING "No postfix, i.e. glew.dll")
set(LAB132_TOOLBOX_GLEW_POSTFIX_MINSIZEREL     "-minsize" CACHE STRING "e.g. glew-minsize.dll")
set(LAB132_TOOLBOX_GLEW_POSTFIX_RELWITHDEBINFO "-reldeb"  CACHE STRING "e.g. glew-reldeb.dll")

set_target_properties(glew PROPERTIES
                      RUNTIME_OUTPUT_DIRECTORY "${GLEW_DIR}/bin"
                      LIBRARY_OUTPUT_DIRECTORY "${GLEW_DIR}/lib"
                      ARCHIVE_OUTPUT_DIRECTORY "${GLEW_DIR}/lib"

                      DEBUG_POSTFIX "${LAB132_TOOLBOX_GLEW_POSTFIX_DEBUG}"
                      RUNTIME_OUTPUT_DIRECTORY_DEBUG "${GLEW_DIR}/bin"
                      LIBRARY_OUTPUT_DIRECTORY_DEBUG "${GLEW_DIR}/lib"
                      ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${GLEW_DIR}/lib"

                      RELEASE_POSTFIX "${LAB132_TOOLBOX_GLEW_POSTFIX_RELEASE}"
                      RUNTIME_OUTPUT_DIRECTORY_RELEASE "${GLEW_DIR}/bin"
                      LIBRARY_OUTPUT_DIRECTORY_RELEASE "${GLEW_DIR}/lib"
                      ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${GLEW_DIR}/lib"

                      MINSIZEREL_POSTFIX "${LAB132_TOOLBOX_GLEW_POSTFIX_MINSIZEREL}"
                      RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL "${GLEW_DIR}/bin"
                      LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL "${GLEW_DIR}/lib"
                      ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL "${GLEW_DIR}/lib"

                      RELWITHDEBINFO_POSTFIX "${LAB132_TOOLBOX_GLEW_POSTFIX_RELWITHDEBINFO}"
                      RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${GLEW_DIR}/bin"
                      LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO "${GLEW_DIR}/lib"
                      ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO "${GLEW_DIR}/lib")

set(CODE [=[
# Generated file from the lab132 toolbox.
# Needs a valid GLEW_DIR CMake variable.

if(NOT GLEW_DIR)
  message(FATAL_ERROR "Need a valid GLEW_DIR CMake variable.")
endif()

set(GLEW_POSTFIX_DEBUG          "@LAB132_TOOLBOX_GLEW_POSTFIX_DEBUG@")
set(GLEW_POSTFIX_RELEASE        "@LAB132_TOOLBOX_GLEW_POSTFIX_RELEASE@")
set(GLEW_POSTFIX_MINSIZEREL     "@LAB132_TOOLBOX_GLEW_POSTFIX_MINSIZEREL@")
set(GLEW_POSTFIX_RELWITHDEBINFO "@LAB132_TOOLBOX_GLEW_POSTFIX_RELWITHDEBINFO@")

# IMPORTED library
# Specifies where the .lib and .dll files are located at.
add_library(glew_IMPORTED SHARED IMPORTED GLOBAL)
foreach(CONFIG @CMAKE_CONFIGURATION_TYPES@)
  string(TOUPPER "${CONFIG}" CONFIG)
  set_property(TARGET glew_IMPORTED PROPERTY IMPORTED_LOCATION_${CONFIG} "${GLEW_DIR}/bin/@GLEW_LIB_NAME@${GLEW_POSTFIX_${CONFIG}}.dll")
  set_property(TARGET glew_IMPORTED PROPERTY IMPORTED_IMPLIB_${CONFIG}   "${GLEW_DIR}/lib/@GLEW_LIB_NAME@${GLEW_POSTFIX_${CONFIG}}.lib")
endforeach()

# INTERFACE library
# Note: Only INTERFACE libraries can have "include_directories".
add_library(glew INTERFACE)
target_link_libraries(glew INTERFACE glew_IMPORTED)
target_include_directories(glew INTERFACE "${GLEW_DIR}/include")
]=])

string(CONFIGURE "${CODE}" CODE_CONFIGURED @ONLY)

file(WRITE "${GLEW_DIR}/lib/CMake/targets/glew.cmake" "${CODE_CONFIGURED}")

add_custom_target(Lab132Toolbox)
add_dependencies(Lab132Toolbox glew)
