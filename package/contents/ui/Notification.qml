import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import my.ticktimer 1.0

Window {
  id: noti
  width: 200
  height: 100
  x: Screen.width - (width + 20)
  y: Screen.height - (height + 60)

  visible: false
  flags: {
    Qt.Popup | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint;
  }
  color: "dimgray"

  //    color: "red"
  property string text: ""
  property bool hasProgress: false
  property real value: 0.5

  Rectangle {
    width: 190
    height: 90
    anchors.centerIn: parent
    color: "#303338"
    radius: 5

    Column {
      spacing: 10

      ProgressBar {
        anchors.right: parent.right
        anchors.left: parent.left
        value: 100
      }

      Text {
        anchors.horizontalCenter: parent.horizontalCenter

        color: "white"
        font {
          bold: true
          pointSize: 16
        }

        text: qsTr(noti.text)
      }
    }
  }
}
