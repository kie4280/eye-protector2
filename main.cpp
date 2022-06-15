#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <KNotifications/knotification.h>
#include <QStandardPaths>
#include <iostream>


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

    KNotification *notification = new KNotification("notification");
    notification->setText("jdfghj");
    notification->setComponentName("eye-protector");
    notification->setUrgency(KNotification::HighUrgency);
    notification->setAutoDelete(true);

    std::cout << QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation).toStdString() << std::endl;

    notification->sendEvent();


    engine.load(url);

    return app.exec();
}
