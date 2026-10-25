#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QIcon>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Fusion");

    app.setWindowIcon(QIcon("qrc:/icon.png"));

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QMLStudy", "Main");

    return QGuiApplication::exec();
}