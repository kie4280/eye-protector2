import QtQuick 2.15
import QtQuick.Controls 2.15
import my.ticktimer 1.0
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.15

Item {
    id: progressbutton
    anchors.centerIn: parent

    property int state: Ticktimer.Pause
    property int work_time: ticktimer.getWorkRestTime()[0]
    property int rest_time: ticktimer.getWorkRestTime()[1]
    property int radius: 250

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

    Connections {
        target: ticktimer
        function onTick(sec) {
            butt1.second_text = Qt.binding(() => {
                                               return sec2time(sec)
                                           })
            progress.value = Qt.binding(() => {
                                            let p = sec * 100
                                            switch (progressbutton.state) {
                                                case Ticktimer.Pause:
                                                p = p / progressbutton.work_time
                                                break
                                                case Ticktimer.Ticking:
                                                p = p / progressbutton.work_time
                                                break
                                                case Ticktimer.Timeout:
                                                p = p / progressbutton.rest_time
                                                break
                                                default:
                                                break
                                            }

                                            return p
                                        })
        }

        function onStateChanged(st) {
            progressbutton.state = Qt.binding(() => {
                                                  return st
                                              })
            switch (progressbutton.state) {
            case Ticktimer.Pause:
                butt1.visible = true
                butt1.text = qsTr("Start")
                break
            case Ticktimer.Ticking:
                butt1.visible = true
                butt1.text = qsTr("Pause")
                break
            default:
                butt1.text = qsTr("Postpone")
                break
            }
        }
    }
    Rectangle {
        color: "#303338"
        width: progressbutton.radius
        height: progressbutton.radius
        radius: width * 0.5
        anchors.centerIn: parent
    }

    Item {
        // copied from https://github.com/Wanderson-Magalhaes/Circular_ProgressBar
        id: progress
        implicitWidth: progressbutton.radius
        implicitHeight: progressbutton.radius
        anchors.centerIn: parent

        // Properties
        // General
        property bool roundCap: true
        property int startAngle: -90
        property real maxValue: 100
        property real value: 100
        property int samples: 12
        // Drop Shadow
        property bool enableDropShadow: false
        property color dropShadowColor: "#20000000"
        property int dropShadowRadius: 10
        // Bg Circle
        property color bgColor: "transparent"
        property color bgStrokeColor: "#7e7e7e"
        property int strokeBgWidth: 16
        // Progress Circle
        property color progressColor: "#55aaff"
        property int progressWidth: 16

        // Internal Properties/Functions
        QtObject {
            id: internal

            property Component dropShadow: DropShadow {
                color: progress.dropShadowColor
                fast: true
                verticalOffset: 0
                horizontalOffset: 0
                samples: progress.samples
                radius: progress.dropShadowRadius
            }
        }

        Shape {
            id: shape
            anchors.fill: parent
            layer.enabled: true
            layer.samples: progress.samples
            layer.effect: progress.enableDropShadow ? internal.dropShadow : null

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
                    sweepAngle: (360 / progress.maxValue * progress.value)
                }
            }
        }
    }

    Button {
        id: butt1
        anchors.centerIn: parent
        width: progressbutton.radius - 50
        height: progressbutton.radius - 50

        property string second_text: sec2time(progressbutton.work_time)

        background: Rectangle {
            id: circ
            color: parent.hovered ? "dimgray" : "gray"
            radius: width * 0.5
            layer.samples: 8
            layer.enabled: true
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
                    text: butt1.text
                    color: "white"
                    font {
                        bold: true
                        pointSize: 16
                    }
                }
            }
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
}
