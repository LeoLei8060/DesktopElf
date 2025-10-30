#include "ConfigManager.h"
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QJsonArray>
#include <QFileDialog>
#include <QDebug>
#include <QCoreApplication>

ConfigManager::ConfigManager(QObject *parent)
    : QObject(parent)
{
    // Set config file path
    QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(appDataPath);
    m_configFilePath = appDataPath + "/settings.json";
    
    // Load existing config or create default
    loadConfig();
}

ConfigManager::~ConfigManager()
{
    saveConfig();
}

QString ConfigManager::defaultImagePath() const
{
    return m_config.defaultImagePath;
}

QStringList ConfigManager::moveAnimationPaths() const
{
    return m_config.moveAnimationPaths;
}

QStringList ConfigManager::jumpAnimationPaths() const
{
    return m_config.jumpAnimationPaths;
}

QPoint ConfigManager::targetPosition() const
{
    return m_config.targetPosition;
}

QColor ConfigManager::backgroundColor() const
{
    return m_config.backgroundColor;
}

int ConfigManager::backgroundOpacity() const
{
    return m_config.backgroundOpacity;
}

QColor ConfigManager::fontColor() const
{
    return m_config.fontColor;
}

bool ConfigManager::stayOnTop() const
{
    return m_config.stayOnTop;
}

void ConfigManager::setDefaultImagePath(const QString &path)
{
    if (m_config.defaultImagePath != path) {
        m_config.defaultImagePath = path;
        emit configChanged();
        emit spriteImagePathChanged(path);
    }
}

void ConfigManager::setMoveAnimationPaths(const QStringList &paths)
{
    if (m_config.moveAnimationPaths != paths) {
        m_config.moveAnimationPaths = paths;
        emit configChanged();
        emit moveAnimationPathChanged(paths);
    }
}

void ConfigManager::setJumpAnimationPaths(const QStringList &paths)
{
    if (m_config.jumpAnimationPaths != paths) {
        m_config.jumpAnimationPaths = paths;
        emit configChanged();
        emit jumpAnimationPathChanged(paths);
    }
}

void ConfigManager::setTargetPosition(const QPoint &position)
{
    if (m_config.targetPosition != position) {
        m_config.targetPosition = position;
        emit configChanged();
        emit positionChanged(position);
    }
}

void ConfigManager::setBackgroundColor(const QColor &color)
{
    if (m_config.backgroundColor != color) {
        m_config.backgroundColor = color;
        emit configChanged();
    }
}

void ConfigManager::setBackgroundOpacity(int opacity)
{
    if (m_config.backgroundOpacity != opacity) {
        m_config.backgroundOpacity = opacity;
        emit configChanged();
    }
}

void ConfigManager::setFontColor(const QColor &color)
{
    if (m_config.fontColor != color) {
        m_config.fontColor = color;
        emit configChanged();
    }
}

void ConfigManager::setStayOnTop(bool stayOnTop)
{
    if (m_config.stayOnTop != stayOnTop) {
        m_config.stayOnTop = stayOnTop;
        emit configChanged();
    }
}

SpriteConfig ConfigManager::getConfig() const
{
    return m_config;
}

void ConfigManager::saveConfig()
{
    QJsonObject json = configToJson();
    QJsonDocument doc(json);
    
    QFile file(m_configFilePath);
    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson());
        file.close();
        emit configSaved();
        qDebug() << "Config saved to:" << m_configFilePath;
    } else {
        qWarning() << "Failed to save config to:" << m_configFilePath;
    }
}

void ConfigManager::loadConfig()
{
    QFile file(m_configFilePath);
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();
        
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull() && doc.isObject()) {
            configFromJson(doc.object());
            emit configLoaded();
            qDebug() << "Config loaded from:" << m_configFilePath;
        } else {
            qWarning() << "Invalid config file format";
            resetToDefaults();
        }
    } else {
        qDebug() << "Config file not found, using defaults";
        resetToDefaults();
    }
}

void ConfigManager::resetToDefaults()
{
    m_config = SpriteConfig(); // Use default constructor
    emit configChanged();
    saveConfig();
}

void ConfigManager::saveConfigToFile()
{
    saveConfig();
}

void ConfigManager::loadConfigFromFile()
{
    loadConfig();
}

