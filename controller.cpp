#include "controller.h"
#include <QDebug>

Controller::Controller(QObject *parent)  : QObject{parent}{

}


void Controller::trayIconChanged(int state) {


}

void Controller::timerChanged(int state) {
  qDebug() << state;
}
