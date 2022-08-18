import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: win
    width: 360
    height: 360
    visible: true
    color: "black"

    Rectangle {
        id: block
        width: 20
        height: 20
        color: "green"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                console.log("Entered")
                menu.visible = true
                menu.requestActivate()
            }
        }

        Window {
            id: menu
            width: 100
            height: 100
            x: Screen.width - (width + 20)
            y: Screen.height - (height + 20)

            flags: Qt.Popup
            color: "red"
            visible: false

            onActiveChanged: {
                console.log("Pop up:", active)
                if (!active) {
                    visible = false
                }
            }
        }
    }

    onActiveChanged: {
        console.log("Main win:", active)
    }
}
