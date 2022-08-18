#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>

class Controller : public QObject
{
  Q_OBJECT
public:
  explicit Controller(QObject *parent = nullptr);

signals:

public slots:
  void trayIconChanged(int state);
  void timerChanged(int state);
private:

};

#endif // CONTROLLER_H
