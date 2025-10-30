#include "TimerManager.h"
#include <QDebug>

TimerManager::TimerManager(QObject *parent)
    : QObject(parent)
    , m_isHourlyTimerEnabled(true)
    , m_timer(new QTimer(this))
{
    // Setup timer
    m_timer->setSingleShot(false);
    m_timer->setInterval(60000); // Check every minute
    connect(m_timer, &QTimer::timeout, this, &TimerManager::onTimerTimeout);

    // Calculate initial next trigger
    calculateNextHourlyTrigger();
    
    // Start timer by default
    startHourlyTimer();
}

TimerManager::~TimerManager()
{
    stopHourlyTimer();
}

bool TimerManager::isHourlyTimerEnabled() const
{
    return m_isHourlyTimerEnabled;
}

QDateTime TimerManager::nextHourlyTrigger() const
{
    return m_nextHourlyTrigger;
}

void TimerManager::setHourlyTimerEnabled(bool enabled)
{
    if (m_isHourlyTimerEnabled != enabled) {
        m_isHourlyTimerEnabled = enabled;
        emit hourlyTimerEnabledChanged();
        
        if (enabled) {
            startHourlyTimer();
        } else {
            stopHourlyTimer();
        }
    }
}

void TimerManager::startHourlyTimer()
{
    if (!m_isHourlyTimerEnabled) {
        return;
    }

    calculateNextHourlyTrigger();
    m_timer->start();
    
    qDebug() << "Hourly timer started. Next trigger at:" << m_nextHourlyTrigger.toString();
}

void TimerManager::stopHourlyTimer()
{
    m_timer->stop();
    qDebug() << "Hourly timer stopped";
}

void TimerManager::checkHourlyTrigger()
{
    QDateTime currentTime = QDateTime::currentDateTime();
    
    // Check if we've reached or passed the trigger time
    if (currentTime >= m_nextHourlyTrigger) {
        qDebug() << "Hourly trigger activated at:" << currentTime.toString();
        emit hourlyTriggerActivated();
        
        // Calculate next trigger
        calculateNextHourlyTrigger();
    }
}

void TimerManager::onTimerTimeout()
{
    if (!m_isHourlyTimerEnabled) {
        return;
    }

    checkHourlyTrigger();
}

void TimerManager::calculateNextHourlyTrigger()
{
    QDateTime currentTime = QDateTime::currentDateTime();
    
    // Get the next hour on the hour (e.g., if it's 14:35, next trigger is 15:00)
    QDateTime nextHour = currentTime;
    nextHour = nextHour.addSecs(3600 - (currentTime.time().minute() * 60 + currentTime.time().second()));
    nextHour = QDateTime(nextHour.date(), QTime(nextHour.time().hour(), 0, 0));
    
    // If we're already at the exact hour, move to next hour
    if (nextHour <= currentTime) {
        nextHour = nextHour.addSecs(3600);
    }
    
    m_nextHourlyTrigger = nextHour;
    emit nextHourlyTriggerChanged();
    
    qDebug() << "Next hourly trigger calculated:" << m_nextHourlyTrigger.toString();
}

void TimerManager::updateTimer()
{
    if (m_isHourlyTimerEnabled && !m_timer->isActive()) {
        startHourlyTimer();
    } else if (!m_isHourlyTimerEnabled && m_timer->isActive()) {
        stopHourlyTimer();
    }
}