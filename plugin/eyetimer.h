#ifndef TIMER_H
#define TIMER_H

// #include <QJsonDocument>
#include <QObject>
#include <QQmlEngine>
#include <QTimer>

class EyeTimer : public QObject {

  Q_OBJECT

  Q_PROPERTY(int rest_time MEMBER rest_time WRITE set_rest_time NOTIFY
                 rest_timeChanged)
  Q_PROPERTY(int work_time MEMBER work_time WRITE set_work_time NOTIFY
                 work_timeChanged)
  Q_PROPERTY(int timer_state MEMBER timer_state NOTIFY timer_stateChanged)

  Q_PROPERTY(int counter_value READ get_internal_counter NOTIFY tick)

public:
  enum TIMER_STATE { Pause, Ticking, Recharging, Timeout };
  Q_ENUM(TIMER_STATE)

public:
  QTimer *tick_timer;
  EyeTimer(int duration = 10, int resting = 5);
  ~EyeTimer();
  void set_rest_time(int);
  void set_work_time(int);
  int get_internal_counter() const;

public slots:
  void toggle();
  void reset();

private slots:
  void eyetimer_tick();

signals:
  void tick();
  void warnClose(int seconds);
  void rest_timeChanged();
  void work_timeChanged();
  void timer_stateChanged();

private:
  int internal_counter = 0;
  int timer_state = TIMER_STATE::Pause;
  int work_time, rest_time;
  // QJsonDocument settings_json;
};

#endif // TIMER_H
