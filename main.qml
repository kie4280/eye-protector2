import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import TickTimer 1.0

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    x: 100
    id: root
    property int state: Ticktimer.Pause
    property int work_time: ticktimer.getWorkRestTime()[0]
    property int rest_time: ticktimer.getWorkRestTime()[1]

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
                butt1.visible = true
                butt1.text = "Start"
            } else if (root.state === Ticktimer.Ticking) {
                butt1.visible = true
                butt1.text = "Pause"
            } else {
                butt1.text = "Postpone"
            }
        }
    }

    Button {
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        text: {
            if (root.state === Ticktimer.Pause) {
                return "Start"
            } else if (root.state === Ticktimer.Ticking) {
                return "Pause"
            } else {
                visible = false
                return "dklmjd"
            }
        }

        id: butt1
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
        text: work_time
    }
}
