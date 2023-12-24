#include "Client.h"
#include <QHostAddress>
#include <QDataStream>
#include <QTcpSocket>
#include <QJsonObject>
#include <QJsonDocument>

Client::Client(QObject *parent) : QObject(parent), m_socket(nullptr), m_connected(false)
{
}

void Client::connectToServer(const QString& ipAddress, quint16 port)
{
    if (!m_socket) {
        m_socket = new QTcpSocket(this);
        connect(m_socket, &QTcpSocket::connected, this, &Client::onSocketConnected);
        connect(m_socket, &QTcpSocket::disconnected, this, &Client::onSocketDisconnected);
        connect(m_socket, &QTcpSocket::readyRead, this, &Client::onSocketReadyRead);

        QHostAddress address(ipAddress);
        m_socket->connectToHost(address, port);
    }
}

void Client::sendMessage(const QString &username, const QString &message) {

    QJsonObject json;
    json["username"] = username;
    json["message"] = message;
    QJsonDocument document(json);

    m_socket->write(document.toJson(QJsonDocument::Compact));
    m_socket->flush();
}


void Client::disconnectFromServer()
{
    if (m_socket) {
        m_socket->disconnectFromHost();
    }
}

void Client::onSocketConnected()
{
    m_connected = true;
    emit connectedChanged(true);
}

void Client::onSocketDisconnected()
{
    m_connected = false;
    emit connectedChanged(false);
}

void Client::onSocketReadyRead()
{
    QString message = QString::fromUtf8(m_socket->readAll());
    emit messageReceived(message);
}
