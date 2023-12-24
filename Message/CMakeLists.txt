cmake_minimum_required(VERSION 3.16)

project(Message VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appMessage
    main.cpp
)

qt_add_qml_module(appMessage
    URI Message
    VERSION 1.0
    QML_FILES Main.qml
    QML_FILES CustomButton.qml
    QML_FILES CustomTextField.qml
    QML_FILES CustomPage.qml
    QML_FILES
    SOURCES Client.h
    SOURCES Client.cpp
)

set_target_properties(appMessage PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMessage
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appMessage
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
