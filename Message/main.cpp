#include "Client.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<Client>("com.myapp", 1, 0, "Client");

    QQmlApplicationEngine engine;

    Client client;
    engine.rootContext()->setContextProperty("client", &client);

    const QUrl url(u"qrc:/Message/Main.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
