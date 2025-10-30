#ifndef FITNESSMANAGER_H
#define FITNESSMANAGER_H

#include <QObject>
#include <QDate>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

struct FitnessPlan {
    QString name;
    QString description;
    bool completed;
    QDateTime createdAt;

    FitnessPlan() : completed(false), createdAt(QDateTime::currentDateTime()) {}
    FitnessPlan(const QString &n, const QString &desc) 
        : name(n), description(desc), completed(false), createdAt(QDateTime::currentDateTime()) {}
};

class FitnessManager : public QObject
{
    Q_OBJECT

public:
    explicit FitnessManager(QObject *parent = nullptr);
    ~FitnessManager();

public slots:
    // Plan management
    Q_INVOKABLE void addPlan(const QDate &date, const QString &name, const QString &description = "");
    Q_INVOKABLE void removePlan(const QDate &date, const QString &name);
    Q_INVOKABLE void markCompleted(const QDate &date, const QString &name, bool completed);
    Q_INVOKABLE QVariantList getPlansForDate(const QDate &date);
    Q_INVOKABLE QVariantList getPlansForMonth(int year, int month);
    Q_INVOKABLE bool hasPlansForDate(const QDate &date);
    Q_INVOKABLE int getCompletedCount(const QDate &date);
    Q_INVOKABLE int getTotalCount(const QDate &date);

    // Data management
    Q_INVOKABLE void saveData();
    Q_INVOKABLE void loadData();
    Q_INVOKABLE void clearAllData();

signals:
    void planAdded(const QDate &date, const QString &name);
    void planRemoved(const QDate &date, const QString &name);
    void planCompleted(const QDate &date, const QString &name, bool completed);
    void dataLoaded();
    void dataSaved();

private:
    QString getDataFilePath() const;
    QJsonObject plansToJson() const;
    void plansFromJson(const QJsonObject &json);
    QVariantMap planToVariantMap(const FitnessPlan &plan) const;
    FitnessPlan planFromVariantMap(const QVariantMap &map) const;

    // Data storage: date string -> list of plans
    QMap<QString, QList<FitnessPlan>> m_plans;
    QString m_dataFilePath;
};

#endif // FITNESSMANAGER_H