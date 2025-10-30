#ifndef TIMERMANAGER_H
#define TIMERMANAGER_H

#include <QObject>
#include <QTimer>
#include <QDateTime>

class TimerManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isHourlyTimerEnabled READ isHourlyTimerEnabled WRITE setHourlyTimerEnabled NOTIFY hourlyTimerEnabledChanged)
    Q_PROPERTY(QDateTime nextHourlyTrigger READ nextHourlyTrigger NOTIFY nextHourlyTriggerChanged)

public:
    explicit TimerManager(QObject *parent = nullptr);
    ~TimerManager();

    // Property getters
    bool isHourlyTimerEnabled() const;
    QDateTime nextHourlyTrigger() const;

    // Property setters
    void setHourlyTimerEnabled(bool enabled);
    
    // Alias method for compatibility
    bool enabled() const { return isHourlyTimerEnabled(); }

public slots:
    void startHourlyTimer();
    void stopHourlyTimer();
    void checkHourlyTrigger();
    
    // Alias method for compatibility
    void startTimer() { startHourlyTimer(); }

signals:
    void hourlyTimerEnabledChanged();
    void nextHourlyTriggerChanged();
    void hourlyTriggerActivated();

private slots:
    void onTimerTimeout();

private:
    void calculateNextHourlyTrigger();
    void updateTimer();

    bool m_isHourlyTimerEnabled;
    QDateTime m_nextHourlyTrigger;
    QTimer *m_timer;
};

#endif // TIMERMANAGER_H