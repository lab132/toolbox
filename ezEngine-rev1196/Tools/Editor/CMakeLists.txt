#cmake

#
# Copy this file into the folder of an engine library to add it to the solution.
# Below there are configuration options to add preprocessor definitions and link dependencies to the library.
#
# *** Modify this file as required ***
#

if (POLICY CMP0043)
  cmake_policy(SET CMP0043 NEW)
endif()

BUILD_CONDITIONAL(BUILDSYSTEM_PLATFORM_WINDOWS)

# Add all the preprocessor definitions that are needed to configure this library
# add_definitions (-DMY_PREPROCESS_DEFINITION_1)
# add_definitions (-DMY_PREPROCESS_DEFINITION_2)

# Set this to true, if your application is a real win32 app (not a console app)
SET (IS_WIN32_APPLICATION true)

# Enables the use of Qt in this project and sets up the required modules.
QT_MODULES(Core Gui Widgets Network)

# Call this in case this project does not function without Qt.
BUILD_REQUIRES_QT()

# Add all the libraries that this project needs to link against here
SET (LINK_LIBRARIES
  Foundation
  Core
  ThirdParty
  EditorFramework
  ToolsFoundation
  GuiFoundation
)

SET (ADDITIONAL_DEPENDENCIES
  EditorEngineProcess
  EditorPluginScene
  EditorPluginAssets
)

include (${CMAKE_SOURCE_DIR}/Code/BuildSystem/CMake/CMAKE_Application.txt)


