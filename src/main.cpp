#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QSystemTrayIcon>
#include <QDebug>
#include <QScreen>
#include <QPoint>
#include <QTime>
#include <QRandomGenerator>

// Include controllers
#include "controllers/SpriteController.h"
#include "controllers/ConfigManager.h"
#include "controllers/TimerManager.h"
#include "controllers/FitnessManager.h"

int main(int argc, char *argv[])
{
    // Enable high DPI scaling
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);

    QApplication app(argc, argv);

    // Set application properties
    app.setApplicationName("DesktopElf");
    app.setApplicationVersion("1.0.0");
    app.setOrganizationName("DesktopElf");
    app.setOrganizationDomain("desktopelf.com");

    // Check if system tray is available
    if (!QSystemTrayIcon::isSystemTrayAvailable()) {
        qCritical() << "System tray is not available on this system.";
        return -1;
    }

    // Register QML types
    qmlRegisterType<SpriteController>("DesktopElf", 1, 0, "SpriteController");
    qmlRegisterType<ConfigManager>("DesktopElf", 1, 0, "ConfigManager");
    qmlRegisterType<TimerManager>("DesktopElf", 1, 0, "TimerManager");
    qmlRegisterType<FitnessManager>("DesktopElf", 1, 0, "FitnessManager");

    // Create controller instances
    SpriteController spriteController;
    ConfigManager configManager;
    TimerManager timerManager;
    FitnessManager fitnessManager;

    // Connect timer to sprite controller for hourly movement
    QObject::connect(&timerManager, &TimerManager::hourlyTriggerActivated, [&]() {
        // Generate random position for hourly movement
        int screenWidth = QApplication::primaryScreen()->geometry().width();
        int screenHeight = QApplication::primaryScreen()->geometry().height();
        
        int randomX = QRandomGenerator::global()->bounded(screenWidth - 150);
        int randomY = QRandomGenerator::global()->bounded(screenHeight - 150);
        
        QPoint randomPosition(randomX, randomY);
        spriteController.moveToPosition(randomPosition);
        
        qDebug() << "Hourly movement triggered, moving to:" << randomPosition;
    });

    // Connect config manager to sprite controller
    QObject::connect(&configManager, &ConfigManager::spriteImagePathChanged,
                     &spriteController, &SpriteController::setDefaultImagePath);
    QObject::connect(&configManager, &ConfigManager::moveAnimationPathChanged,
                     &spriteController, &SpriteController::setMoveAnimationPaths);
    QObject::connect(&configManager, &ConfigManager::jumpAnimationPathChanged,
                     &spriteController, &SpriteController::setJumpAnimationPaths);
    QObject::connect(&configManager, &ConfigManager::positionChanged,
                     &spriteController, &SpriteController::setPosition);

    // Load initial configuration
    configManager.loadConfig();
    
    // Initialize sprite controller with config values
    spriteController.setDefaultImagePath(configManager.defaultImagePath());
    spriteController.setMoveAnimationPaths(configManager.moveAnimationPaths());
    spriteController.setJumpAnimationPaths(configManager.jumpAnimationPaths());
    spriteController.setPosition(configManager.targetPosition());
    
    // Start timer manager if enabled
    if (timerManager.enabled()) {
        timerManager.startTimer();
    }

    // Create QML engine
    QQmlApplicationEngine engine;

    // Expose controllers to QML
    engine.rootContext()->setContextProperty("spriteController", &spriteController);
    engine.rootContext()->setContextProperty("configManager", &configManager);
    engine.rootContext()->setContextProperty("timerManager", &timerManager);
    engine.rootContext()->setContextProperty("fitnessManager", &fitnessManager);

    // Load main QML file
    const QUrl url(QStringLiteral("qrc:/src/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);

    engine.load(url);

    // Start the sprite controller with idle animation
    spriteController.startIdleAnimation();

    qDebug() << "DesktopElf application started successfully";

    return app.exec();
}