import QtQuick 2.15
import Qt.labs.platform 1.1

SystemTrayIcon {
  id: trayicon
  visible: true
  icon.source: "qrc:/timer.png"

  menu: Menu {
    visible: false
    MenuItem {
      text: qsTr("Settings")
    }
    MenuItem {
      text: qsTr("Quit")
      onTriggered: Qt.quit()
    }
  }
}
