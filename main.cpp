#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <KNotifications/knotification.h>
#include <QStandardPaths>
#include <iostream>
#include <QQmlContext>
#include "timer.h"
#include "eyetimer.h"
#include <QQuickView>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    Timer timer(5, 3);
    QQmlContext *rootContext = engine.rootContext();
    rootContext->setContextProperty("ticktimer", &timer);
    qmlRegisterUncreatableType<Timer>("TickTimer", 1, 0, "Ticktimer", "ENUM");
    engine.load(url);

//    KNotification *notification = new KNotification("notification");
//    notification->setText("jdfghj");
//    notification->setComponentName("eye-protector");
//    notification->setUrgency(KNotification::HighUrgency);
//    notification->setAutoDelete(true);

//    std::cout << QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation).toStdString() << std::endl;

//    notification->sendEvent();



    EyeTimer t;
    QObject::connect(&timer, &Timer::tick, &t, &EyeTimer::tick);


    return app.exec();
}
