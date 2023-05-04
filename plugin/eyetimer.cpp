#include "eyetimer.h"
#include <QCoreApplication>
#include <QDebug>
#include <QFile>
#include <QQuickView>

EyeTimer::EyeTimer(int duration, int resting)
    : work_time(duration), rest_time(resting) {
  tick_timer = new QTimer();
  tick_timer->setTimerType(Qt::CoarseTimer);
  tick_timer->setInterval(1000);
  internal_counter = work_time;
  connect(tick_timer, &QTimer::timeout, this, &EyeTimer::eyetimer_tick);
}

EyeTimer::~EyeTimer() {
  disconnect(tick_timer, &QTimer::timeout, this, &EyeTimer::eyetimer_tick);
  tick_timer->stop();
  delete tick_timer;
}

void EyeTimer::pause() {
  timer_state = TIMER_STATE::Pause;
  tick_timer->start();
  emit timer_stateChanged();
}

void EyeTimer::start() {
  timer_state = TIMER_STATE::Ticking;
  if (!tick_timer->isActive())
    tick_timer->start();
  emit timer_stateChanged();
}

void EyeTimer::set_rest_time(int sec) {
  tick_timer->stop();
  rest_time = sec;
  tick_timer->start();
}

void EyeTimer::set_work_time(int sec) {
  tick_timer->stop();
  work_time = sec;
  tick_timer->start();
}

void EyeTimer::eyetimer_tick() {

  switch (timer_state) {

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
      timer_state = TIMER_STATE::Timeout;
      internal_counter = rest_time;
      emit timer_stateChanged();
    }
    if (internal_counter <= 20) {
      emit warnClose(internal_counter);
    }
    break;
  case TIMER_STATE::Timeout:
    --internal_counter;
    if (internal_counter <= 0) {
      timer_state = TIMER_STATE::Pause;
      internal_counter = work_time;
      emit timer_stateChanged();
    }
    break;
  default:
    break;
  }
  emit tick(internal_counter);
}