
set(KREPEL_EZ_TARGETS ThirdParty Foundation Core CoreUtils System
    CACHE STRING "The ezEngine compoenents to copy over.")
set(KREPEL_EZ_CODE_DEST_DIR "$ENV{KREPEL_DIR}/code"
    CACHE PATH "Destination of the ezEngine source files.")
set(KREPEL_BIN_DIR "$ENV{KREPEL_DIR}/bin"
    CACHE PATH "Destination of the ezEngine binaries.")
set(KREPEL_LIB_DIR "$ENV{KREPEL_DIR}/lib"
    CACHE PATH "Destination of the ezEngine libraries.")

list(GET KREPEL_EZ_TARGETS 0 EZ_TARGET)
find_program(KREPEL_PY_EXE py)
add_custom_target(ezEngine_CopyToKrepel
                  COMMAND "${KREPEL_PY_EXE}" -3 "${CMAKE_SOURCE_DIR}/../ezEngine_CopyToKrepel.py"
                          --ezDir="${CMAKE_CURRENT_SOURCE_DIR}"
                          --ezBinDir="$<TARGET_FILE_DIR:${EZ_TARGET}>"
                          --ezLibDir="$<TARGET_LINKER_FILE_DIR:${EZ_TARGET}>"
                          --krEzCodeDestDir="${KREPEL_EZ_CODE_DEST_DIR}"
                          --krBinDir="${KREPEL_BIN_DIR}"
                          --krLibDir="${KREPEL_LIB_DIR}"
                          --config="$<CONFIG>"
                          #--quiet
                          #--dry-run
                          ${KREPEL_EZ_TARGETS}
                  COMMENT "Copying ezEngine files to krepel."
                  SOURCES "${CMAKE_SOURCE_DIR}/../ezEngine_CopyToKrepel.py")
add_dependencies(ezEngine_CopyToKrepel ${KREPEL_EZ_TARGETS})
