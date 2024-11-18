import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import com.github.kie4280.eyeprotector2 1.0 as Plugin

Item {
    // copied from https://github.com/Wanderson-Magalhaes/Circular_ProgressBar
    id: progress
    implicitWidth: radius
    implicitHeight: radius

    // Properties
    // General
    property bool roundCap: true
    property int startAngle: -90
    property int maxValue: 1
    property int value: 0
    property real barVal: maxValue
    property int state: 0
    property int radius: 200
    property int samples: 4
    // Bg Circle
    property color bgColor: "transparent"
    property color bgStrokeColor: "#7e7e7e"
    property int strokeBgWidth: 16
    // Progress Circle
    property color progressColor: "#55aaff"
    property int progressWidth: 16

    onStateChanged: {
        barAnimation.stop()
        switch (progress.state) {
        case Plugin.Eyetimer.Pause:
            progress.barVal = progress.maxValue
            break
        case Plugin.Eyetimer.Recharging:
            if (progress.value != progress.maxValue) {
                barAnimation.from = progress.value
                barAnimation.to = progress.maxValue
                barAnimation.duration = (progress.maxValue - progress.value) * 1000
                barAnimation.start()
            }
            break
        case Plugin.Eyetimer.Ticking:
            barAnimation.from = progress.value
            barAnimation.to = 0
            barAnimation.duration = (progress.value) * 1000
            barAnimation.start()
            break
        case Plugin.Eyetimer.Timeout:
            barAnimation.from = progress.maxValue
            barAnimation.to = 0
            barAnimation.duration = (progress.maxValue) * 1000
            barAnimation.start()
            break
        }
    }

    PropertyAnimation {
        id: barAnimation
        target: progress
        property: "barVal"
        running: false
        easing.type: Easing.Linear
    }

    Shape {
        id: shape
        anchors.fill: parent
        layer.enabled: true
        layer.samples: progress.samples

        ShapePath {
            id: pathBG
            strokeColor: progress.bgStrokeColor
            fillColor: progress.bgColor
            strokeWidth: progress.strokeBgWidth
            capStyle: progress.roundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc {
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.startAngle
                sweepAngle: 360
            }
        }

        ShapePath {
            id: path
            strokeColor: progress.progressColor
            fillColor: "transparent"
            strokeWidth: progress.progressWidth
            capStyle: progress.roundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc {
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.startAngle
                sweepAngle: (360 / progress.maxValue * progress.barVal)
            }
        }
    }

    Button {
        id: butt1
        anchors.centerIn: parent
        width: progress.radius - 50
        height: progress.radius - 50

        function sec2time(sec) {
            let secs = sec % 60
            sec = Math.floor(sec / 60)
            let mins = sec % 60
            let hs = Math.floor(sec / 60)
            let d = new Date(0)
            d.setHours(hs)
            d.setSeconds(secs)
            d.setMinutes(mins)
            return d.toTimeString().substring(0, 8)
        }

        property string second_text: {
            switch (progress.state) {
            case Plugin.Eyetimer.Pause:
            case Plugin.Eyetimer.Recharging:
            case Plugin.Eyetimer.Ticking:
            case Plugin.Eyetimer.Timeout:
                return sec2time(progress.value)
            default:
                return qsTr("Invalid")
            }
        }

        property string state_text: {
            switch (progress.state) {
            case Plugin.Eyetimer.Pause:
            case Plugin.Eyetimer.Recharging:
                return qsTr("Start")
            case Plugin.Eyetimer.Ticking:
                return qsTr("Pause")
            case Plugin.Eyetimer.Timeout:
                return qsTr("Postpone")
            default:
                return qsTr("Invalid")
            }
        }

        background: Rectangle {
            id: circ
            color: parent.hovered ? "dimgray" : "gray"
            radius: width * 0.5
            Column {
                anchors.centerIn: parent
                spacing: 10
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: butt1.second_text
                    color: "white"
                    font {
                        bold: true
                        pointSize: 20
                    }
                }
                Shape {
                    width: circ.width
                    height: 10
                    anchors.horizontalCenter: parent.horizontalCenter

                    ShapePath {
                        strokeColor: "white"
                        strokeWidth: 8
                        strokeStyle: ShapePath.SolidLine
                        capStyle: ShapePath.RoundCap
                        startX: 0.15 * circ.width
                        startY: circ.y + 4
                        PathLine {
                            x: 0.85 * circ.width
                            y: circ.y + 4
                        }
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: butt1.state_text
                    color: "white"
                    font {
                        bold: true
                        pointSize: 16
                    }
                }
            }
        }

        onClicked: {
            eyetimer.toggle()
        }
    }
}
