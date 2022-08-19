import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: menu
    width: 100
    height: 100
    x: Screen.width - (width + 20)
    y: Screen.height - (height + 20)

    visible: false
    title: qsTr("Time is up")
    flags: {
        Qt.Window | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
    }
    color: "#303338"
}
