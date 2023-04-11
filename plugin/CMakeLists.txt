
set(eyeprotectorplugin_SRC
    eyetimer.cpp 
    extension.cpp)

add_library(eyeprotectorplugin SHARED ${eyeprotectorplugin_SRC})

target_link_libraries(eyeprotectorplugin
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
)
install(TARGETS eyeprotectorplugin DESTINATION ${KDE_INSTALL_QMLDIR}/com/github/kie4280/eyeprotector2/plugin)
install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/com/github/kie4280/eyeprotector2/plugin)
