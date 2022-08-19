#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "eyetimer.h"
#include <QQuickView>
#include "controller.h"

void kde_send_notification() {
  //    KNotification *notification = new KNotification("notification");
  //    notification->setText("jdfghj");
  //    notification->setComponentName("eye-protector");
  //    notification->setUrgency(KNotification::HighUrgency);
  //    notification->setAutoDelete(true);

  //    std::cout << QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation).toStdString() << std::endl;

  //    notification->sendEvent();


}



int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
  QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
  QApplication app(argc, argv);
  QQmlApplicationEngine engine;
  Timer timer(25 * 60, 5 * 60);
  Controller ctrl;
  //    QQuickView *mainwindow = new QQuickView;
  qmlRegisterUncreatableType<Timer>("my.ticktimer", 1, 0, "Ticktimer", "single");
  qmlRegisterUncreatableType<Controller>("my.controller", 1, 0, "StateCtrl", "single");
  //    mainwindow->rootContext()->setContextProperty("ticktimer", &timer);
  //    mainwindow->setSource(QStringLiteral("qrc:/Main.qml"));
  engine.rootContext()->setContextProperty("ticktimer", &timer);
  engine.rootContext()->setContextProperty("StateCtrl", &ctrl);
  engine.load(QStringLiteral("qrc:/Main.qml"));
  engine.load(QStringLiteral("qrc:/Notification.qml"));
  QObject::connect(&timer, &Timer::stateChanged, &ctrl, &Controller::timerChanged);
  //  QObject *trayicon = engine.rootObjects()[0];


  return app.exec();
}
