#include "extension.h"
#include "eyetimer.h"

void EyeProtectorPlugin::registerTypes(const char *uri) {
  Q_ASSERT(QLatin1String(uri) ==
           QLatin1String("com.github.kie4280.eyeprotector2.plugin"));

  qmlRegisterType<EyeTimer>(uri, 1, 0, "Eyetimer");
}
