import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import my.ticktimer 1.0
import Qt.labs.platform 1.1

Window {
    id: root
    width: Screen.width
    height: Screen.height
    title: qsTr("Eye protector")
    flags: {
        Qt.Popup | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
    }
    color: "#303338"
    visible: root.visible_lock || hoverdetector.hovered
    property int state: Ticktimer.Pause
    property int work_time: ticktimer.getWorkRestTime()[0]
    property int rest_time: ticktimer.getWorkRestTime()[1]
    property bool visible_lock: true

    Connections {
        target: ticktimer

        function onStateChanged(st) {
            root.state = st
            switch (root.state) {
            case Ticktimer.Pause:
                root.visible_lock = true
                root.opacity = 1
                root.x = 0
                root.y = 0
                root.width = Screen.width
                root.height = Screen.height
                break
            case Ticktimer.Ticking:
                delayhide.start()
                root.opacity = 0.8
                root.width = 300
                root.height = 300
                root.x = Screen.width - (root.width + 40)
                root.y = Screen.height - (root.height + 50)
                break
            case Ticktimer.Timeout:
                root.visible_lock = true
                root.opacity = 1
                root.x = 0
                root.y = 0
                root.width = Screen.width
                root.height = Screen.height
                break
            default:
                break
            }
        }
    }

    onActiveChanged: {
        console.log("activeChanged", active)
    }

    RoundProgButton {
        id: rp_butt
        radius: 250
    }

    HoverHandler {
        id: hoverdetector
        onHoveredChanged: {
            console.log("hoverChanged")
        }
    }

    Timer {
        id: delayhide
        interval: 3000
        repeat: false
        onTriggered: {
            root.visible_lock = false
        }
    }

    Connections {
        target: trayicon

        function onActivated(reason) {
            console.log("trayicon:", reason)
            switch (reason) {
            case SystemTrayIcon.Trigger:
                root.visible_lock = true
                delayhide.start()
                break
            default:
                break
            }
        }
    }

    TrayIcon {
        id: trayicon
    }
}
