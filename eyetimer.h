#ifndef EYETIMER_H
#define EYETIMER_H

#include <QObject>

class EyeTimer : public QObject
{
    Q_OBJECT
public:
    explicit EyeTimer(QObject *parent = nullptr);

signals:


   public slots:
        void echo();
        void tick(int);

};

#endif // EYETIMER_H
