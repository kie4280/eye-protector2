#ifndef QML_EXTENSION_H
#define QML_EXTENSION_H

#include <QQmlEngine>
#include <QQmlExtensionPlugin>

class EyeProtectorPlugin : public QQmlExtensionPlugin {
  Q_OBJECT
  Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
  void registerTypes(const char *uri) override;
};

#endif
