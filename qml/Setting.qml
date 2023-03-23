import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQml 2.15
import QtQuick.Controls.Material 2.15

Window {
    height: 300
    width: 300
    visible: true
    x: Screen.width - width / 2 - 100
    y: Screen.height - height / 2 - 200

    ColumnLayout {
        anchors.centerIn: parent
        SpinBox {
            id: rest_sec
            value: 300
            from:0
            to:99999999
            editable: true
        }

        SpinBox {
            id: use_sec
            value: 1200
            from: 0
            to: 99999999
            editable: true
        }

        SpinBox {
            id: postpone_sec
            value: 300
            from: 0
            to: 99999999
            editable: true
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            Button {
                id: reset_butt
                text: qsTr("Reset")
            }

            Button {
                id: apply_butt
                text: qsTr("Apply")
            }
        }
    }

}
