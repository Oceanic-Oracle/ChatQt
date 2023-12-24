#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QTcpSocket>

class Client : public QObject
{
    Q_OBJECT
public:
    explicit Client(QObject *parent = nullptr);

public slots:
    void connectToServer(const QString& ipAddress, quint16 port);
    void sendMessage(const QString &username, const QString &message);
    void disconnectFromServer();

signals:
    void connectedChanged(bool connected);
    void messageReceived(const QString& message);

private slots:
    void onSocketConnected();
    void onSocketDisconnected();
    void onSocketReadyRead();

private:
    QTcpSocket* m_socket;
    bool m_connected;
};

#endif // CLIENT_H
