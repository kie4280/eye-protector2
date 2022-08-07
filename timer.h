#ifndef TIMER_H
#define TIMER_H

#include <QTimer>
#include <QObject>


enum TIMER_STATE {
  Initial,
  Pause,
  Ticking,
  Timeout
};

class Timer: public QObject
{

    Q_OBJECT
//    Q_PROPERTY(int seconds READ seconds WRITE setSeconds NOTIFY secondsChanged)
public:

    QTimer *tick_timer;
    Timer(int duration = 20 * 60, int resting = 5 * 60);
    ~Timer();
    void pause();
    void postpone();
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
