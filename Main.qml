import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import TickTimer 1.0
import Qt.labs.platform 1.1

Window {
    id: mainwindow
    x: 50
    y: 50
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
            mainwindow.state = Qt.binding(() => {
                                              return st
                                          })
            if (mainwindow.state === Ticktimer.Pause) {
                butt1.visible = true
                butt1.text = qsTr("Start")
            } else if (mainwindow.state === Ticktimer.Ticking) {
                butt1.visible = true
                butt1.text = "Pause"
            } else {
                butt1.text = "Postpone"
            }
        }
    }

    Button {
        id: butt1
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        width: 100
        height: 100

        background: Rectangle {
            color: parent.hovered ? "dimgray" : "gray"
            Text {
                anchors.centerIn: parent
                text: butt1.text
            }
            radius: width * 0.5
        }

        text: qsTr("Start")

        onClicked: {
            if (mainwindow.state === Ticktimer.Pause) {
                ticktimer.start()
            } else if (mainwindow.state === Ticktimer.Ticking) {
                ticktimer.pause()
            }
        }
    }

    Text {
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2 - butt1.height
        id: seconds_text
        text: mainwindow.work_time
    }
}
