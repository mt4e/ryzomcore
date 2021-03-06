# NEL_DIR can be specified as root directory

# Returned variables
# NELDRIVER_XXX_BINARY_DEBUG
# NELDRIVER_XXX_BINARY_RELEASE
# NELDRIVER_XXX_LIBRARY_DEBUG
# NELDRIVER_XXX_LIBRARY_RELEASE
# NELDRIVER_XXX_FOUND
# NEL_DEFINITIONS
# NEL_INCLUDE_DIR
# NEL_INCLUDE_DIRS
# NEL_LIBRARIES
# NELXXX_FOUND
# NELXXX_LIBRARIES


INCLUDE(FindHelpers)

# Init all variables we'll set
SET(NEL_LIBRARIES)
SET(NEL_INCLUDE_DIR)
SET(NEL_INCLUDE_DIRS)
SET(NEL_VERSION)
SET(NEL_STATIC)
SET(NEL_STATIC_DRIVERS)
SET(NEL_VERSION_MAJOR)
SET(NEL_VERSION_MINOR)
SET(NEL_VERSION_PATCH)
SET(NEL_REVISION)
SET(NEL_VERSION)

SET(NEL_MODULES_FOUND)
SET(NEL_MODULES_AVAILABLE 3d georges gui ligo logic net pacs sound) # cegui pipeline

SET(NEL_DRIVERS_FOUND)
SET(NEL_DRIVERS_AVAILABLE opengl opengles direct3d dsound fmod openal xaudio2)

SET(NELMISC_FIND_REQUIRED ${NeL_FIND_REQUIRED})

# Force search of NELMISC
FIND_PACKAGE_HELPER(nelmisc nel/misc/types_nl.h RELEASE nelmisc_r nelmisc DEBUG nelmisc_d DIR ${NEL_DIR} VERBOSE QUIET)

