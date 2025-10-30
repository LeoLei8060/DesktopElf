#include "FitnessManager.h"
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QDebug>
#include <QVariantMap>
#include <QVariantList>

FitnessManager::FitnessManager(QObject *parent)
    : QObject(parent)
{
    // Set data file path
    QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(appDataPath);
    m_dataFilePath = appDataPath + "/fitness_data.json";
    
    // Load existing data
    loadData();
}

FitnessManager::~FitnessManager()
{
    saveData();
}

void FitnessManager::addPlan(const QDate &date, const QString &name, const QString &description)
{
    if (name.isEmpty()) {
        qWarning() << "Cannot add plan with empty name";
        return;
    }

    QString dateKey = date.toString(Qt::ISODate);
    FitnessPlan plan(name, description);
    
    m_plans[dateKey].append(plan);
    
    emit planAdded(date, name);
    qDebug() << "Added fitness plan:" << name << "for date:" << date.toString();
}

void FitnessManager::removePlan(const QDate &date, const QString &name)
{
    QString dateKey = date.toString(Qt::ISODate);
    
    if (!m_plans.contains(dateKey)) {
        return;
    }

    auto &planList = m_plans[dateKey];
    for (int i = 0; i < planList.size(); ++i) {
        if (planList[i].name == name) {
            planList.removeAt(i);
            emit planRemoved(date, name);
            qDebug() << "Removed fitness plan:" << name << "for date:" << date.toString();
            break;
        }
    }

    // Remove empty date entries
    if (planList.isEmpty()) {
        m_plans.remove(dateKey);
    }
}

void FitnessManager::markCompleted(const QDate &date, const QString &name, bool completed)
{
    QString dateKey = date.toString(Qt::ISODate);
    
    if (!m_plans.contains(dateKey)) {
        return;
    }

    auto &planList = m_plans[dateKey];
    for (auto &plan : planList) {
        if (plan.name == name) {
            plan.completed = completed;
            emit planCompleted(date, name, completed);
            qDebug() << "Marked plan" << name << "as" << (completed ? "completed" : "incomplete") 
                     << "for date:" << date.toString();
            break;
        }
    }
}

QVariantList FitnessManager::getPlansForDate(const QDate &date)
{
    QString dateKey = date.toString(Qt::ISODate);
    QVariantList result;
    
    if (m_plans.contains(dateKey)) {
        for (const auto &plan : m_plans[dateKey]) {
            result.append(planToVariantMap(plan));
        }
    }
    
    return result;
}

QVariantList FitnessManager::getPlansForMonth(int year, int month)
{
    QVariantList result;
    QDate startDate(year, month, 1);
    QDate endDate = startDate.addMonths(1).addDays(-1);
    
    for (QDate date = startDate; date <= endDate; date = date.addDays(1)) {
        QString dateKey = date.toString(Qt::ISODate);
        if (m_plans.contains(dateKey)) {
            QVariantMap dateEntry;
            dateEntry["date"] = date;
            
            QVariantList plans;
            for (const auto &plan : m_plans[dateKey]) {
                plans.append(planToVariantMap(plan));
            }
            dateEntry["plans"] = plans;
            
            result.append(dateEntry);
        }
    }
    
    return result;
}

bool FitnessManager::hasPlansForDate(const QDate &date)
{
    QString dateKey = date.toString(Qt::ISODate);
    return m_plans.contains(dateKey) && !m_plans[dateKey].isEmpty();
}

int FitnessManager::getCompletedCount(const QDate &date)
{
    QString dateKey = date.toString(Qt::ISODate);
    int count = 0;
    
    if (m_plans.contains(dateKey)) {
        for (const auto &plan : m_plans[dateKey]) {
            if (plan.completed) {
                count++;
            }
        }
    }
    
    return count;
}

int FitnessManager::getTotalCount(const QDate &date)
{
    QString dateKey = date.toString(Qt::ISODate);
    return m_plans.contains(dateKey) ? m_plans[dateKey].size() : 0;
}