void ConfigManager::selectImageFile()
{
    QString fileName = QFileDialog::getOpenFileName(
        nullptr,
        tr("Select Sprite Image"),
        "",
        tr("Image Files (*.png *.jpg *.jpeg *.gif *.bmp)")
    );
    
    if (!fileName.isEmpty()) {
        setDefaultImagePath(fileName);
    }
}

void ConfigManager::selectMoveAnimationFiles()
{
    QStringList fileNames = QFileDialog::getOpenFileNames(
        nullptr,
        tr("Select Move Animation Images"),
        "",
        tr("Image Files (*.png *.jpg *.jpeg *.bmp)")
    );
    
    if (!fileNames.isEmpty()) {
        setMoveAnimationPaths(fileNames);
    }
}

void ConfigManager::selectJumpAnimationFiles()
{
    QStringList fileNames = QFileDialog::getOpenFileNames(
        nullptr,
        tr("Select Jump Animation Images"),
        "",
        tr("Image Files (*.png *.jpg *.jpeg *.bmp)")
    );
    
    if (!fileNames.isEmpty()) {
        setJumpAnimationPaths(fileNames);
    }
}

QString ConfigManager::getConfigFilePath() const
{
    return m_configFilePath;
}

QJsonObject ConfigManager::configToJson() const
{
    QJsonObject json;
    json["version"] = "1.0";
    
    QJsonObject sprite;
    sprite["defaultImagePath"] = m_config.defaultImagePath;
    sprite["moveAnimationPaths"] = QJsonArray::fromStringList(m_config.moveAnimationPaths);
    sprite["jumpAnimationPaths"] = QJsonArray::fromStringList(m_config.jumpAnimationPaths);
    
    QJsonObject targetPos;
    targetPos["x"] = m_config.targetPosition.x();
    targetPos["y"] = m_config.targetPosition.y();
    sprite["targetPosition"] = targetPos;
    
    json["sprite"] = sprite;
    
    QJsonObject ui;
    ui["backgroundColor"] = m_config.backgroundColor.name();
    ui["backgroundOpacity"] = m_config.backgroundOpacity;
    ui["fontColor"] = m_config.fontColor.name();
    ui["stayOnTop"] = m_config.stayOnTop;
    
    json["ui"] = ui;
    
    return json;
}

void ConfigManager::configFromJson(const QJsonObject &json)
{
    // Load sprite settings
    if (json.contains("sprite") && json["sprite"].isObject()) {
        QJsonObject sprite = json["sprite"].toObject();
        
        if (sprite.contains("defaultImagePath")) {
            m_config.defaultImagePath = sprite["defaultImagePath"].toString();
        }
        
        if (sprite.contains("moveAnimationPaths") && sprite["moveAnimationPaths"].isArray()) {
            QJsonArray array = sprite["moveAnimationPaths"].toArray();
            m_config.moveAnimationPaths.clear();
            for (const auto &value : array) {
                m_config.moveAnimationPaths.append(value.toString());
            }
        }
        
        if (sprite.contains("jumpAnimationPaths") && sprite["jumpAnimationPaths"].isArray()) {
            QJsonArray array = sprite["jumpAnimationPaths"].toArray();
            m_config.jumpAnimationPaths.clear();
            for (const auto &value : array) {
                m_config.jumpAnimationPaths.append(value.toString());
            }
        }
        
        if (sprite.contains("targetPosition") && sprite["targetPosition"].isObject()) {
            QJsonObject pos = sprite["targetPosition"].toObject();
            m_config.targetPosition = QPoint(pos["x"].toInt(), pos["y"].toInt());
        }
    }
    
    // Load UI settings
    if (json.contains("ui") && json["ui"].isObject()) {
        QJsonObject ui = json["ui"].toObject();
        
        if (ui.contains("backgroundColor")) {
            m_config.backgroundColor = QColor(ui["backgroundColor"].toString());
        }
        
        if (ui.contains("backgroundOpacity")) {
            m_config.backgroundOpacity = ui["backgroundOpacity"].toInt();
        }
        
        if (ui.contains("fontColor")) {
            m_config.fontColor = QColor(ui["fontColor"].toString());
        }
        
        if (ui.contains("stayOnTop")) {
            m_config.stayOnTop = ui["stayOnTop"].toBool();
        }
    }
    
    emit configChanged();
}