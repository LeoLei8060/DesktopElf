cmake_minimum_required(VERSION 3.16)

project(DesktopElf VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find required Qt5 components
find_package(Qt5 REQUIRED COMPONENTS Core Widgets Qml Quick QuickControls2)

# Set Qt5 properties
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Include directories
include_directories(${CMAKE_SOURCE_DIR}/src)
include_directories(${CMAKE_SOURCE_DIR}/src/controllers)

# Source files
set(SOURCES
    src/main.cpp
    src/controllers/SpriteController.cpp
    src/controllers/ConfigManager.cpp
    src/controllers/TimerManager.cpp
    src/controllers/FitnessManager.cpp
)

# Header files
set(HEADERS
    src/controllers/SpriteController.h
    src/controllers/ConfigManager.h
    src/controllers/TimerManager.h
    src/controllers/FitnessManager.h
)

# Resource files
set(RESOURCES
    resources.qrc
)

# Create executable
add_executable(DesktopElf
    ${SOURCES}
    ${HEADERS}
    ${RESOURCES}
)

# Link Qt5 libraries
target_link_libraries(DesktopElf
    Qt5::Core
    Qt5::Widgets
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
)

# Set target properties
set_target_properties(DesktopElf PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

# Windows specific settings
if(WIN32)
    # Set application icon (if available)
    # set_target_properties(DesktopElf PROPERTIES
    #     WIN32_EXECUTABLE TRUE
    #     LINK_FLAGS "/SUBSYSTEM:WINDOWS"
    # )
    
    # Copy Qt5 DLLs to output directory for Windows deployment
    if(CMAKE_BUILD_TYPE STREQUAL "Release")
        # Add windeployqt command for release builds
        find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS ${Qt5_DIR}/../../../bin)
        if(WINDEPLOYQT_EXECUTABLE)
            add_custom_command(TARGET DesktopElf POST_BUILD
                COMMAND ${WINDEPLOYQT_EXECUTABLE} --qmldir ${CMAKE_SOURCE_DIR}/src/qml $<TARGET_FILE:DesktopElf>
                COMMENT "Deploying Qt libraries"
            )
        endif()
    endif()
endif()

# Installation settings
install(TARGETS DesktopElf
    BUNDLE DESTINATION .
    RUNTIME DESTINATION bin
)

# Install resources
install(DIRECTORY resources/
    DESTINATION resources
    FILES_MATCHING PATTERN "*"
)

# CPack settings for packaging
set(CPACK_PACKAGE_NAME "DesktopElf")
set(CPACK_PACKAGE_VERSION "1.0.0")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Desktop Sprite Application")
set(CPACK_PACKAGE_VENDOR "DesktopElf Team")

if(WIN32)
    set(CPACK_GENERATOR "NSIS")
    set(CPACK_NSIS_DISPLAY_NAME "Desktop Elf")
    set(CPACK_NSIS_PACKAGE_NAME "DesktopElf")
    set(CPACK_NSIS_CONTACT "support@desktopelf.com")
endif()

include(CPack)