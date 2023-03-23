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
  state = TIMER_STATE::Pause;
  tick_timer->start();
  emit timer_stateChanged();
}

void EyeTimer::start() {
  state = TIMER_STATE::Ticking;
  if (!tick_timer->isActive())
    tick_timer->start();
  emit timer_stateChanged();
}

void EyeTimer::read_json() {
  QFile readfile(QStringLiteral("eye-protector-conf.json"));
  if (!readfile.exists()) {
    qInfo("config file doesn't exist");
    QJsonObject ob;
    ob["rest_sec"] = 300;
    ob["use_sec"] = 1200;
    ob["postpone_sec"] = 300;
    settings_json.setObject(ob);
    return;
  } else if (!readfile.open(QIODevice::ReadOnly)) {
    qWarning("cannot read config file");
    return;
  }

  settings_json.fromJson(readfile.readAll());
}

void EyeTimer::save_json(QJsonObject obj) {
  QFile savefile(QStringLiteral("eye-protector-conf.json"));
  if (!savefile.open(QIODevice::WriteOnly)) {
    qWarning("Cannot save file");
    return;
  }
  savefile.write(QJsonDocument(obj).toJson());
}

void EyeTimer::eyetimer_tick() {

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
      emit timer_stateChanged();
    }
    if (internal_counter <= 20) {
      emit warnClose(internal_counter);
    }
    break;
  case TIMER_STATE::Timeout:
    --internal_counter;
    if (internal_counter <= 0) {
      state = TIMER_STATE::Pause;
      internal_counter = work_time;
      emit timer_stateChanged();
    }
    break;
  default:
    break;
  }
  emit tick(internal_counter);
}
