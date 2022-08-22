import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import my.ticktimer 1.0
import Qt.labs.platform 1.1

Window {
    id: mainwindow
    width: Screen.width
    height: Screen.height
    title: qsTr("Eye protector")
    flags: {
        Qt.Window | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
    }
    color: "#303338"
    visible: mainwindow.visible_lock || hoverdetector.hovered
    property int state: Ticktimer.Pause
    property int work_time: ticktimer.getWorkRestTime()[0]
    property int rest_time: ticktimer.getWorkRestTime()[1]
    property bool visible_lock: true

    Connections {
        target: ticktimer

        function onStateChanged(st) {
            mainwindow.state = st
            switch (mainwindow.state) {
            case Ticktimer.Pause:
                mainwindow.visible_lock = true
                delayhide.stop()
                mainwindow.opacity = 1
                mainwindow.x = 0
                mainwindow.y = 0
                mainwindow.width = Screen.width
                mainwindow.height = Screen.height
                break
            case Ticktimer.Ticking:
                delayhide.start()
                mainwindow.opacity = 0.8
                mainwindow.width = 300
                mainwindow.height = 300
                mainwindow.x = Screen.width - (mainwindow.width + 40)
                mainwindow.y = Screen.height - (mainwindow.height + 50)
                break
            case Ticktimer.Timeout:
                mainwindow.visible_lock = true
                mainwindow.opacity = 1
                mainwindow.x = 0
                mainwindow.y = 0
                mainwindow.width = Screen.width
                mainwindow.height = Screen.height
                break
            default:
                break
            }
        }

        function onWarnClose(sec) {
            if (mainwindow.state === Ticktimer.Ticking) {
                noti.visible = true
            } else {
                noti.visible = false
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
            mainwindow.visible_lock = false
        }
    }

    Connections {
        target: trayicon

        function onActivated(reason) {
            console.log("trayicon:", reason)
            switch (reason) {
            case SystemTrayIcon.Trigger:
                mainwindow.visible_lock = true
                delayhide.start()
                break
            default:
                break
            }
        }
    }

    Notification {
        id: noti
        hasProgress: true
        text: "Time to wrap up!"
    }

    TrayIcon {
        id: trayicon
    }
}
