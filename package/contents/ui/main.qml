import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.4 as Kirigami
import com.github.kie4280.eyeprotector2.plugin 1.0 as Plugin

Item {
  id: root

  property int maxValue: {
    switch (eyetimer.timer_state) {
    case Plugin.Eyetimer.Ticking:
    case Plugin.Eyetimer.Pause:
    case Plugin.Eyetimer.Recharging:
      return eyetimer.work_time;
    case Plugin.Eyetimer.Timeout:
      return eyetimer.rest_time;
    }
  }
  property alias value: eyetimer.counter_value
  property alias state: eyetimer.timer_state
  property bool autohide: false
    
  Plasmoid.hideOnWindowDeactivate: root.autohide

  Plugin.Eyetimer {
    id: eyetimer
    work_time: plasmoid.configuration.work_time_sec
    rest_time: plasmoid.configuration.rest_time_sec
  }

  Connections {
    target: eyetimer

    function onTick(sec) {
    }

    function onTimer_stateChanged() {
      switch (eyetimer.timer_state) {
      case Plugin.Eyetimer.Pause:
      case Plugin.Eyetimer.Recharging:
        plasmoid.expanded = true;
        root.autohide = false
        break;
      case Plugin.Eyetimer.Ticking:
        root.autohide = true
        break;
      case Plugin.Eyetimer.Timeout:
        plasmoid.expanded = true;
        root.autohide = false
        break;
      default:
        break;
      }
    }

    function onWarnClose(sec) {
      if (eyetimer.timer_state === Plugin.Eyetimer.Ticking) {

      } else {

      }
    }
  }


  Plasmoid.fullRepresentation: Item {
    id: fullroot
    Layout.preferredWidth: 300 * PlasmaCore.Units.devicePixelRatio
    Layout.preferredHeight: 300 * PlasmaCore.Units.devicePixelRatio

    CheckBox {
      id: enabledCheck
      checked: true
      text: qsTr("Enabled")
      onCheckedChanged: {
        eyetimer.reset();
        root.autohide = !checked;
      }
    }
    RoundProgButton {
      id: rpbutt
      maxValue: root.maxValue
      anchors.top: enabledCheck.bottom
      anchors.topMargin: 30
      anchors.horizontalCenter: parent.horizontalCenter
      value: root.value
      state: root.state
      visible: enabledCheck.checked
      radius: 200
    }
  }

  /* Plasmoid.compactRepresentation: Item { */
  /*   id: compactroot */

  /*   Text { */
  /*     text: qsTr("sdklfsjf") */
  /*   } */
  /* } */
}
