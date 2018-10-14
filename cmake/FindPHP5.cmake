# - Find PHP5
# This module finds if PHP5 is installed and determines where the include files
# and libraries are. It also determines what the name of the library is. This
# code sets the following variables:
#
#  PHP5_INCLUDE_PATH       = path to where php.h can be found
#  PHP5_EXECUTABLE         = full path to the php4 binary
#
#  file is derived from FindPHP4.cmake
#

SET(PHP5_FOUND "NO")

SET(PHP5_POSSIBLE_INCLUDE_PATHS
  /usr/include/php5
  /usr/local/include/php5
  /usr/include/php
  /usr/local/include/php
  /usr/local/apache/php
  C:/php-sdk/phpmaster/vc15/x64/php-src
  ${PHP5_INCLUDES}
  )

SET(PHP5_POSSIBLE_LIB_PATHS
  /usr/lib
if(WIN32)
  ${PHP5_INCLUDES}/Release_TS
  ${PHP5_INCLUDES}/Release
  ${PHP5_INCLUDES}/x64/Release
  ${PHP5_INCLUDES}/x64/Release_TS
endif(WIN32)
  )

find_library(PHP5_LIBRARY
   NAMES php5ts.lib php7ts.lib php5.lib php7.lib
   PATHS /sw /opt/local C:/php-sdk/phpmaster/vc15/x64/php-src/Release_TS C:/php-sdk/phpmaster/vc15/x64/php-src/Release C:/php-sdk/phpmaster/vc15/x64/php-src/x64/Release C:/php-sdk/phpmaster/vc15/x64/php-src/x64/Release_TS
)
  
FIND_PATH(PHP5_FOUND_INCLUDE_PATH main/php.h
  ${PHP5_POSSIBLE_INCLUDE_PATHS})

IF(PHP5_FOUND_INCLUDE_PATH)
  SET(php5_paths "${PHP5_POSSIBLE_INCLUDE_PATHS}")
  FOREACH(php5_path Zend main TSRM)
    SET(php5_paths ${php5_paths} "${PHP5_FOUND_INCLUDE_PATH}/${php5_path}")
  ENDFOREACH(php5_path Zend main TSRM)
  SET(PHP5_INCLUDE_PATH "${php5_paths}" INTERNAL "PHP5 include paths")
ENDIF(PHP5_FOUND_INCLUDE_PATH)

FIND_PROGRAM(PHP5_EXECUTABLE
  NAMES php5 php
  PATHS
  /usr/local/bin
  )

MARK_AS_ADVANCED(
  PHP5_EXECUTABLE
  PHP5_FOUND_INCLUDE_PATH
  )

IF( NOT PHP5_CONFIG_EXECUTABLE )
FIND_PROGRAM(PHP5_CONFIG_EXECUTABLE
  NAMES php5-config php-config
  )
ENDIF( NOT PHP5_CONFIG_EXECUTABLE )

IF(PHP5_CONFIG_EXECUTABLE)
  EXECUTE_PROCESS(COMMAND ${PHP5_CONFIG_EXECUTABLE} --version
    OUTPUT_VARIABLE PHP5_VERSION)
  STRING(REPLACE "\n" "" PHP5_VERSION "${PHP5_VERSION}")

  EXECUTE_PROCESS(COMMAND ${PHP5_CONFIG_EXECUTABLE} --extension-dir
    OUTPUT_VARIABLE PHP5_EXTENSION_DIR)
  STRING(REPLACE "\n" "" PHP5_EXTENSION_DIR "${PHP5_EXTENSION_DIR}")

  EXECUTE_PROCESS(COMMAND ${PHP5_CONFIG_EXECUTABLE} --includes
    OUTPUT_VARIABLE PHP5_INCLUDES)
  STRING(REPLACE "-I" "" PHP5_INCLUDES "${PHP5_INCLUDES}")
  STRING(REPLACE " " ";" PHP5_INCLUDES "${PHP5_INCLUDES}")
  STRING(REPLACE "\n" "" PHP5_INCLUDES "${PHP5_INCLUDES}")
  LIST(GET PHP5_INCLUDES 0 PHP5_INCLUDE_DIR)

  set(PHP5_MAIN_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/main)
  set(PHP5_TSRM_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/TSRM)
  set(PHP5_ZEND_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/Zend)
  set(PHP5_REGEX_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/regex)
  set(PHP5_EXT_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/ext)
  set(PHP5_DATE_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/ext/date/lib)
  set(PHP5_STANDARD_INCLUDE_DIR ${PHP5_INCLUDE_DIR}/ext/standard)

  MESSAGE(STATUS ${PHP5_MAIN_INCLUDE_DIR})

  IF(NOT PHP5_INCLUDE_PATH)
    set(PHP5_INCLUDE_PATH ${PHP5_INCLUDES})
  ENDIF(NOT PHP5_INCLUDE_PATH)

  IF(PHP5_VERSION LESS 5)
    MESSAGE(FATAL_ERROR "PHP version is not 5 or later")
  ENDIF(PHP5_VERSION LESS 5)

  IF(PHP5_EXECUTABLE AND PHP5_INCLUDES)
    set(PHP5_FOUND "yes")
    MESSAGE(STATUS "Found PHP5-Version ${PHP5_VERSION} (using ${PHP5_CONFIG_EXECUTABLE})")
  ENDIF(PHP5_EXECUTABLE AND PHP5_INCLUDES)

  FIND_PROGRAM(PHPUNIT_EXECUTABLE
    NAMES phpunit phpunit2
    PATHS
    /usr/local/bin
  )

  IF(PHPUNIT_EXECUTABLE)
    MESSAGE(STATUS "Found phpunit: ${PHPUNIT_EXECUTABLE}")
  ENDIF(PHPUNIT_EXECUTABLE)

ENDIF(PHP5_CONFIG_EXECUTABLE)
