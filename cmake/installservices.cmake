include (FindPkgConfig)
include (GNUInstallDirs)
include (${CMAKE_SOURCE_DIR}/cmake/systemdservice.cmake)

message ( STATUS "Installing services" )
if ( SYSTEMD_FOUND )
  message ( STATUS "Installing systemd service to ${SYSTEMD_SERVICES_INSTALL_DIR}/earlyoom.service..." )
  file ( INSTALL earlyoom.service
            DESTINATION ${SYSTEMD_SERVICES_INSTALL_DIR}
            PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ )
  execute_process( COMMAND systemctl enable earlyoom.service
                   RESULT_VARIABLE Result
                   OUTPUT_VARIABLE Output
                   ERROR_VARIABLE Error )
  if ( Result EQUAL 0 )
    message ( STATUS "Enabled systemd service." )
  else ()
    message ( FATAL_ERROR "Error enabling systemd service: result - ${Result}\noutput - ${Output}\nError - ${Error}" )
  endif ()
else ()
  message ( STATUS "Installing initscript to /${CMAKE_INSTALL_SYSCONFDIR}/init.d/earlyoom..." )
  file ( INSTALL ${CMAKE_SOURCE_DIR}/earlyoom.initscript
            RENAME earlyoom
            DESTINATION /${CMAKE_INSTALL_SYSCONFDIR}/init.d
            PERMISSIONS OWNER_READ OWNER_WRITE OWNER_READ OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_EXECUTE )
  message ( STATUS "Enabling earlyoom init service..." )
  execute_process( COMMAND update-rc.d earlyoom start 18 2 3 4 5 . stop 20 0 1 6 .
                   RESULT_VARIABLE Result
                   OUTPUT_VARIABLE Output
                   ERROR_VARIABLE Error )
  if ( Result EQUAL 0 )
    message ( STATUS "Enabled init service." )
  else ()
    message ( FATAL_ERROR "Error enabling init service: result - ${Result}\noutput - ${Output}\nError - ${Error}" )
  endif ()
endif ()
