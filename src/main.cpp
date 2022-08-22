#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "eyetimer.h"
#include <QQuickView>


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
  QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
  QApplication app(argc, argv);
  QQmlApplicationEngine engine;
  EyeTimer timer(20 , 10);

//      QQuickView *mainwindow = new QQuickView(&engine, nullptr);
  qmlRegisterUncreatableType<EyeTimer>("my.ticktimer", 1, 0, "Ticktimer", "single");

//      mainwindow->rootContext()->setContextProperty("ticktimer", &timer);
//      mainwindow->setSource(QStringLiteral("qrc:/Main.qml"));
//      mainwindow->show();
  engine.rootContext()->setContextProperty("ticktimer", &timer);

  engine.load(QStringLiteral("qrc:/qml/Main.qml"));
  engine.load(QStringLiteral("qrc:/qml/Notification.qml"));

  //  QObject *trayicon = engine.rootObjects()[0];


  return app.exec();
}
