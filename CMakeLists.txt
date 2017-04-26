cmake_minimum_required (VERSION 2.8.11)
project (earlyoom)
set (CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})
include ( GetGitRevisionDescription )


git_describe ( VERSION --tags --dirty )
message ( STATUS "Building with with git version tag: " ${VERSION} )
add_definitions( -DVERSION=\"${VERSION}\" )
add_executable ( earlyoom main.c kill.c meminfo.c )

if(CMAKE_CXX_COMPILER_ID MATCHES GNU)
  set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -g" )
endif()

install ( TARGETS earlyoom DESTINATION bin )
install ( SCRIPT ${CMAKE_SOURCE_DIR}/cmake/installservices.cmake )

add_custom_target(uninstall
    "${CMAKE_COMMAND}" -P "${CMAKE_MODULE_PATH}/uninstall.cmake"
)
