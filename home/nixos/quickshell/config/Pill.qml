import QtQuick
import QtQuick.Layouts

Rectangle {
    property alias spacing: layout.spacing
    default property alias content: layout.data

    color: Colors.base01
    radius: 99
    implicitWidth: layout.implicitWidth + spacing * 4
    implicitHeight: layout.implicitHeight + 20
    clip: true

    RowLayout {
        id: layout
        anchors.centerIn: parent
    }
}
