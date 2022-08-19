import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import my.ticktimer 1.0
import my.controller 1.0
import Qt.labs.platform 1.1

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Eye protector")
    flags: {
        Qt.Window | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
    }
    color: "#303338"
    property int state: Ticktimer.Pause
    property int work_time: ticktimer.getWorkRestTime()[0]
    property int rest_time: ticktimer.getWorkRestTime()[1]

    Connections {
        target: ticktimer

        function onStateChanged(st) {
            root.state = Qt.binding(() => {
                                        return st
                                    })

            switch (root.state) {
            case Ticktimer.Pause:
                root.visible = true
                break
            case Ticktimer.Ticking:
                break
            case Ticktimer.Timeout:
                root.visible = true
                break
            default:
                break
            }
        }
    }

    Connections {
        target: trayicon

        function onActivated(reason) {
            console.log("trayicon:", reason)
            switch (reason) {
            case SystemTrayIcon.Trigger:
                root.visible = true
                break
            default:
                break
            }
        }
    }

    MouseArea {}

    onActiveChanged: {
        console.log("Pop up:", active)
        if (!active && root.state == Ticktimer.Ticking) {
            visible = false
        }
    }

    RoundProgButton {

        id: rp_butt
        radius: 250
    }

    TrayIcon {
        id: trayicon
    }
}
