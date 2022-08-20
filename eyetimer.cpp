#include "eyetimer.h"
#include <QCoreApplication>
#include <QDebug>
#include <QQuickView>


EyeTimer::EyeTimer(int duration, int resting):work_time(duration), rest_time(resting) {
  tick_timer = new QTimer();
  tick_timer->setTimerType(Qt::CoarseTimer);
  tick_timer->setInterval(1000);
  internal_counter = work_time;
  connect(tick_timer, &QTimer::timeout, this, &EyeTimer::qtimer_tick);

}

EyeTimer::~EyeTimer() {
  disconnect(tick_timer, &QTimer::timeout, this, &EyeTimer::qtimer_tick);
  tick_timer->stop();
  delete tick_timer;
}

void EyeTimer::pause() {
  state = TIMER_STATE::Pause;
  tick_timer->start();
  emit stateChanged(TIMER_STATE::Pause);
}

void EyeTimer::start() {
  state = TIMER_STATE::Ticking;
  if (!tick_timer->isActive()) tick_timer->start();
  qDebug("start");
  emit stateChanged(TIMER_STATE::Ticking);
}


void EyeTimer::qtimer_tick() {

  switch (state) {

    case TIMER_STATE::Pause:

      if (internal_counter == work_time) {
          tick_timer->stop();
        } else {
          ++internal_counter;
        }
      break;
    case TIMER_STATE::Ticking:
      --internal_counter;
      if (internal_counter <= 0) {
          state = TIMER_STATE::Timeout;
          internal_counter = rest_time;
          emit stateChanged(TIMER_STATE::Timeout);
        }
      if (internal_counter <= 10) {
          emit warnClose(internal_counter);
        }
      break;
    case TIMER_STATE::Timeout:
      --internal_counter;
      if (internal_counter <= 0) {
          state = TIMER_STATE::Pause;
          internal_counter = work_time;
          emit stateChanged(TIMER_STATE::Pause);
        }
      break;
    default:
      break;
    }
  emit tick(internal_counter);
}

QList<int> EyeTimer::getWorkRestTime() const {
  return {work_time, rest_time};
}




