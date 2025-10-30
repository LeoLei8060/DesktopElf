import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.15

Rectangle {
    id: calendarCell
    
    // 属性
    property date cellDate: new Date()
    property bool isCurrentMonth: true
    property bool isToday: false
    property bool isSelected: false
    property bool hasPlans: false
    property real completionRate: 0.0
    property bool isEditing: false
    // 文本列表模型与编辑索引
    property ListModel planModel: ListModel {}
    property int editingIndex: -1
    
    // 信号
    signal clicked(date date)
    signal planChanged(date date, string plan)
    
    // 移除 Layout 属性，这些应该在创建时设置
    // Layout.fillWidth: true
    // Layout.fillHeight: true
    // Layout.minimumHeight: 120
    
    // 颜色定义
    readonly property color normalColor: "#2a2a2a"
    readonly property color hoverColor: "#3a3a3a"
    readonly property color selectedColor: "#4a90e2"
    readonly property color todayColor: "#ff6b35"  // 明亮的橙色用于当日高亮
    readonly property color otherMonthColor: "#1a1a1a"
    readonly property color completedColor: "#4caf50"
    readonly property color partialColor: "#ff9800"
    readonly property color pendingColor: "#f44336"
    
    // 外观
    color: {
        if (isToday) return todayColor
        if (isSelected) return selectedColor
        if (!isCurrentMonth) return otherMonthColor
        if (mouseArea.containsMouse) return hoverColor
        return normalColor
    }
    
    border.color: isToday ? "#ffffff" : "#555555"
    border.width: isToday ? 3 : 1
    radius: 8
    
    // 移除 DropShadow 效果以避免加载问题
    // DropShadow {
    //     anchors.fill: parent
    //     source: parent
    //     radius: isToday ? 16 : 0
    //     samples: 32
    //     color: isToday ? "#ff6b35" : "transparent"
    //     horizontalOffset: 0
    //     verticalOffset: 0
    //     visible: isToday
    // }
    
    // 内容
    Column {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4
        
        // 日期数字
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: cellDate.getDate()
            font.pixelSize: isToday ? 20 : 16
            font.bold: isToday || isSelected
            color: {
                if (isToday) return "white"
                if (isSelected) return "white"
                if (!isCurrentMonth) return "#666666"
                return "#ffffff"
            }
        }
        
        // 计划指示器
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 4
            height: 6
            radius: 3
            visible: hasPlans
            color: {
                if (completionRate >= 1.0) return completedColor
                if (completionRate > 0.0) return partialColor
                return pendingColor
            }
        }
        
        // 文本列表（可双击编辑），默认空，最后一行按钮添加空白行
        Flickable {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 4
            height: parent.height - 56
            contentWidth: width
            contentHeight: listColumn.height
            clip: true

            Column {
                id: listColumn
                width: parent.width
                spacing: 4

                Repeater {
                    model: planModel
                    Rectangle {
                        width: listColumn.width
                        height: 22
                        radius: 4
                        color: "#2f3136"
                        border.color: "#3a3d44"
                        border.width: 1

                        Loader {
                            anchors.fill: parent
                            sourceComponent: (index === calendarCell.editingIndex) ? editComp : textComp
                        }

                        Component {
                            id: textComp
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 6
                                text: model.name
                                color: isToday ? "white" : "#d0d4dc"
                                font.pixelSize: 12
                                elide: Text.ElideRight
                            }
                        }

                        Component {
                            id: editComp
                            TextField {
                                anchors.fill: parent
                                anchors.margins: 2
                                text: model.name
                                font.pixelSize: 12
                                focus: true
                                selectByMouse: true
                                // 编辑前的旧名称，用于后端更新
                                property string oldName: model.name
                                onEditingFinished: {
                                    var content = text.trim()
                                    if (typeof fitnessManager !== 'undefined' && fitnessManager) {
                                        if (content === "") {
                                            // 空内容则移除占位计划
                                            fitnessManager.removePlan(calendarCell.cellDate, oldName)
                                        } else {
                                            // 名称变更：先移除旧名称，再添加新名称
                                            if (content !== oldName) {
                                                fitnessManager.removePlan(calendarCell.cellDate, oldName)
                                            }
                                            fitnessManager.addPlan(calendarCell.cellDate, content, "")
                                        }
                                    }
                                    calendarCell.editingIndex = -1
                                    calendarCell.loadPlans()
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onDoubleClicked: {
                                calendarCell.editingIndex = index
                            }
                        }
                    }
                }

                Button {
                    width: listColumn.width
                    text: "+ 添加"
                    onClicked: {
                        // 生成不与现有重复的占位名称
                        var base = "新计划"
                        var name = base
                        var n = 1
                        var existing = {}
                        for (var i = 0; i < planModel.count; i++) {
                            existing[planModel.get(i).name] = true
                        }
                        while (existing[name]) {
                            name = base + " " + n
                            n++
                        }

                        if (typeof fitnessManager !== 'undefined' && fitnessManager) {
                            fitnessManager.addPlan(calendarCell.cellDate, name, "")
                        }
                        calendarCell.loadPlans()
                        calendarCell.editingIndex = planModel.count - 1
                    }
                }
            }
        }
    }
    
    // 鼠标交互
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        onClicked: {
            calendarCell.clicked(cellDate)
        }
    }
    
    // 悬停效果
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: "#4a90e2"
        border.width: 2
        radius: 8
        visible: mouseArea.containsMouse && !isSelected && !isToday
        opacity: 0.7
    }
    
    // 选中效果
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: "white"
        border.width: 2
        radius: 8
        visible: isSelected && !isToday
    }
    
    // 函数：加载指定日期的计划列表
    function loadPlans() {
        planModel.clear()
        if (typeof fitnessManager !== 'undefined' && fitnessManager) {
            var plans = fitnessManager.getPlansForDate(cellDate)
            for (var i = 0; i < plans.length; i++) {
                var p = plans[i]
                planModel.append({ name: p.name, description: p.description, completed: p.completed })
            }
        }
    }

    Component.onCompleted: loadPlans()
    // 监听属性变化
    onCellDateChanged: loadPlans()
    onHasPlansChanged: loadPlans()
}