IF(WITH_RYZOM_CLIENT)
  # Don't need ryzom_client_patcher if using Steam
  IF(NOT WITH_RYZOM_STEAM)
    ADD_SUBDIRECTORY(client_patcher)
  ENDIF()

  IF(WITH_QT OR WITH_QT5)
    ADD_SUBDIRECTORY(client_config_qt)
  ENDIF()

ENDIF()

IF(WITH_QT5 AND WITH_RYZOM_INSTALLER)
  ADD_SUBDIRECTORY(ryzom_installer)
ENDIF()

IF(WITH_RYZOM_TOOLS AND MYSQL_FOUND)
  ADD_SUBDIRECTORY(r2_islands_textures)
ENDIF()