void FitnessManager::saveData()
{
    QJsonObject json = plansToJson();
    QJsonDocument doc(json);
    
    QFile file(m_dataFilePath);
    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson());
        file.close();
        emit dataSaved();
        qDebug() << "Fitness data saved to:" << m_dataFilePath;
    } else {
        qWarning() << "Failed to save fitness data to:" << m_dataFilePath;
    }
}

void FitnessManager::loadData()
{
    QFile file(m_dataFilePath);
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();
        
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull() && doc.isObject()) {
            plansFromJson(doc.object());
            emit dataLoaded();
            qDebug() << "Fitness data loaded from:" << m_dataFilePath;
        } else {
            qWarning() << "Invalid fitness data file format";
        }
    } else {
        qDebug() << "Fitness data file not found, starting with empty data";
    }
}

void FitnessManager::clearAllData()
{
    m_plans.clear();
    saveData();
    qDebug() << "All fitness data cleared";
}

QString FitnessManager::getDataFilePath() const
{
    return m_dataFilePath;
}

QJsonObject FitnessManager::plansToJson() const
{
    QJsonObject json;
    json["version"] = "1.0";
    
    QJsonObject fitness;
    QJsonArray plansArray;
    
    for (auto it = m_plans.begin(); it != m_plans.end(); ++it) {
        QJsonObject dateEntry;
        dateEntry["date"] = it.key();
        
        QJsonArray plans;
        for (const auto &plan : it.value()) {
            QJsonObject planObj;
            planObj["name"] = plan.name;
            planObj["description"] = plan.description;
            planObj["completed"] = plan.completed;
            planObj["createdAt"] = plan.createdAt.toString(Qt::ISODate);
            plans.append(planObj);
        }
        dateEntry["plans"] = plans;
        
        plansArray.append(dateEntry);
    }
    
    fitness["plans"] = plansArray;
    json["fitness"] = fitness;
    
    return json;
}

void FitnessManager::plansFromJson(const QJsonObject &json)
{
    m_plans.clear();
    
    if (json.contains("fitness") && json["fitness"].isObject()) {
        QJsonObject fitness = json["fitness"].toObject();
        
        if (fitness.contains("plans") && fitness["plans"].isArray()) {
            QJsonArray plansArray = fitness["plans"].toArray();
            
            for (const auto &value : plansArray) {
                if (value.isObject()) {
                    QJsonObject dateEntry = value.toObject();
                    QString dateKey = dateEntry["date"].toString();
                    
                    if (dateEntry.contains("plans") && dateEntry["plans"].isArray()) {
                        QJsonArray plans = dateEntry["plans"].toArray();
                        QList<FitnessPlan> planList;
                        
                        for (const auto &planValue : plans) {
                            if (planValue.isObject()) {
                                QJsonObject planObj = planValue.toObject();
                                FitnessPlan plan;
                                plan.name = planObj["name"].toString();
                                plan.description = planObj["description"].toString();
                                plan.completed = planObj["completed"].toBool();
                                plan.createdAt = QDateTime::fromString(planObj["createdAt"].toString(), Qt::ISODate);
                                
                                planList.append(plan);
                            }
                        }
                        
                        if (!planList.isEmpty()) {
                            m_plans[dateKey] = planList;
                        }
                    }
                }
            }
        }
    }
}

QVariantMap FitnessManager::planToVariantMap(const FitnessPlan &plan) const
{
    QVariantMap map;
    map["name"] = plan.name;
    map["description"] = plan.description;
    map["completed"] = plan.completed;
    map["createdAt"] = plan.createdAt;
    return map;
}

FitnessPlan FitnessManager::planFromVariantMap(const QVariantMap &map) const
{
    FitnessPlan plan;
    plan.name = map["name"].toString();
    plan.description = map["description"].toString();
    plan.completed = map["completed"].toBool();
    plan.createdAt = map["createdAt"].toDateTime();
    return plan;
}