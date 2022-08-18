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
    color: "dimgray"
    property int state: Ticktimer.Pause
    readonly property int work_time: ticktimer.getWorkRestTime()[0]
    readonly property int rest_time: ticktimer.getWorkRestTime()[1]

    Connections {
        target: ticktimer
        function onTick(sec) {
            seconds_text.text = sec
        }

        function onStateChanged(st) {
            root.state = Qt.binding(() => {
                                        return st
                                    })
            if (root.state === Ticktimer.Pause) {
                root.visible = true
                butt1.visible = true
                butt1.text = qsTr("Start")
            } else if (root.state === Ticktimer.Ticking) {
                butt1.visible = true
                butt1.text = "Pause"
            } else {
                butt1.text = "Postpone"
                root.visible = true
            }
        }
    }

    onActiveChanged: {
        console.log("Pop up:", active)
        if (!active && root.state == Ticktimer.Ticking) {
            visible = false
        }
    }

    Item {
        id: mainwindow
        anchors.centerIn: parent
        Button {
            id: butt1
            x: mainwindow.width / 2 - width / 2
            y: mainwindow.height / 2 - height / 2
            width: 100
            height: 100

            background: Rectangle {
                color: parent.hovered ? "dimgray" : "gray"
                Text {
                    anchors.centerIn: parent
                    text: butt1.text
                    color: "white"
                }
                radius: width * 0.5
            }

            text: qsTr("Start")

            onClicked: {
                if (root.state === Ticktimer.Pause) {
                    ticktimer.start()
                } else if (root.state === Ticktimer.Ticking) {
                    ticktimer.pause()
                }
            }
        }

        Text {
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2 - butt1.height
            id: seconds_text
            text: root.work_time
        }
    }

    Notification {
        id: notif
        property bool opened: false
        Connections {
            target: trayicon
            function onActivated(reason) {
                console.log("activated")

                switch (reason) {
                case SystemTrayIcon.Trigger:
                    root.visible = true
                    if (!notif.visible) {
                        notif.visible = true
                        console.log("open notif")
                    }
                    break
                default:
                    break
                }
            }
        }
    }

    TrayIcon {
        id: trayicon
    }
}
