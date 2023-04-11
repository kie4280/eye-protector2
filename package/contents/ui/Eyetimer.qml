import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
  id: eyetimer
  signal timer_tick(int seconds)

  property int ticks: 0

  Timer {
    id: interval_timer
    interval: 1000
    repeat: true
    onTriggered: {
      eyetimer.timer_tick();
    }
  }

  function start() {
  }
}
