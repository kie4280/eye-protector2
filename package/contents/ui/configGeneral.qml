import QtQuick 2.0
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    id: page
  
    property alias cfg_work_time_sec: work_spin.value
    property alias cfg_rest_time_sec: rest_spin.value
    property alias cfg_postpone_time_sec: postpone_spin.value

    QQC2.SpinBox {
      id: work_spin
      Kirigami.FormData.label: i18n("Work time:")
    }
    QQC2.SpinBox {
      id: rest_spin
      Kirigami.FormData.label: i18n("Rest time:")
    }
    QQC2.SpinBox {
      id: postpone_spin
      Kirigami.FormData.label: i18n("Postpone time:")
    }
}

