cmake_minimum_required(VERSION 3.3)

project(lab132Toolbox)

set(DEFAULT_VERSION_EZ    "rev858")
set(DEFAULT_VERSION_GLEW  "1.12.0")
set(DEFAULT_VERSION_CATCH "v1.2.1-develop.12")

# ezEngine
# ========
set(LAB132_TOOLBOX_EZ ON CACHE BOOL "Whether to include the ezEngine in the installation.")
if(LAB132_TOOLBOX_EZ)
  set(LAB132_TOOLBOX_EZ_VERSION "${DEFAULT_VERSION_EZ}" CACHE STRING "The version of ezEngine to be used. Must match the folder names in the toolbox.")
  set(EZ_DIR "../ezEngine-${LAB132_TOOLBOX_EZ_VERSION}")
  install(DIRECTORY "${EZ_DIR}/Code/Engine/" DESTINATION code
          PATTERN "CMakeLists.txt" EXCLUDE)

  install(DIRECTORY "${EZ_DIR}/bin/" DESTINATION bin
          PATTERN "ez*.exe"
          PATTERN "ez*.dll"
          PATTERN "ez*.pdb"
          )

  install(DIRECTORY "${EZ_DIR}/lib/" DESTINATION lib
          PATTERN "ez*.lib"
          PATTERN "ez*.exp"
          )
endif()

# glew
# ====
set(LAB132_TOOLBOX_GLEW ON CACHE BOOL "Whether to include glew in the installation.")
if(LAB132_TOOLBOX_GLEW)
  set(LAB132_TOOLBOX_GLEW_VERSION "${DEFAULT_VERSION_GLEW}" CACHE STRING "The version of glew to be used. Must match the folder names in the toolbox.")
  set(GLEW_DIR "../glew-${LAB132_TOOLBOX_GLEW_VERSION}")

  install(DIRECTORY "${GLEW_DIR}/include/" DESTINATION code)

  install(DIRECTORY "${GLEW_DIR}/bin/" DESTINATION bin
          PATTERN "glew*.exe"
          PATTERN "glew*.dll"
          PATTERN "glew*.pdb"
          )

  install(DIRECTORY "${GLEW_DIR}/lib/" DESTINATION lib
          PATTERN "glew*.lib"
          PATTERN "glew*.exp"
          )
endif()

# Catch
# =====
set(LAB132_TOOLBOX_CATCH ON CACHE BOOL "Whether to include Catch in the installation.")
if(LAB132_TOOLBOX_CATCH)
  set(LAB132_TOOLBOX_CATCH_VERSION "${DEFAULT_VERSION_CATCH}" CACHE STRING "The version of Catch to be used. Must match the folder names in the toolbox.")
  set(CATCH_DIR "../Catch-${LAB132_TOOLBOX_CATCH_VERSION}")

  install(DIRECTORY "${CATCH_DIR}/single_include/" DESTINATION code)
endif()
