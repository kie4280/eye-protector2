import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")


    Button {
        x: 20
        y: 20
        text: "Quit"
        onClicked: Qt.quit()
    }

    Text {
        text: qsTr("sdfsdfsf")
    }
}
