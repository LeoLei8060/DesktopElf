#include "SpriteController.h"
#include <QDebug>
#include <QEasingCurve>

SpriteController::SpriteController(QObject *parent)
    : QObject(parent)
    , m_targetPosition(960, 540) // Default to screen center
    , m_position(100, 100)
    , m_isAnimating(false)
    , m_currentFrameIndex(0)
    , m_frameDuration(500)
    , m_frameTimer(new QTimer(this))
    , m_positionAnimation(new QPropertyAnimation(this, "position", this))
{
    // Setup frame timer
    m_frameTimer->setSingleShot(false);
    connect(m_frameTimer, &QTimer::timeout, this, &SpriteController::onAnimationFrameChanged);

    // Setup position animation
    m_positionAnimation->setDuration(2000); // 2 seconds for movement
    m_positionAnimation->setEasingCurve(QEasingCurve::InOutQuad);
    connect(m_positionAnimation, &QPropertyAnimation::finished, this, &SpriteController::onMoveAnimationFinished);

    // Set default image path
    m_defaultImagePath = "qrc:/resources/images/default.gif";
    m_currentImagePath = m_defaultImagePath;
}

SpriteController::~SpriteController()
{
    stopAllAnimations();
}

QString SpriteController::currentImagePath() const
{
    return m_currentImagePath;
}

QPoint SpriteController::position() const
{
    return m_position;
}

bool SpriteController::isAnimating() const
{
    return m_isAnimating;
}

void SpriteController::setPosition(const QPoint &position)
{
    if (m_position != position) {
        m_position = position;
        emit positionChanged();
    }
}

void SpriteController::startIdleAnimation()
{
    stopAllAnimations();
    
    m_currentImagePath = m_defaultImagePath;
    emit currentImagePathChanged();
    
    qDebug() << "Started idle animation with image:" << m_currentImagePath;
}

void SpriteController::startMoveAnimation()
{
    if (m_moveAnimationPaths.isEmpty()) {
        qWarning() << "No move animation paths configured";
        return;
    }

    stopAllAnimations();
    startFrameAnimation(m_moveAnimationPaths, 1000); // 1 second total duration
    
    qDebug() << "Started move animation with" << m_moveAnimationPaths.size() << "frames";
}

void SpriteController::startJumpAnimation()
{
    if (m_jumpAnimationPaths.isEmpty()) {
        qWarning() << "No jump animation paths configured";
        return;
    }

    stopAllAnimations();
    startFrameAnimation(m_jumpAnimationPaths, 1000); // 1 second total duration
    
    qDebug() << "Started jump animation with" << m_jumpAnimationPaths.size() << "frames";
}

void SpriteController::moveToTarget()
{
    if (m_position == m_targetPosition) {
        qDebug() << "Already at target position";
        return;
    }

    // Start move animation first
    startMoveAnimation();
    
    // Start position animation
    m_positionAnimation->setStartValue(m_position);
    m_positionAnimation->setEndValue(m_targetPosition);
    m_positionAnimation->start();
    
    qDebug() << "Moving from" << m_position << "to" << m_targetPosition;
}

void SpriteController::moveToPosition(const QPoint &position)
{
    if (m_position == position) {
        qDebug() << "Already at target position";
        return;
    }

    // Start move animation first
    startMoveAnimation();
    
    // Start position animation
    m_positionAnimation->setStartValue(m_position);
    m_positionAnimation->setEndValue(position);
    m_positionAnimation->start();
    
    qDebug() << "Moving from" << m_position << "to" << position;
}

void SpriteController::stopAllAnimations()
{
    m_frameTimer->stop();
    m_positionAnimation->stop();
    
    if (m_isAnimating) {
        m_isAnimating = false;
        emit isAnimatingChanged();
    }
}

void SpriteController::setDefaultImagePath(const QString &path)
{
    m_defaultImagePath = path;
    if (!m_isAnimating) {
        m_currentImagePath = m_defaultImagePath;
        emit currentImagePathChanged();
    }
}

void SpriteController::setMoveAnimationPaths(const QStringList &paths)
{
    m_moveAnimationPaths = paths;
    qDebug() << "Set move animation paths:" << paths;
}

void SpriteController::setJumpAnimationPaths(const QStringList &paths)
{
    m_jumpAnimationPaths = paths;
    qDebug() << "Set jump animation paths:" << paths;
}

void SpriteController::setTargetPosition(const QPoint &target)
{
    m_targetPosition = target;
    qDebug() << "Set target position to:" << target;
}

void SpriteController::onAnimationFrameChanged()
{
    updateCurrentFrame();
}

void SpriteController::onMoveAnimationFinished()
{
    qDebug() << "Move animation finished";
    emit moveAnimationFinished();
    startIdleAnimation(); // Return to idle state
}

void SpriteController::onJumpAnimationFinished()
{
    qDebug() << "Jump animation finished";
    emit jumpAnimationFinished();
    startIdleAnimation(); // Return to idle state
}

void SpriteController::updateCurrentFrame()
{
    if (m_currentFrames.isEmpty()) {
        return;
    }

    m_currentImagePath = m_currentFrames[m_currentFrameIndex];
    emit currentImagePathChanged();

    m_currentFrameIndex = (m_currentFrameIndex + 1) % m_currentFrames.size();

    // If we've completed one full cycle, stop the animation
    if (m_currentFrameIndex == 0) {
        m_frameTimer->stop();
        m_isAnimating = false;
        emit isAnimatingChanged();
        emit animationFinished();
        
        // Determine which animation finished
        if (m_currentFrames == m_moveAnimationPaths) {
            onMoveAnimationFinished();
        } else if (m_currentFrames == m_jumpAnimationPaths) {
            onJumpAnimationFinished();
        }
    }
}

void SpriteController::startFrameAnimation(const QStringList &framePaths, int duration)
{
    if (framePaths.isEmpty()) {
        return;
    }

    m_currentFrames = framePaths;
    m_currentFrameIndex = 0;
    m_frameDuration = duration / framePaths.size(); // Divide total duration by frame count

    m_isAnimating = true;
    emit isAnimatingChanged();

    // Start with first frame
    m_currentImagePath = m_currentFrames[0];
    emit currentImagePathChanged();

    // Start frame timer
    m_frameTimer->setInterval(m_frameDuration);
    m_frameTimer->start();
}