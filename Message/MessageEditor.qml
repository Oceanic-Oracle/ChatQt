import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "lightgrey"
    height: 60

    signal newMessage(string msg)

    RowLayout {
        id: layoutField
        anchors.fill: parent
        anchors.margins: 10

        CustomTextField {
            id: textfield
            placeholderText: "Введите сообщение"
        }

        Button {
            Layout.alignment: Qt.AlignVCenter
            text: ">"
            onClicked: {
                newMessage(textfield.text)
                textfield.clear()
            }
        }
    }
}
