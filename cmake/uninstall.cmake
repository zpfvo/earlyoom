set(MANIFEST "${CMAKE_CURRENT_BINARY_DIR}/install_manifest.txt")

if(NOT EXISTS ${MANIFEST})
    message(FATAL_ERROR "Cannot find install manifest: '${MANIFEST}'")
endif()

file(STRINGS ${MANIFEST} files)
foreach(file ${files})
    if(EXISTS ${file})
        message ( STATUS "${file}")
        if("${file}" MATCHES "earlyboom.service$")
            execute_process( COMMAND systemctl disable earlyboom.service
                             RESULT_VARIABLE Result
                             OUTPUT_VARIABLE Output
                             ERROR_VARIABLE Error )
            if ( Result EQUAL 0 )
              message ( STATUS "Disabled systemd service earlyboom" )
            else ()
              message ( FATAL_ERROR "Error disableing systemd service: result - ${Result}\noutput - ${Output}\nerror - ${Error}" )
            endif ()
        endif()
        if("${file}" MATCHES "init.d")
            execute_process( COMMAND update-rc.d earlyoom remove
                             RESULT_VARIABLE Result
                             OUTPUT_VARIABLE Output
                             ERROR_VARIABLE Error )
            if ( Result EQUAL 0 )
              message ( STATUS "Disabled init service ${file}" )
            else ()
              message ( FATAL_ERROR "Error disableing init service: result - ${Result}\noutput - ${Output}\nerror - ${Error}" )
            endif ()
        endif()

        message(STATUS "Removing file: '${file}'")

        exec_program(
            ${CMAKE_COMMAND} ARGS "-E remove ${file}"
            OUTPUT_VARIABLE stdout
            RETURN_VALUE result
        )

        if(NOT "${result}" STREQUAL 0)
            message(FATAL_ERROR "Failed to remove file: '${file}'.")
        endif()
    else()
        MESSAGE(STATUS "File '${file}' does not exist.")
    endif()
endforeach(file)
