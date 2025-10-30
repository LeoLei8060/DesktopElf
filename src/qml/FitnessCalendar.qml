import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import DesktopElf 1.0

ApplicationWindow {
    id: fitnessWindow
    
    title: "健身计划日历"
    width: 800
    height: 600
    minimumWidth: 700
    minimumHeight: 500
    
    flags: Qt.Window | Qt.WindowCloseButtonHint | Qt.WindowMinimizeButtonHint
    modality: Qt.NonModal
    
    // Properties
    property date currentDate: new Date()
    property date selectedDate: new Date()
    property var monthNames: ["一月", "二月", "三月", "四月", "五月", "六月", 
                             "七月", "八月", "九月", "十月", "十一月", "十二月"]
    property var weekDays: ["日", "一", "二", "三", "四", "五", "六"]
    
    // Color scheme
    readonly property color primaryColor: "#4a90e2"
    readonly property color backgroundColor: "#f8f9fa"
    readonly property color cardColor: "#ffffff"
    readonly property color textColor: "#333333"
    readonly property color borderColor: "#e0e0e0"
    readonly property color completedColor: "#4caf50"
    readonly property color pendingColor: "#ff9800"
    
    background: Rectangle {
        color: backgroundColor
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "健身计划日历"
                font.pixelSize: 24
                font.bold: true
                color: textColor
            }
            
            Item {
                Layout.fillWidth: true
            }
            
            Button {
                text: "今天"
                onClicked: {
                    currentDate = new Date()
                    selectedDate = new Date()
                    updateCalendar()
                }
                
                background: Rectangle {
                    color: parent.pressed ? "#3a7bc8" : (parent.hovered ? "#5ba0f2" : primaryColor)
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        
        // Calendar Navigation
        RowLayout {
            Layout.fillWidth: true
            
            Button {
                text: "◀"
                onClicked: {
                    currentDate.setMonth(currentDate.getMonth() - 1)
                    currentDate = new Date(currentDate)
                    updateCalendar()
                }
                
                background: Rectangle {
                    color: parent.pressed ? "#3a7bc8" : (parent.hovered ? "#5ba0f2" : primaryColor)
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            
            Text {
                text: currentDate.getFullYear() + "年 " + monthNames[currentDate.getMonth()]
                font.pixelSize: 18
                font.bold: true
                color: textColor
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
            
            Button {
                text: "▶"
                onClicked: {
                    currentDate.setMonth(currentDate.getMonth() + 1)
                    currentDate = new Date(currentDate)
                    updateCalendar()
                }
                
                background: Rectangle {
                    color: parent.pressed ? "#3a7bc8" : (parent.hovered ? "#5ba0f2" : primaryColor)
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        
        // Calendar Grid
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: cardColor
            border.color: borderColor
            border.width: 1
            radius: 8
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 0
                
                // Week header
                GridLayout {
                    Layout.fillWidth: true
                    columns: 7
                    rowSpacing: 0
                    columnSpacing: 0
                    
                    Repeater {
                        model: weekDays
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            color: "#f0f0f0"
                            border.color: borderColor
                            border.width: 1
                            
                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                font.pixelSize: 12
                                font.bold: true
                                color: textColor
                            }
                        }
                    }
                }
                
                // Calendar days
                GridLayout {
                    id: calendarGrid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    columns: 7
                    rowSpacing: 0
                    columnSpacing: 0
                    
                    // Will be populated by updateCalendar()
                }
            }
        }
        
        // Selected Date Info
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: selectedDateColumn.implicitHeight + 40
            color: cardColor
            border.color: borderColor
            border.width: 1
            radius: 8
            
            ColumnLayout {
                id: selectedDateColumn
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                Text {
                    text: "选中日期：" + Qt.formatDate(selectedDate, "yyyy年MM月dd日")
                    font.pixelSize: 16
                    font.bold: true
                    color: primaryColor
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    
                    TextField {
                        id: newPlanField
                        Layout.fillWidth: true
                        placeholderText: "输入新的健身计划..."
                        
                        background: Rectangle {
                            color: "#f5f5f5"
                            border.color: borderColor
                            border.width: 1
                            radius: 4
                        }
                    }
                    
                    Button {
                        text: "添加计划"
                        enabled: newPlanField.text.trim() !== ""
                        
                        background: Rectangle {
                            color: parent.enabled ? 
                                   (parent.pressed ? "#3a7bc8" : (parent.hovered ? "#5ba0f2" : primaryColor)) :
                                   "#e0e0e0"
                            radius: 4
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: parent.enabled ? "white" : "#999999"
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            if (newPlanField.text.trim() !== "") {
                                var dateStr = Qt.formatDate(selectedDate, "yyyy-MM-dd")
                                fitnessManager.addPlan(dateStr, newPlanField.text.trim())
                                newPlanField.text = ""
                                updateSelectedDatePlans()
                                updateCalendar()
                            }
                        }
                    }
                }
                
                // Plans list
                ScrollView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150
                    
                    ListView {
                        id: plansListView
                        model: ListModel {
                            id: plansModel
                        }
                        
                        delegate: Rectangle {
                            width: plansListView.width
                            height: 40
                            color: index % 2 === 0 ? "#f9f9f9" : "transparent"
                            border.color: borderColor
                            border.width: 1
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 10
                                
                                CheckBox {
                                    checked: model.completed
                                    onCheckedChanged: {
                                        var dateStr = Qt.formatDate(selectedDate, "yyyy-MM-dd")
                                        if (checked) {
                                            fitnessManager.markCompleted(dateStr, model.plan)
                                        }
                                        updateSelectedDatePlans()
                                        updateCalendar()
                                    }
                                }
                                
                                Text {
                                    Layout.fillWidth: true
                                    text: model.plan
                                    font.pixelSize: 12
                                    color: model.completed ? "#666666" : textColor
                                    font.strikeout: model.completed
                                }
                                
                                Button {
                                    text: "删除"
                                    Layout.preferredWidth: 60
                                    Layout.preferredHeight: 25
                                    
                                    background: Rectangle {
                                        color: parent.pressed ? "#d32f2f" : (parent.hovered ? "#f44336" : "#ff5722")
                                        radius: 4
                                    }
                                    
                                    contentItem: Text {
                                        text: parent.text
                                        color: "white"
                                        font.pixelSize: 10
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    
                                    onClicked: {
                                        var dateStr = Qt.formatDate(selectedDate, "yyyy-MM-dd")
                                        fitnessManager.removePlan(dateStr, model.plan)
                                        updateSelectedDatePlans()
                                        updateCalendar()
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Statistics
                RowLayout {
                    Layout.fillWidth: true
                    
                    Text {
                        text: "本月统计："
                        font.pixelSize: 12
                        color: textColor
                    }
                    
                    Text {
                        text: "已完成: " + getMonthlyCompletedCount() + " / 总计: " + getMonthlyTotalCount()
                        font.pixelSize: 12
                        color: primaryColor
                    }
                    
                    Item {
                        Layout.fillWidth: true
                    }
                    
                    Text {
                        text: "完成率: " + Math.round(getMonthlyCompletionRate() * 100) + "%"
                        font.pixelSize: 12
                        font.bold: true
                        color: getMonthlyCompletionRate() > 0.7 ? completedColor : pendingColor
                    }
                }
            }
        }
    }
    
    // Functions
    function updateCalendar() {
        // Clear existing calendar items
        for (var i = calendarGrid.children.length - 1; i >= 0; i--) {
            calendarGrid.children[i].destroy()
        }
        
        var firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1)
        var lastDay = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0)
        var startDate = new Date(firstDay)
        startDate.setDate(startDate.getDate() - firstDay.getDay())
        
        for (var week = 0; week < 6; week++) {
            for (var day = 0; day < 7; day++) {
                var cellDate = new Date(startDate)
                cellDate.setDate(startDate.getDate() + week * 7 + day)
                
                var component = Qt.createComponent("CalendarCell.qml")
                if (component.status === Component.Ready) {
                    var cell = component.createObject(calendarGrid, {
                        "cellDate": cellDate,
                        "isCurrentMonth": cellDate.getMonth() === currentDate.getMonth(),
                        "isToday": isSameDate(cellDate, new Date()),
                        "isSelected": isSameDate(cellDate, selectedDate),
                        "hasPlans": fitnessManager.hasPlansForDate(Qt.formatDate(cellDate, "yyyy-MM-dd")),
                        "completionRate": getDateCompletionRate(cellDate)
                    })
                    
                    cell.clicked.connect(function(date) {
                        selectedDate = new Date(date)
                        updateSelectedDatePlans()
                        updateCalendar()
                    })
                }
            }
        }
    }
    
    function updateSelectedDatePlans() {
        plansModel.clear()
        var dateStr = Qt.formatDate(selectedDate, "yyyy-MM-dd")
        var plans = fitnessManager.getPlansForDate(dateStr)
        
        for (var i = 0; i < plans.length; i++) {
            plansModel.append({
                "plan": plans[i].plan,
                "completed": plans[i].completed
            })
        }
    }
    
    function isSameDate(date1, date2) {
        return date1.getFullYear() === date2.getFullYear() &&
               date1.getMonth() === date2.getMonth() &&
               date1.getDate() === date2.getDate()
    }
    
    function getDateCompletionRate(date) {
        var dateStr = Qt.formatDate(date, "yyyy-MM-dd")
        var plans = fitnessManager.getPlansForDate(dateStr)
        if (plans.length === 0) return 0
        
        var completed = 0
        for (var i = 0; i < plans.length; i++) {
            if (plans[i].completed) completed++
        }
        
        return completed / plans.length
    }
    
    function getMonthlyCompletedCount() {
        var monthStr = Qt.formatDate(currentDate, "yyyy-MM")
        return fitnessManager.getMonthlyCompletedCount(monthStr)
    }
    
    function getMonthlyTotalCount() {
        var monthStr = Qt.formatDate(currentDate, "yyyy-MM")
        return fitnessManager.getMonthlyTotalCount(monthStr)
    }
    
    function getMonthlyCompletionRate() {
        var total = getMonthlyTotalCount()
        if (total === 0) return 0
        return getMonthlyCompletedCount() / total
    }
    
    Component.onCompleted: {
        updateCalendar()
        updateSelectedDatePlans()
        console.log("Fitness calendar window loaded")
    }
}