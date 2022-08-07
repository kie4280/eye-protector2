#include "eyetimer.h"
#include <QDebug>


EyeTimer::EyeTimer(QObject *parent)
    : QObject{parent}
{

}


void EyeTimer::echo() {


}

void EyeTimer::tick(int s) {
  qDebug() << std::to_string(s).c_str();

}