IF(NELMISC_FOUND)
  # define NEL_DIR if not specified
  IF(NOT NEL_DIR)
    GET_FILENAME_COMPONENT(NEL_DIR ${NELMISC_INCLUDE_DIR}/.. ABSOLUTE)
  ENDIF()

  # Aliases for include directory
  SET(NEL_INCLUDE_DIR ${NELMISC_INCLUDE_DIR})
  SET(NEL_INCLUDE_DIRS ${NEL_INCLUDE_DIR})

  MESSAGE(STATUS "Found NeL headers in ${NEL_INCLUDE_DIR}")

  GET_FILENAME_COMPONENT(NEL_LIBRARY_DIR ${NELMISC_LIBRARY} DIRECTORY)

  MESSAGE(STATUS "Found NeL library in ${NEL_LIBRARY_DIR}")

  # TODO: implement static version checks for Windows

  # static libraries
  IF(UNIX)
    GET_FILENAME_COMPONENT(_LIBEXT ${NELMISC_LIBRARY} EXT)

    IF(_LIBEXT STREQUAL ".a")
      SET(NEL_STATIC ON)
      MESSAGE(STATUS "NeL is using static libraries")
    ENDIF()
  ENDIF()

  IF(WIN32)
    SET(NELDRIVER_DIRS_TO_CHECK
      ${NEL_DIR}/bin${LIB_SUFFIX}
      ${NEL_DIR}
    )
  ELSE()
    SET(NELDRIVER_DIRS_TO_CHECK
      /usr/local/lib/${CMAKE_LIBRARY_ARCHITECTURE}/nel
      /usr/local/lib/${CMAKE_LIBRARY_ARCHITECTURE}
      /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}/nel
      /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}
      /usr/lib/nel
      /usr/lib
    )
  ENDIF()

  # check for static drivers
  FOREACH(_DRIVER ${NEL_DRIVERS_AVAILABLE})
    IF(WIN32)
      SET(_DRIVER_RELASE_FILE "nel_drv_${_DRIVER}_win_r")
      SET(_DRIVER_DEBUG_FILE "nel_drv_${_DRIVER}_win_d")
      SET(_DRIVER_SHARED_EXT dll)
      SET(_DRIVER_STATIC_EXT lib)
    ELSE()
      SET(_DRIVER_RELEASE_FILE "nel_drv_${_DRIVER}")
      SET(_DRIVER_DEBUG_FILE)
      SET(_DRIVER_SHARED_EXT so)
      SET(_DRIVER_STATIC_EXT a)
    ENDIF()

    STRING(TOUPPER ${_DRIVER} _UPDRIVER)

    FOREACH(_DIR ${NELDRIVER_DIRS_TO_CHECK})
      SET(_FOUND OFF)

      IF(_DRIVER_RELASE_FILE)
        SET(_FILE "${_DIR}/${_DRIVER_RELASE_FILE}.${_DRIVER_SHARED_EXT}")
        IF(EXISTS ${_FILE})
          SET(NELDRIVER_${_UPDRIVER}_BINARY_RELEASE ${_FILE})

          MESSAGE(STATUS "Found NeL release shared driver ${_DRIVER}: ${_FILE}")

          SET(NEL_STATIC_DRIVERS OFF)

          IF(NOT NEL_DRIVER_DIR)
            SET(NEL_DRIVER_DIR ${_DIR})
          ENDIF()
        ENDIF()

        SET(_FILE "${_DIR}/${_DRIVER_RELASE_FILE}.${_DRIVER_STATIC_EXT}")
        IF(EXISTS ${_FILE})
          SET(NELDRIVER_${_UPDRIVER}_LIBRARY_RELEASE ${_FILE})

          MESSAGE(STATUS "Found NeL release static driver ${_DRIVER}: ${_FILE}")

          SET(NEL_STATIC_DRIVERS ON)

          IF(NOT NEL_DRIVER_DIR)
            SET(NEL_DRIVER_DIR ${_DIR})
          ENDIF()
        ENDIF()
      ENDIF()

      IF(_DRIVER_DEBUG_FILE)
        SET(_FILE "${_DIR}/${_DRIVER_RELASE_FILE}.${_DRIVER_SHARED_EXT}")
        IF(EXISTS ${_FILE})
          SET(NELDRIVER_${_UPDRIVER}_BINARY_DEBUG ${_FILE})

          MESSAGE(STATUS "Found NeL debug shared driver ${_DRIVER}: ${_FILE}")

          SET(NEL_STATIC_DRIVERS OFF)

          IF(NOT NEL_DRIVER_DIR)
            SET(NEL_DRIVER_DIR ${_DIR})
          ENDIF()
        ENDIF()

        SET(_FILE "${_DIR}/${_DRIVER_RELASE_FILE}.${_DRIVER_STATIC_EXT}")
        IF(EXISTS ${_FILE})
          SET(NELDRIVER_${_UPDRIVER}_LIBRARY_DEBUG ${_FILE})

          MESSAGE(STATUS "Found NeL debug static driver ${_DRIVER}: ${_FILE}")

          SET(NEL_STATIC_DRIVERS ON)

          IF(NOT NEL_DRIVER_DIR)
            SET(NEL_DRIVER_DIR ${_DIR})
          ENDIF()
        ENDIF()

        IF(_FOUND)
          SET(NELDRIVER_${_UPDRIVER}_FOUND ON)
          LIST(APPEND NEL_DRIVERS_FOUND ${_DRIVER})
        ENDIF()
      ENDIF()
    ENDFOREACH()
  ENDFOREACH()

  MESSAGE(STATUS "Found NeL driver in ${NEL_DRIVER_DIR}")

  PARSE_VERSION_OTHER(${NEL_INCLUDE_DIR}/nel/misc/version_nl.h NL_VERSION_MAJOR NL_VERSION_MINOR NL_VERSION_PATCH NL_REVISION)

  SET(NEL_VERSION_MAJOR ${NL_VERSION_MAJOR})
  SET(NEL_VERSION_MINOR ${NL_VERSION_MINOR})
  SET(NEL_VERSION_PATCH ${NL_VERSION_PATCH})
  SET(NEL_REVISION ${NL_REVISION})

  IF(NOT NEL_VERSION)
    IF(NEL_VERSION_MAJOR OR NEL_VERSION_MINOR} OR NEL_VERSION_PATCH)
      SET(NEL_VERSION "${NEL_VERSION_MAJOR}.${NEL_VERSION_MINOR}.${NEL_VERSION_PATCH}")
    ELSE()
      SET(NEL_VERSION "0.5.0")
    ENDIF()

    IF(NEL_REVISION)
      SET(NEL_VERSION "${NEL_VERSION}.${NEL_REVISION}")
    ENDIF()
  ENDIF()

  FIND_PACKAGE(PNG REQUIRED)
  IF(PNG_FOUND)
    LIST(APPEND NELMISC_LIBRARIES ${PNG_LIBRARIES})
  ENDIF()

  FIND_PACKAGE(Jpeg REQUIRED)
  IF(JPEG_FOUND)
    LIST(APPEND NELMISC_LIBRARIES ${JPEG_LIBRARY})
  ENDIF()

  FIND_PACKAGE(GIF)

  IF(GIF_FOUND)
    LIST(APPEND NELMISC_LIBRARIES ${GIF_LIBRARY})
  ENDIF()

  FIND_LIBXML2()

  IF(LIBXML2_FOUND)
    LIST(APPEND NELMISC_LIBRARIES ${LIBXML2_LIBRARIES})
  ENDIF()

  LIST(REMOVE_ITEM NeL_FIND_COMPONENTS misc)

  LIST(APPEND NEL_MODULES_FOUND misc)
  LIST(APPEND NEL_LIBRARIES ${NELMISC_LIBRARIES})
