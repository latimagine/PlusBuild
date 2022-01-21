IF(aruco_DIR)
  FIND_PACKAGE(aruco 2.0.19 REQUIRED NO_MODULE)

  MESSAGE(STATUS "Using aruco available at: ${aruco_DIR}")

  # Copy libraries to CMAKE_RUNTIME_OUTPUT_DIRECTORY
  PlusCopyLibrariesToDirectory(${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ${aruco_LIBS})

  SET (PLUS_aruco_DIR ${aruco_DIR} CACHE INTERNAL "Path to store aruco binaries")
ELSE()
  # aruco has not been built yet, so download and build it as an external project
  # SetGitRepositoryTag(
  #   aruco
  #   "${GIT_PROTOCOL}://github.com/PlusToolkit/aruco.git"
  #   "master"
  #   )

  SET (PLUS_aruco_src_DIR ${CMAKE_BINARY_DIR}/aruco CACHE INTERNAL "Path to store aruco contents")
  SET (PLUS_aruco_prefix_DIR ${CMAKE_BINARY_DIR}/aruco-prefix CACHE INTERNAL "Path to store aruco prefix data.")
  SET (PLUS_aruco_DIR ${CMAKE_BINARY_DIR}/aruco-bin CACHE INTERNAL "Path to store aruco binaries.")

  ExternalProject_Add( aruco
    PREFIX ${PLUS_aruco_prefix_DIR}
    "${PLUSBUILD_EXTERNAL_PROJECT_CUSTOM_COMMANDS}"
    SOURCE_DIR "${PLUS_aruco_src_DIR}"
    BINARY_DIR "${PLUS_aruco_DIR}"
    #--Download step--------------
    #GIT_REPOSITORY ${aruco_GIT_REPOSITORY}
    #GIT_TAG ${aruco_GIT_TAG}
    URL https://downloads.sourceforge.net/project/aruco/3.1.12/aruco-3.1.12.zip
    URL_HASH SHA256=70b9ec8aa8eac6fe3f622201747a3e32c77bbb5f015e28a95c1c7c91f8ee8a09
    #--Configure step-------------
    CMAKE_ARGS
      ${ep_common_args}
      ${aruco_PLATFORM_SPECIFIC_ARGS}
      -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
      -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
      -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
      -DOpenCV_INSTALL_BINARIES_PREFIX:STRING= # Install to prefix directly, not arch/compiler/etc...
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
      -DOpenCV_DIR:PATH=${PLUS_OpenCV_DIR}
      -DUSE_OWN_EIGEN3=ON
      -DBUILD_TESTS:BOOL=OFF
      -DBUILD_PERF_TESTS:BOOL=OFF
      -DBUILD_SHARED_LIBS:BOOL=${PLUSBUILD_BUILD_SHARED_LIBS}
      -DCMAKE_INSTALL_PREFIX=${PLUS_aruco_DIR}
    #--Build step-----------------
    BUILD_ALWAYS 1
    #--Install step-----------------
    #--Dependencies-----------------
    DEPENDS OpenCV
  )
ENDIF()