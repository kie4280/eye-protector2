#include <QApplication>
#include <QQmlApplicationEngine>
#include <KNotifications/knotification.h>
#include <QQmlContext>
#include "eyetimer.h"
#include <QQuickView>

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
  Timer timer(5, 3);
  //    QQuickView *mainwindow = new QQuickView;
  qmlRegisterUncreatableType<Timer>("TickTimer", 1, 0, "Ticktimer", "single");
  //    mainwindow->rootContext()->setContextProperty("ticktimer", &timer);
  //    mainwindow->setSource(QStringLiteral("qrc:/Main.qml"));
  engine.rootContext()->setContextProperty("ticktimer", &timer);
  engine.load(QStringLiteral("qrc:/TrayIcon.qml"));

  engine.load(QStringLiteral("qrc:/Main.qml"));

//  QObject *trayicon = engine.rootObjects()[0];


  return app.exec();
}