ENDIF()

IF(NOT NeL_FIND_COMPONENTS)
  SET(NeL_FIND_COMPONENTS ${NEL_MODULES_AVAILABLE})

  # We can skip not installed modules
  SET(NeL_FIND_REQUIRED OFF)
ENDIF()

FOREACH(COMPONENT ${NeL_FIND_COMPONENTS})
  SET(_NAME NeL${COMPONENT})
  STRING(TOUPPER ${_NAME} _UPNAME)

  # module is required
  SET(${_NAME}_FIND_REQUIRED ${NeL_FIND_REQUIRED})

  IF(COMPONENT STREQUAL "3d")
    SET(HEADER_FILE shape.h)
#  ELSEIF(COMPONENT STREQUAL "cegui")
#    SET(HEADER_FILE shape.h)
  ELSEIF(COMPONENT STREQUAL "georges")
    SET(HEADER_FILE form.h)
  ELSEIF(COMPONENT STREQUAL "gui")
    SET(HEADER_FILE reflect.h)
  ELSEIF(COMPONENT STREQUAL "ligo")
    SET(HEADER_FILE primitive.h)
  ELSEIF(COMPONENT STREQUAL "logic")
    SET(HEADER_FILE logic_state.h)
  ELSEIF(COMPONENT STREQUAL "net")
    SET(HEADER_FILE sock.h)
  ELSEIF(COMPONENT STREQUAL "pacs")
    SET(HEADER_FILE primitive_block.h)
