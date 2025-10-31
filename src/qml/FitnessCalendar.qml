import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import DesktopElf 1.0

ApplicationWindow {
    id: fitnessWindow
    
    title: "健身计划日历"
    
    // 全屏设置
    flags: Qt.Window | Qt.FramelessWindowHint
    visibility: Window.FullScreen
    
    // 强制全屏显示
    width: Screen.width
    height: Screen.height
    
    // 属性
    property date currentDate: new Date()
    property date selectedDate: new Date()
    property var monthNames: ["一月", "二月", "三月", "四月", "五月", "六月", 
                             "七月", "八月", "九月", "十月", "十一月", "十二月"]
    property var weekDays: ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    
    // ESC键退出快捷键
    Shortcut {
        sequence: "Escape"
        onActivated: {
            console.log("ESC pressed, closing fitness window")
            fitnessWindow.close()
        }
    }
    
    // 窗口生命周期事件
    onVisibilityChanged: {
        console.log("FitnessCalendar visibility changed to:", visibility)
        // 如果不是全屏状态，强制设置为全屏
        if (visibility !== Window.FullScreen) {
            console.log("Forcing fullscreen mode")
            visibility = Window.FullScreen
        }
    }
    
    onClosing: {
        console.log("FitnessCalendar window closing")
    }
    
    // 主背景
    Rectangle {
        anchors.fill: parent
        color: "#1a1a1a"
        
        // 关闭按钮
        Rectangle {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20
            width: 40
            height: 40
            color: "#ff4444"
            radius: 20
            
            Text {
                anchors.centerIn: parent
                text: "×"
                color: "white"
                font.pixelSize: 24
                font.bold: true
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: fitnessWindow.close()
            }
        }
        
        // 标题和导航
        Rectangle {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 30
            width: 400
            height: 60
            color: "#333333"
            radius: 30
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                
                Button {
                    Layout.preferredWidth: 80
                    Layout.fillHeight: true
                    text: "◀ 上月"
                    
                    background: Rectangle {
                        color: parent.pressed ? "#666666" : (parent.hovered ? "#555555" : "transparent")
                        radius: 20
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        currentDate.setMonth(currentDate.getMonth() - 1)
                        currentDate = new Date(currentDate)
                        updateCalendar()
                    }
                }
                
                Text {
                    Layout.fillWidth: true
                    text: currentDate.getFullYear() + "年 " + monthNames[currentDate.getMonth()]
                    font.pixelSize: 24
                    font.bold: true
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                Button {
                    Layout.preferredWidth: 80
                    Layout.fillHeight: true
                    text: "下月 ▶"
                    
                    background: Rectangle {
                        color: parent.pressed ? "#666666" : (parent.hovered ? "#555555" : "transparent")
                        radius: 20
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        currentDate.setMonth(currentDate.getMonth() + 1)
                        currentDate = new Date(currentDate)
                        updateCalendar()
                    }
                }
            }
        }
        
        // 日历网格容器
        Rectangle {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 20
            width: Math.min(parent.width * 0.95, 1400)
            height: Math.min(parent.height * 0.75, 900)
            color: "#222222"
            border.color: "#444444"
            border.width: 2
            radius: 12
            
            GridLayout {
                id: mainCalendarGrid
                anchors.fill: parent
                anchors.margins: 8
                columns: 7
                rows: 7  // 1行星期标题 + 6行日期
                rowSpacing: 4
                columnSpacing: 4
                
                // 第一行：星期标题
                Repeater {
                    model: weekDays
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        color: "#4A7BA7"
                        border.color: "#5A8BB7"
                        border.width: 1
                        radius: 6
                        
                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            font.pixelSize: 16
                            font.bold: true
                            color: "white"
                        }
                    }
                }
                
                // 第2-7行：日期格子（动态生成）
                // 这里会通过 updateCalendar() 函数动态添加42个日期格子
            }
        }
    }
    
    // 日期单元格组件
    Component {
        id: dayCellComponent
        
        Rectangle {
            id: dayCell
            
            // 属性
            property date cellDate: new Date()
            property bool isCurrentMonth: true
            property bool isToday: false
            property bool isSelected: false
            property ListModel todoModel: ListModel {}
            
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 120
            
            color: {
                if (isToday) return "#ff6b35"
                if (isSelected) return "#4a90e2"
                if (!isCurrentMonth) return "#1a1a1a"
                return "#2a2a2a"
            }
            
            border.color: isToday ? "#ffffff" : "#555555"
            border.width: isToday ? 2 : 1
            radius: 8
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    selectedDate = new Date(dayCell.cellDate)
                    updateCalendar()
                }
            }
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 4
                
                // 日期数字
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 28
                    color: "#333333"
                    radius: 4
                    
                    Text {
                        anchors.centerIn: parent
                        text: cellDate.getDate()
                        font.pixelSize: isToday ? 18 : 14
                        font.bold: isToday || isSelected
                        color: {
                            if (isToday) return "white"
                            if (isSelected) return "white"
                            if (!isCurrentMonth) return "#666666"
                            return "#ffffff"
                        }
                    }
                }
                
                // 待办列表区域
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    
                    ColumnLayout {
                        width: parent.width
                        spacing: 2
                        
                        // 待办项列表
                        Repeater {
                            model: todoModel
                            
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 24
                                color: "transparent"
                                
                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 4
                                    
                                    CheckBox {
                                        Layout.preferredWidth: 20
                                        Layout.preferredHeight: 20
                                        checked: model.completed || false
                                        
                                        onCheckedChanged: {
                                            todoModel.setProperty(index, "completed", checked)
                                        }
                                        
                                        indicator: Rectangle {
                                            implicitWidth: 16
                                            implicitHeight: 16
                                            x: parent.leftPadding
                                            y: parent.height / 2 - height / 2
                                            radius: 3
                                            border.color: parent.checked ? "#4a90e2" : "#666666"
                                            border.width: 2
                                            color: parent.checked ? "#4a90e2" : "transparent"
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: "✓"
                                                color: "white"
                                                font.pixelSize: 10
                                                visible: parent.parent.checked
                                            }
                                        }
                                    }
                                    
                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: textArea.activeFocus ? "#3a3a3a" : "transparent"
                                        radius: 3
                                        border.color: textArea.activeFocus ? "#4a90e2" : "transparent"
                                        border.width: 1
                                        
                                        TextInput {
                                            id: textArea
                                            anchors.fill: parent
                                            anchors.margins: 4
                                            verticalAlignment: Text.AlignVCenter
                                            text: model.text || ""
                                            font.pixelSize: 11
                                            color: model.completed ? "#888888" : "#ffffff"
                                            font.strikeout: model.completed || false
                                            selectByMouse: true
                                            activeFocusOnPress: true
                                            
                                            // 双击处理
                                            MouseArea {
                                                anchors.fill: parent
                                                acceptedButtons: Qt.NoButton // 不接受按钮事件，只处理双击
                                                onDoubleClicked: {
                                                    textArea.forceActiveFocus()
                                                    textArea.selectAll()
                                                }
                                            }
                                            
                                            // 键盘事件处理
                                            Keys.onReturnPressed: {
                                                textArea.focus = false // 失去焦点，触发 onEditingFinished
                                            }
                                            
                                            Keys.onEnterPressed: {
                                                textArea.focus = false // 失去焦点，触发 onEditingFinished
                                            }
                                            
                                            Keys.onEscapePressed: {
                                                textArea.text = model.text || "" // 恢复原始文本
                                                textArea.focus = false // 失去焦点
                                            }
                                            
                                            // 编辑完成处理
                                            onEditingFinished: {
                                                console.log("编辑完成，保存文本:", text)
                                                todoModel.setProperty(index, "text", text)
                                            }
                                            
                                            // 接受处理（回车键触发）
                                            onAccepted: {
                                                console.log("接受输入，保存文本:", text)
                                                todoModel.setProperty(index, "text", text)
                                                textArea.focus = false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // 添加按钮
                        Button {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 24
                            text: "+ 添加待办"
                            
                            background: Rectangle {
                                color: parent.hovered ? "#4a90e2" : "#3a3a3a"
                                radius: 4
                                border.color: "#4a90e2"
                                border.width: 1
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.pixelSize: 10
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                todoModel.append({
                                    "text": "",
                                    "completed": false
                                })
                                
                                // 自动聚焦到新添加的文本框
                                Qt.callLater(function() {
                                    var lastIndex = todoModel.count - 1
                                    // 这里可以添加自动聚焦逻辑
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 函数
    function updateCalendar() {
        console.log("=== 开始更新日历 ===")
        console.log("当前日期:", Qt.formatDate(currentDate, "yyyy-MM-dd"))
        
        // 清空现有的日期格子（保留星期标题）
        for (var i = mainCalendarGrid.children.length - 1; i >= 7; i--) {
            mainCalendarGrid.children[i].destroy()
        }
        
        // 计算当月第一天
        var firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1)
        var lastDay = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0)
        
        // 计算开始日期（包含上月末尾几天），以周一为第一列
        var startDate = new Date(firstDay)
        var jsDay = firstDay.getDay() // 0=周日,1=周一,...
        var mondayOffset = (jsDay + 6) % 7
        startDate.setDate(startDate.getDate() - mondayOffset)
        
        console.log("日历开始日期(周一起):", startDate)
        
        // 生成6行7列的日期格子（共42天）
        for (var i = 0; i < 42; i++) {
            var cellDate = new Date(startDate)
            cellDate.setDate(startDate.getDate() + i)
            
            var cell = dayCellComponent.createObject(mainCalendarGrid, {
                "cellDate": cellDate,
                "isCurrentMonth": cellDate.getMonth() === currentDate.getMonth(),
                "isToday": isSameDate(cellDate, new Date()),
                "isSelected": isSameDate(cellDate, selectedDate)
            })
            
            if (cell) {
                console.log("创建日期格子:", Qt.formatDate(cellDate, "yyyy-MM-dd"))
            }
        }
        
        console.log("=== 日历更新完成 ===")
    }
    
    function isSameDate(date1, date2) {
        return date1.getFullYear() === date2.getFullYear() &&
               date1.getMonth() === date2.getMonth() &&
               date1.getDate() === date2.getDate()
    }
    
    Component.onCompleted: {
        console.log("FitnessCalendar window completed")
        updateCalendar()
        console.log("Fitness calendar window loaded in fullscreen mode")
    }
}
