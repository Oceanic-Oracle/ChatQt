import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts



ApplicationWindow {
    id: root
    width: 480
    height: 620
    minimumHeight: 620
    minimumWidth: 480
    visible: true
    title: qsTr("Chat")

    Connections {
        target: client

        onMessageReceived: {
            var temp = 0;
            var actualMessage = "";
            var username = "";

            for (var i = 0; i < message.length; i++) {
                var c = message.charAt(i);

                if (c === '"') {
                    temp++;
                } else if (temp === 3) {
                    actualMessage += c;
                } else if (temp === 7) {
                    username += c;
                }
            }

            textModel.append({
                textMsg: actualMessage,
                usernameMsg: username,
                timeMsg: Qt.formatTime(new Date(), "hh:mm")
            });
        }
    }

    StackView {
        id: view
        anchors.fill: parent
        initialItem: pageUser
    }

    CustomPage {
        id: pageUser

        header: ToolBar {
            height: 50
            Text {
                text: "Главная страница"
                anchors.centerIn: parent
                font.pointSize: Math.min(root.height, root.width) / 60
            }
        }

        anchors.fill: parent
        Rectangle {
            radius: 30
            width: 1000
            height: parent.height
            anchors.centerIn: parent
            ColumnLayout {
                id: general
                anchors.centerIn: parent

                Label {
                    id: titleWelcome
                    text: "ChatSphere"
                    font.pointSize: Math.min(root.height, root.width) / 10
                    font.bold: true
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                }

                Rectangle {
                    width: 300
                    height: 40
                    radius: 20

                    anchors.left: parent.left
                    anchors.right: parent.right

                    border.color: "black"
                    color: "white"

                    TextField {
                        id: textFieldUsername

                        placeholderText: "Введите имя..."

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

                CustomButton {
                    id: customButton
                    anchors.horizontalCenter: titleWelcome.horizontalCenter
                    buttonText: "Войти"
                    onClicked: {
                        if (textFieldUsername.text !== "") {
                            client.connectToServer("127.0.0.1", 1234)
                            view.push(chatUser)
                        }
                    }
                }
            }
        }

        Label {
            text: "Приложение сделано Хабибуллиным Русланом"
            anchors.bottom: parent.bottom
        }
    }


    CustomPage {
        id: chatUser
        visible: false
        anchors.fill: parent

        header: ToolBar {
            height: 50
            ToolButton {
                text: "<"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    view.pop()
                }
            }

            Text {
                anchors.centerIn: parent
                text: "Вы вошли под именем " + textFieldUsername.text
                font.pointSize: Math.min(root.height, root.width) / 60
            }

            Text {
                anchors.centerIn: parent
                font.pointSize: Math.min(root.height, root.width) / 40
                text: view.currentItem.title
            }
        }

        footer: Rectangle {
            color: "lightgrey"
            height: 60

            RowLayout {
                id: layoutField
                anchors.centerIn: parent
                anchors.margins: 10

                Rectangle {
                    id: viewButton

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

                        placeholderText: "Введите сообщение..."

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
                CustomButton {
                    Layout.alignment: Qt.AlignVCenter
                    buttonText: "Отправить..."
                    onClicked: {
                        if (textField.text !== "") {
                            client.sendMessage(textFieldUsername.text, textField.text);
                            textModel.append({
                                usernameMsg: "Вы",
                                textMsg: textField.text,
                                timeMsg: Qt.formatTime(new Date(), "hh:mm")
                            })
                            textField.clear()
                        }
                    }
                }
            }
        }

        Rectangle {
            radius: 30
            width: 1000
            height: parent.height
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            ListView {
                id: messagesList
                anchors.fill: parent
                ScrollBar.vertical: ScrollBar {}
                model: textModel
                spacing: 10

                delegate: Rectangle{
                    height: 60
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 270
                    radius: 10
                    color: "lightgrey"

                    Text {
                        id: textMsg
                        anchors.top: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        text: model.textMsg
                    }

                    Text {
                        id: usernameMsg
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.margins: 8
                        text: model.usernameMsg
                    }

                    Text {
                        id: timeMsg
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 8
                        text: model.timeMsg
                    }
                }
            }

            ListModel {
                id: textModel

                ListElement {
                    textMsg: "Чат со всеми пользователями"
                    usernameMsg: "Admin"
                    timeMsg: "00:00"
                }
            }
        }
    }
}
