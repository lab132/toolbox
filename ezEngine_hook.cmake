# This hook customizes the ezEngine build in a way that it is suitable for usage with lab132 projects.
# Add a `include(../ezEngine_hook.cmake)` call to the top-level CMakeLists.txt file of the ezEngine project,
# after all ezEngine targets have been created (i.e. ALL_KNOWN_PROJECTS is populated).
# This is usually after the call to `add_subdirectory(Code)`

get_property(EZ_TARGETS GLOBAL PROPERTY ALL_KNOWN_PROJECTS)
set(LAB132_TOOLBOX_EZ_TARGETS ${EZ_TARGETS}
    CACHE STRING "ezEngine components.")

set(LAB132_TOOLBOX_EZ_POSTFIX_DEBUG          "-debug"   CACHE STRING "e.g. ezFoundation-debug.dll")
set(LAB132_TOOLBOX_EZ_POSTFIX_RELEASE        ""         CACHE STRING "No postfix, i.e. ezFoundation.dll")
set(LAB132_TOOLBOX_EZ_POSTFIX_MINSIZEREL     "-minsize" CACHE STRING "e.g. ezFoundation-minsize.dll")
set(LAB132_TOOLBOX_EZ_POSTFIX_RELWITHDEBINFO "-reldeb"  CACHE STRING "e.g. ezFoundation-reldeb.dll")

set(EZ_DIR "${CMAKE_SOURCE_DIR}")

set_target_properties(${LAB132_TOOLBOX_EZ_TARGETS} PROPERTIES
                      RUNTIME_OUTPUT_DIRECTORY                 "${EZ_DIR}/bin"
                      LIBRARY_OUTPUT_DIRECTORY                 "${EZ_DIR}/lib"
                      ARCHIVE_OUTPUT_DIRECTORY                 "${EZ_DIR}/lib"

                      DEBUG_POSTFIX "${LAB132_TOOLBOX_EZ_POSTFIX_DEBUG}"
                      RUNTIME_OUTPUT_DIRECTORY_DEBUG           "${EZ_DIR}/bin"
                      LIBRARY_OUTPUT_DIRECTORY_DEBUG           "${EZ_DIR}/lib"
                      ARCHIVE_OUTPUT_DIRECTORY_DEBUG           "${EZ_DIR}/lib"

                      RELEASE_POSTFIX "${LAB132_TOOLBOX_EZ_POSTFIX_RELEASE}"
                      RUNTIME_OUTPUT_DIRECTORY_RELEASE         "${EZ_DIR}/bin"
                      LIBRARY_OUTPUT_DIRECTORY_RELEASE         "${EZ_DIR}/lib"
                      ARCHIVE_OUTPUT_DIRECTORY_RELEASE         "${EZ_DIR}/lib"

                      MINSIZEREL_POSTFIX "${LAB132_TOOLBOX_EZ_POSTFIX_MINSIZEREL}"
                      RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL      "${EZ_DIR}/bin"
                      LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL      "${EZ_DIR}/lib"
                      ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL      "${EZ_DIR}/lib"

                      RELWITHDEBINFO_POSTFIX "${LAB132_TOOLBOX_EZ_POSTFIX_RELWITHDEBINFO}"
                      RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO  "${EZ_DIR}/bin"
                      LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO  "${EZ_DIR}/lib"
                      ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO  "${EZ_DIR}/lib")

foreach(EZ_TARGET ${EZ_TARGETS})
  list(APPEND EZ_COMPONENTS "ez${EZ_TARGET}")
endforeach()

set(CODE [=[
# Generated file from the lab132 toolbox.
# Needs a valid EZ_DIR CMake variable.

if(NOT EZ_DIR)
  message(FATAL_ERROR "Need a valid EZ_DIR CMake variable.")
endif()

set(EZ_COMPONENTS @EZ_COMPONENTS@)
set(EZ_POSTFIX_DEBUG          "@LAB132_TOOLBOX_EZ_POSTFIX_DEBUG@")
set(EZ_POSTFIX_RELEASE        "@LAB132_TOOLBOX_EZ_POSTFIX_RELEASE@")
set(EZ_POSTFIX_MINSIZEREL     "@LAB132_TOOLBOX_EZ_POSTFIX_MINSIZEREL@")
set(EZ_POSTFIX_RELWITHDEBINFO "@LAB132_TOOLBOX_EZ_POSTFIX_RELWITHDEBINFO@")
foreach(EZ_COMPONENT ${EZ_COMPONENTS})
  # IMPORTED library
  # Specifies where the .lib and .dll files are located at.
  add_library(${EZ_COMPONENT}_IMPORTED SHARED IMPORTED GLOBAL)
  foreach(CONFIG @CMAKE_CONFIGURATION_TYPES@)
    string(TOUPPER "${CONFIG}" CONFIG)
    set_property(TARGET ${EZ_COMPONENT}_IMPORTED PROPERTY IMPORTED_LOCATION_${CONFIG} "${EZ_DIR}/bin/${EZ_COMPONENT}${EZ_POSTFIX_${CONFIG}}.dll")
    set_property(TARGET ${EZ_COMPONENT}_IMPORTED PROPERTY IMPORTED_IMPLIB_${CONFIG}   "${EZ_DIR}/lib/${EZ_COMPONENT}${EZ_POSTFIX_${CONFIG}}.lib")
  endforeach()
  # INTERFACE library
  # Note: Only INTERFACE libraries can have "include_directories".
  add_library(${EZ_COMPONENT} INTERFACE)
  target_link_libraries(${EZ_COMPONENT} INTERFACE ${EZ_COMPONENT}_IMPORTED)
  target_include_directories(${EZ_COMPONENT} INTERFACE "${EZ_DIR}/Code/Engine")
endforeach()
add_library(ezEngine INTERFACE)
target_link_libraries(ezEngine INTERFACE ${EZ_COMPONENTS})
]=])

string(CONFIGURE "${CODE}" CODE_CONFIGURED @ONLY)

file(WRITE "${EZ_DIR}/lib/CMake/targets/ezEngine.cmake" "${CODE_CONFIGURED}")

add_custom_target(Lab132Toolbox)
add_dependencies(Lab132Toolbox ${LAB132_TOOLBOX_EZ_TARGETS})
