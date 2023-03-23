import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import my.ticktimer 1.0
import Qt.labs.platform 1.1

Window {
  id: mainwindow
  width: Screen.width
  height: Screen.height
  title: qsTr("Eye protector")
  flags: {
    Qt.Window | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
  }
  color: "#303338"
  //  color: "#00000000"
  visible: mainwindow.visible_lock || hoverdetector.hovered

  property bool visible_lock: true
  property int timer_tick: ticktimer.work_time

  Connections {
    target: ticktimer

    function onTick(sec) {
      timer_tick = sec
    }

    function onTimer_stateChanged() {
      console.debug("screen param", Screen.width, Screen.height)
      console.debug("x, y", mainwindow.x, mainwindow.y)
      switch (ticktimer.timer_state) {
      case Ticktimer.Pause:
        mainwindow.visible_lock = true
        delayhide.stop()
        //        mainwindow.opacity = 1
        mainwindow.width = Screen.width / 2
        mainwindow.height = Screen.height / 2
        mainwindow.x = 0
        mainwindow.y = 0
        break
      case Ticktimer.Ticking:
        delayhide.start()
        //        mainwindow.opacity = 0.8
        mainwindow.width = 300
        mainwindow.height = 300
        mainwindow.x = Screen.width - 100
        mainwindow.y = Screen.height - 100
        break
      case Ticktimer.Timeout:
        mainwindow.visible_lock = true
        //        mainwindow.opacity = 1
        mainwindow.width = Screen.width
        mainwindow.height = Screen.height
        mainwindow.x = 0
        mainwindow.y = 0
        break
      default:
        break
      }
    }

    function onWarnClose(sec) {
      if (ticktimer.timer_state === Ticktimer.Ticking) {
        noti.visible = true
      } else {
        noti.visible = false
      }
    }
  }

  onActiveChanged: {

    //    console.debug("activeChanged", active)
  }

  RoundProgButton {
    id: rp_butt
    radius: 250
    state: ticktimer.timer_state
    value: timer_tick
  }

  HoverHandler {
    id: hoverdetector
    onHoveredChanged: {

      //      console.debug("hoverChanged")
    }
  }

  Timer {
    id: delayhide
    interval: 3000
    repeat: false
    onTriggered: {
      mainwindow.visible_lock = false
    }
  }

  Connections {
    target: trayicon

    function onActivated(reason) {
      console.debug("trayicon:", reason)
      switch (reason) {
      case SystemTrayIcon.Trigger:
        mainwindow.visible_lock = true
        delayhide.start()
        break
      default:
        break
      }
    }
  }

  Notification {
    id: noti
    hasProgress: true
    text: "Time to wrap up!"
  }

  TrayIcon {
    id: trayicon
  }
}
