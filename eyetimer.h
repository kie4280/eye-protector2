#ifndef TIMER_H
#define TIMER_H

#include <QTimer>
#include <QObject>
#include <QQmlEngine>



class Timer: public QObject
{

  Q_OBJECT
  QML_UNCREATABLE("singleton")

public:
  enum TIMER_STATE {
    Warn_close,
    Pause,
    Ticking,
    Timeout
  };

  Q_ENUM(TIMER_STATE)

public:

  QTimer *tick_timer;
  Timer(int duration = 20 * 60, int resting = 5 * 60);
  ~Timer();
  Q_INVOKABLE QList<int> getWorkRestTime() const;

public slots:
  void pause();
  void start();

private slots:
  void seconds();

signals:
  void tick(int);
  void stateChanged(int);

private:
  int internal_counter = 0;
  int state = TIMER_STATE::Pause;
  int work_time, rest_time;


};

#endif // TIMER_H
