import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    property alias placeholderText: textField.placeholderText
    property alias textInField: textField.text

    id: root

    width: 300
    height: 40
    radius: 20

    border.color: "black"
    color: "white"

    TextField {
        id: textField

        anchors {
            fill: parent
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 5
        }

        width: parent.width
        height: parent.height

        selectByMouse: true

        verticalAlignment: Text.AlignVCenter

        background: Rectangle {
            color: "transparent"
            radius: 20
        }
    }
}
