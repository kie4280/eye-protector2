import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
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
  property int value: eyetimer.counter_value
  property int state: eyetimer.timer_state
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
        plasmoid.expanded = true;
      }
    }
  }


  Plasmoid.fullRepresentation: Item {
    id: fullroot
    width: 300 * PlasmaCore.Units.devicePixelRatio
    height: 200 * PlasmaCore.Units.devicePixelRatio

    RoundProgButton {
      id: rpbutt
      maxValue: root.maxValue
      value: root.value
      state: root.state
    }
  }

  /* Plasmoid.compactRepresentation: Item { */
  /*   id: compactroot */

  /*   Text { */
  /*     text: qsTr("sdklfsjf") */
  /*   } */
  /* } */
}
