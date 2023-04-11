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
      return eyetimer.work_time;
    case Plugin.Eyetimer.Timeout:
      return eyetimer.rest_time;
    }
  }
  property int value: eyetimer.work_time
  property int state: eyetimer.timer_state

  Connections {
    target: eyetimer

    function onTick(sec) {
      root.value = sec;
    }

    function onTimer_stateChanged() {
      switch (eyetimer.timer_state) {
      case Plugin.Eyetimer.Pause:
        mainwindow.visible_lock = true;
        delayhide.stop();
        //        mainwindow.opacity = 1
        mainwindow.width = Screen.width / 2;
        mainwindow.height = Screen.height / 2;
        mainwindow.x = 0;
        mainwindow.y = 0;
        break;
      case Plugin.Eyetimer.Ticking:
        delayhide.start();
        //        mainwindow.opacity = 0.8
        mainwindow.width = 300;
        mainwindow.height = 300;
        mainwindow.x = Screen.width - 100;
        mainwindow.y = Screen.height - 100;
        break;
      case Plugin.Eyetimer.Timeout:
        mainwindow.visible_lock = true;
        //        mainwindow.opacity = 1
        mainwindow.width = Screen.width;
        mainwindow.height = Screen.height;
        mainwindow.x = 0;
        mainwindow.y = 0;
        break;
      default:
        break;
      }
    }

    function onWarnClose(sec) {
      if (eyetimer.timer_state === Plugin.Eyetimer.Ticking)
      /* noti.visible = true */
      {
      } else {
        /* noti.visible = false */
        plasmoid.expanded = true;
      }
    }
  }

  Plugin.Eyetimer {
    id: eyetimer
  }

  Plasmoid.fullRepresentation: Item {
    id: fullroot
    width: 300 * PlasmaCore.Units.devicePixelRatio
    height: 300 * PlasmaCore.Units.devicePixelRatio

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
