#ifndef TIMER_H
#define TIMER_H

#include <QJsonDocument>
#include <QJsonObject>
#include <QObject>
#include <QQmlEngine>
#include <QTimer>

class EyeTimer : public QObject {

  Q_OBJECT
  QML_UNCREATABLE("singleton")
  Q_PROPERTY(int rest_time MEMBER rest_time NOTIFY rest_timeChanged)
  Q_PROPERTY(int work_time MEMBER work_time NOTIFY work_timeChanged)
  Q_PROPERTY(int timer_state MEMBER state NOTIFY timer_stateChanged)

public:
  enum TIMER_STATE { Pause, Ticking, Timeout };

  Q_ENUM(TIMER_STATE)

public:
  QTimer *tick_timer;
  EyeTimer(int duration = 20 * 60, int resting = 5 * 60);
  ~EyeTimer();

  int get_rest_time() const;
  void set_rest_time(int);
  int get_work_time() const;
  void set_work_time(int);

public slots:
  void pause();
  void start();
  void read_json();
  void save_json(QJsonObject);

private slots:
  void eyetimer_tick();

signals:
  void tick(int seconds);
  void warnClose(int seconds);
  void rest_timeChanged();
  void work_timeChanged();
  void timer_stateChanged();

private:
  int internal_counter = 0;
  int state = TIMER_STATE::Pause;
  int work_time, rest_time;
  QJsonDocument settings_json;
};

#endif // TIMER_H
