#ifndef CONFIGMANAGER_H
#define CONFIGMANAGER_H

#include <QObject>
#include <QPoint>
#include <QColor>
#include <QStringList>
#include <QJsonObject>
#include <QJsonDocument>

struct SpriteConfig {
    QString defaultImagePath;
    QStringList moveAnimationPaths;
    QStringList jumpAnimationPaths;
    QPoint targetPosition;
    QColor backgroundColor;
    int backgroundOpacity;
    QColor fontColor;
    bool stayOnTop;

    // Default constructor
    SpriteConfig() 
        : defaultImagePath("qrc:/resources/images/default.gif")
        , targetPosition(960, 540)
        , backgroundColor(Qt::white)
        , backgroundOpacity(80)
        , fontColor(Qt::black)
        , stayOnTop(true)
    {
        moveAnimationPaths << "qrc:/resources/images/move/move1.png" 
                          << "qrc:/resources/images/move/move2.png";
        jumpAnimationPaths << "qrc:/resources/images/jump/jump1.png" 
                          << "qrc:/resources/images/jump/jump2.png";
    }
};

class ConfigManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString defaultImagePath READ defaultImagePath WRITE setDefaultImagePath NOTIFY configChanged)
    Q_PROPERTY(QStringList moveAnimationPaths READ moveAnimationPaths WRITE setMoveAnimationPaths NOTIFY configChanged)
    Q_PROPERTY(QStringList jumpAnimationPaths READ jumpAnimationPaths WRITE setJumpAnimationPaths NOTIFY configChanged)
    Q_PROPERTY(QPoint targetPosition READ targetPosition WRITE setTargetPosition NOTIFY configChanged)
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY configChanged)
    Q_PROPERTY(int backgroundOpacity READ backgroundOpacity WRITE setBackgroundOpacity NOTIFY configChanged)
    Q_PROPERTY(QColor fontColor READ fontColor WRITE setFontColor NOTIFY configChanged)
    Q_PROPERTY(bool stayOnTop READ stayOnTop WRITE setStayOnTop NOTIFY configChanged)

public:
    explicit ConfigManager(QObject *parent = nullptr);
    ~ConfigManager();

    // Getters
    QString defaultImagePath() const;
    QStringList moveAnimationPaths() const;
    QStringList jumpAnimationPaths() const;
    QPoint targetPosition() const;
    QColor backgroundColor() const;
    int backgroundOpacity() const;
    QColor fontColor() const;
    bool stayOnTop() const;
    
    // Alias methods for compatibility
    QString spriteImagePath() const { return defaultImagePath(); }
    QStringList moveAnimationPath() const { return moveAnimationPaths(); }
    QStringList jumpAnimationPath() const { return jumpAnimationPaths(); }
    QPoint position() const { return targetPosition(); }

    // Property setters
    void setDefaultImagePath(const QString &path);
    void setMoveAnimationPaths(const QStringList &paths);
    void setJumpAnimationPaths(const QStringList &paths);
    void setTargetPosition(const QPoint &position);
    void setBackgroundColor(const QColor &color);
    void setBackgroundOpacity(int opacity);
    void setFontColor(const QColor &color);
    void setStayOnTop(bool stayOnTop);

    // Get complete config
    SpriteConfig getConfig() const;

public slots:
    void saveConfig();
    void loadConfig();
    void resetToDefaults();
    
    // QML-friendly methods
    Q_INVOKABLE void saveConfigToFile();
    Q_INVOKABLE void loadConfigFromFile();
    Q_INVOKABLE void selectImageFile();
    Q_INVOKABLE void selectMoveAnimationFiles();
    Q_INVOKABLE void selectJumpAnimationFiles();

signals:
    void configChanged();
    void configLoaded();
    void configSaved();
    
    // Specific property change signals
    void spriteImagePathChanged(const QString &path);
    void moveAnimationPathChanged(const QStringList &paths);
    void jumpAnimationPathChanged(const QStringList &paths);
    void positionChanged(const QPoint &position);

private:
    QString getConfigFilePath() const;
    QJsonObject configToJson() const;
    void configFromJson(const QJsonObject &json);

    SpriteConfig m_config;
    QString m_configFilePath;
};

#endif // CONFIGMANAGER_H