import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import com.github.kie4280.eyeprotector2.plugin 1.0 as Plugin

Item {
  // copied from https://github.com/Wanderson-Magalhaes/Circular_ProgressBar
  id: progress
  implicitWidth: radius
  implicitHeight: radius
  anchors.centerIn: parent

  // Properties
  // General
  property bool roundCap: true
  property int startAngle: -90
  property int maxValue: 1
  property real value: 0
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

      property real val: progress.value

      Behavior on val  {
        PropertyAnimation {
          duration: 1000
          easing.type: Easing.Linear
        }
      }
      PathAngleArc {
        radiusX: (progress.width / 2) - (progress.progressWidth / 2)
        radiusY: (progress.height / 2) - (progress.progressWidth / 2)
        centerX: progress.width / 2
        centerY: progress.height / 2
        startAngle: progress.startAngle
        sweepAngle: (360 / progress.maxValue * path.val)
      }
    }
  }

  Button {
    id: butt1
    anchors.centerIn: parent
    width: progress.radius - 50
    height: progress.radius - 50

    function sec2time(sec) {
      let secs = sec % 60;
      sec = Math.floor(sec / 60);
      let mins = sec % 60;
      let hs = Math.floor(sec / 60);
      let d = new Date(0);
      d.setHours(hs);
      d.setSeconds(secs);
      d.setMinutes(mins);
      return d.toTimeString().substring(0, 8);
    }

    property string second_text: {
      switch (progress.state) {
      case Plugin.Eyetimer.Pause:
      case Plugin.Eyetimer.Ticking:
      case Plugin.Eyetimer.Timeout:
        return sec2time(progress.value);
      default:
        return qsTr("Invalid");
      }
    }

    property string state_text: {
      switch (progress.state) {
      case Plugin.Eyetimer.Pause:
        return qsTr("Start");
      case Plugin.Eyetimer.Ticking:
        return qsTr("Pause");
      case Plugin.Eyetimer.Timeout:
        return qsTr("Postpone");
      default:
        return qsTr("Invalid");
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
      if (progress.state === Plugin.Eyetimer.Pause) {
        eyetimer.start();
      } else if (progress.state === Plugin.Eyetimer.Ticking) {
        eyetimer.pause();
      }
    }
  }
}