#  ELSEIF(COMPONENT STREQUAL "pipeline")
#    SET(HEADER_FILE shape.h)
  ELSEIF(COMPONENT STREQUAL "sound")
    SET(HEADER_FILE shape.h)
  ELSE()
    SET(HEADER_FILE)
  ENDIF()

  # display if a component has a wrong name
  IF(NOT HEADER_FILE)
    MESSAGE(STATUS "NeL module ${COMPONENT} not supported, ignoring it...")
    CONTINUE()
  ENDIF()

  FIND_PACKAGE_HELPER(${_NAME} nel/${COMPONENT}/${HEADER_FILE}
    RELEASE nel${COMPONENT}_r nel${COMPONENT}
    DEBUG nel${COMPONENT}_d
    QUIET)

  IF(${_UPNAME}_FOUND)
    LIST(APPEND NEL_MODULES_FOUND ${COMPONENT})

    IF(COMPONENT STREQUAL "3d")
      IF(NEL_STATIC)
        # 3rd party dependencies
        FIND_PACKAGE(Freetype REQUIRED)
        IF(FREETYPE_FOUND)
          LIST(APPEND ${_UPNAME}_LIBRARIES ${FREETYPE_LIBRARIES})
        ENDIF()

        # Append static 3D drivers
        IF(NEL_STATIC_DRIVERS)
          # Direct3D driver (only under Windows)
          IF(WIN32)
            IF(NELDRIVER_DIRECT3D_LIBRARY_DEBUG)
              LIST(APPEND ${_UPNAME}_LIBRARIES debug ${NELDRIVER_DIRECT3D_LIBRARY_DEBUG})
            ENDIF()

            IF(NELDRIVER_DIRECT3D_LIBRARY_RELEASE)
              LIST(APPEND ${_UPNAME}_LIBRARIES optimized ${NELDRIVER_DIRECT3D_LIBRARY_RELEASE})
            ENDIF()
          ENDIF()

          # OpenGL driver
          IF(NELDRIVER_OPENGL_LIBRARY_DEBUG)
            LIST(APPEND ${_UPNAME}_LIBRARIES debug ${NELDRIVER_OPENGL_LIBRARY_DEBUG})
          ENDIF()

          IF(NELDRIVER_OPENGL_LIBRARY_RELEASE)
            LIST(APPEND ${_UPNAME}_LIBRARIES optimized ${NELDRIVER_OPENGL_LIBRARY_RELEASE})
          ENDIF()
        ENDIF()
      ENDIF()
    ELSEIF(COMPONENT STREQUAL "gui")
      FIND_PACKAGE(Luabind REQUIRED)

      LIST(APPEND ${_UPNAME}_LIBRARIES ${LUABIND_LIBRARIES})

      FIND_LIBCURL()

      IF(CURL_FOUND)
        LIST(APPEND ${_UPNAME}_LIBRARIES ${CURL_LIBRARIES})
        LIST(APPEND ${_UPNAME}_DEFINITIONS ${CURL_DEFINITIONS})
      ENDIF()

      # TODO: remove complately OpenSSL requirement on Windows

      # Only used by libcurl under Linux
      FIND_PACKAGE(OpenSSL REQUIRED)

      IF(WIN32)
        LIST(APPEND OPENSSL_LIBRARIES Crypt32.lib)
      ENDIF()

      # Only Linux version of libcurl depends on OpenSSL
      LIST(APPEND CURL_INCLUDE_DIRS ${OPENSSL_INCLUDE_DIR})
      LIST(APPEND CURL_LIBRARIES ${OPENSSL_LIBRARIES})

      LIST(APPEND ${_UPNAME}_LIBRARIES ${LUABIND_LIBRARIES} ${CURL_LIBRARIES})
      LIST(APPEND NEL_DEFINITIONS ${${_UPNAME}_DEFINITIONS})
    ELSEIF(COMPONENT STREQUAL "sound")
      FIND_PACKAGE(Ogg REQUIRED)

      IF(OGG_FOUND)
        LIST(APPEND ${_UPNAME}_LIBRARIES ${OGG_LIBRARY})
      ENDIF()

      FIND_PACKAGE(Vorbis REQUIRED)

      IF(VORBIS_FOUND)
        LIST(APPEND ${_UPNAME}_LIBRARIES ${VORBIS_LIBRARY} ${VORBISFILE_LIBRARY})
      ENDIF()

      IF(NEL_STATIC)
        # Link to snd_lowlevel
        FIND_LIBRARY_HELPER(nelsnd_lowlevel RELEASE nelsnd_lowlevel_r DEBUG nelsnd_lowlevel_d DIR ${NEL_DIR} REQUIRED)

        IF(NELSND_LOWLEVEL_LIBRARIES)
          MESSAGE(STATUS "Found NeL sound lowlevel ${NELSND_LOWLEVEL_LIBRARIES}")

          LIST(APPEND NELSOUND_LIBRARIES ${NELSND_LOWLEVEL_LIBRARIES})

          IF(NEL_STATIC_DRIVERS)
            # DirectSound, XAudio2 and FMod drivers (only under Windows)
            IF(WIN32)
              # DirectSound
              IF(NELDRIVER_DIRECTSOUND_LIBRARY_DEBUG)
                LIST(APPEND NELSOUND_LIBRARIES debug ${NELDRIVER_DIRECTSOUND_LIBRARY_DEBUG})
              ENDIF()

              IF(NELDRIVER_DIRECTSOUND_LIBRARY_RELEASE)
                LIST(APPEND NELSOUND_LIBRARIES optimized ${NELDRIVER_DIRECTSOUND_LIBRARY_RELEASE})
              ENDIF()

              # FMod
              IF(NELDRIVER_FMOD_LIBRARY_DEBUG)
                LIST(APPEND NELSOUND_LIBRARIES debug ${NELDRIVER_FMOD_LIBRARY_DEBUG})
              ENDIF()

              IF(NELDRIVER_FMOD_LIBRARY_RELEASE)
                LIST(APPEND NELSOUND_LIBRARIES optimized ${NELDRIVER_FMOD_LIBRARY_RELEASE})
              ENDIF()

              # XAudio2
              IF(NELDRIVER_XAUDIO2_LIBRARY_DEBUG)
                LIST(APPEND NELSOUND_LIBRARIES debug ${NELDRIVER_XAUDIO2_LIBRARY_DEBUG})
              ENDIF()

              IF(NELDRIVER_XAUDIO2_LIBRARY_RELEASE)
                LIST(APPEND NELSOUND_LIBRARIES optimized ${NELDRIVER_XAUDIO2_LIBRARY_RELEASE})
              ENDIF()
            ENDIF()

            # OpenAL driver
            IF(NELDRIVER_OPENAL_LIBRARY_DEBUG)
              LIST(APPEND NELSOUND_LIBRARIES debug ${NELDRIVER_OPENAL_LIBRARY_DEBUG})
            ENDIF()

            IF(NELDRIVER_OPENAL_LIBRARY_RELEASE)
              LIST(APPEND NELSOUND_LIBRARIES optimized ${NELDRIVER_OPENAL_LIBRARY_RELEASE})
            ENDIF()
          ENDIF()
        ENDIF()
      ENDIF()
    ENDIF()

    LIST(APPEND NEL_LIBRARIES ${${_UPNAME}_LIBRARIES})
  ENDIF()
ENDFOREACH()

MESSAGE_VERSION_PACKAGE_HELPER(NeL ${NEL_VERSION} ${NEL_MODULES_FOUND})
