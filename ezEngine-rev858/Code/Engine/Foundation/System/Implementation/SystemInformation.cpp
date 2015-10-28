
#include <Foundation/PCH.h>
#include <Foundation/System/SystemInformation.h>
#include <Foundation/Configuration/Startup.h>

EZ_BEGIN_SUBSYSTEM_DECLARATION(Foundation, SystemInformation)

  // no dependencies

  ON_BASE_STARTUP
  {
    ezSystemInformation::Initialize();
  }

EZ_END_SUBSYSTEM_DECLARATION


// Storage for the current configuration
ezSystemInformation ezSystemInformation::s_SystemInformation;

  // Include inline file
#if EZ_ENABLED(EZ_PLATFORM_WINDOWS)
  #include <Foundation/System/Implementation/Win/SystemInformation_win.h>
#elif EZ_ENABLED(EZ_PLATFORM_OSX)
  #include <Foundation/System/Implementation/OSX/SystemInformation_OSX.h>
#elif EZ_ENABLED(EZ_PLATFORM_LINUX)
  #include <Foundation/System/Implementation/Posix/SystemInformation_posix.h>
#else
  #error "System configuration functions are not implemented on current platform"
#endif


EZ_STATICLINK_FILE(Foundation, Foundation_System_Implementation_SystemInformation);

