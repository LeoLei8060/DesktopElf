#ifndef SPRITECONTROLLER_H
#define SPRITECONTROLLER_H

#include <QObject>
#include <QPoint>
#include <QTimer>
#include <QStringList>
#include <QPropertyAnimation>
#include <QSequentialAnimationGroup>

class SpriteController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentImagePath READ currentImagePath NOTIFY currentImagePathChanged)
    Q_PROPERTY(QPoint position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(bool isAnimating READ isAnimating NOTIFY isAnimatingChanged)

public:
    explicit SpriteController(QObject *parent = nullptr);
    ~SpriteController();

    // Property getters
    QString currentImagePath() const;
    QPoint position() const;
    bool isAnimating() const;

    // Property setters
    void setPosition(const QPoint &position);

public slots:
    // Animation control
    void startIdleAnimation();
    void startMoveAnimation();
    void startJumpAnimation();
    void moveToTarget();
    void stopAllAnimations();
    
    // Movement
    void moveToPosition(const QPoint &position);

    // Configuration
    void setDefaultImagePath(const QString &path);
    void setMoveAnimationPaths(const QStringList &paths);
    void setJumpAnimationPaths(const QStringList &paths);
    void setTargetPosition(const QPoint &target);
    
    // Alias methods for compatibility
    void setMoveAnimationPath(const QStringList &paths) { setMoveAnimationPaths(paths); }
    void setJumpAnimationPath(const QStringList &paths) { setJumpAnimationPaths(paths); }

signals:
    void currentImagePathChanged();
    void positionChanged();
    void isAnimatingChanged();
    void animationFinished();
    void moveAnimationFinished();
    void jumpAnimationFinished();

private slots:
    void onAnimationFrameChanged();
    void onMoveAnimationFinished();
    void onJumpAnimationFinished();

private:
    void updateCurrentFrame();
    void startFrameAnimation(const QStringList &framePaths, int duration);

    QString m_defaultImagePath;
    QStringList m_moveAnimationPaths;
    QStringList m_jumpAnimationPaths;
    QPoint m_targetPosition;
    QPoint m_position;
    QString m_currentImagePath;
    bool m_isAnimating;

    // Animation management
    QTimer *m_frameTimer;
    QStringList m_currentFrames;
    int m_currentFrameIndex;
    int m_frameDuration;

    // Position animation
    QPropertyAnimation *m_positionAnimation;
};

#endif // SPRITECONTROLLER_H