import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import DesktopElf 1.0

Window {
    id: root
    visible: true
    visibility: Window.FullScreen
    flags: Qt.Window
    color: "transparent"

    // 当前日期信息
    property date currentDate: new Date()
    property int currentYear: currentDate.getFullYear()
    property int currentMonth: currentDate.getMonth()

    // 获取当月天数
    function getDaysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate()
    }

    // 获取当月第一天是星期几 (0=周日, 1=周一, ...)
    function getFirstDayOfMonth(year, month) {
        var firstDay = new Date(year, month, 1).getDay()
        return firstDay === 0 ? 6 : firstDay - 1 // 转换为周一为0
    }

    // 半透明背景
    Rectangle {
        anchors.fill: parent
        color: "#CC000000"
        opacity: 0.85

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
    }

    // 主容器
    Rectangle {
        anchors.fill: parent
        anchors.margins: 40
        color: "#F0F5F9"
        radius: 15

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            // 标题栏
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color: "#2E5090"
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15

                    Text {
                        text: currentYear + "年" + (currentMonth + 1) + "月"
                        font.pixelSize: 20
                        font.bold: true
                        color: "white"
                    }

                    Item { Layout.fillWidth: true }

                    Button {
                        text: "关闭"
                        font.pixelSize: 12
                        onClicked: root.close()
                    }
                }
            }

            // 日历网格
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 7
                rowSpacing: 8
                columnSpacing: 8
                Layout.minimumHeight: parent.height - 100

                // 第一行：星期标题
                Repeater {
                    model: ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        color: "#4A7BA7"
                        radius: 5

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            font.pixelSize: 12
                            font.bold: true
                            color: "white"
                        }
                    }
                }

                // 日期方块
                Repeater {
                    model: 42 // 6行 x 7列

                    delegate: dayCellComponent
                }
            }
        }
    }

    // 日期单元格组件
    Component {
        id: dayCellComponent

        Rectangle {
            id: dayCell
            Layout.fillWidth: true
            Layout.fillHeight: true

            property int cellIndex: index
            property int firstDay: getFirstDayOfMonth(currentYear, currentMonth)
            property int daysInMonth: getDaysInMonth(currentYear, currentMonth)
            property int dayNumber: cellIndex - firstDay + 1
            property int dayText: (dayNumber > 0 && dayNumber <= daysInMonth) ? dayNumber : 0
            property bool isValid: dayNumber > 0 && dayNumber <= daysInMonth

            color: isValid ? "white" : "#E8E8E8"
            radius: 8
            border.color: isValid ? "#C0C0C0" : "#E0E0E0"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 3
                visible: dayCell.isValid

                // 日期标题
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 22
                    color: "#F0F0F0"
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: dayCell.dayText
                        font.pixelSize: 13
                        font.bold: true
                        color: "#2E5090"
                    }
                }

                // 待办事项列表（包含添加按钮）
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 150
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded

                    ColumnLayout {
                        width: parent.width
                        spacing: 1

                        // 待办事项列表
                        Repeater {
                            id: todoRepeater
                            model: ListModel { id: todoModel }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 22
                                color: "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 3

                                    CheckBox {
                                        id: checkbox
                                        checked: model.completed
                                        Layout.preferredWidth: 18
                                        Layout.preferredHeight: 18
                                        onCheckedChanged: {
                                            todoModel.setProperty(index, "completed", checked)
                                        }
                                    }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: textInput.activeFocus ? "#E3F2FD" : "transparent"
                                        radius: 3

                                        TextInput {
                                            id: textInput
                                            anchors.fill: parent
                                            anchors.leftMargin: 3
                                            anchors.rightMargin: 3
                                            verticalAlignment: Text.AlignVCenter
                                            text: model.text
                                            font.pixelSize: 10
                                            color: model.completed ? "#888888" : "#333333"
                                            font.strikeout: model.completed
                                            selectByMouse: true
                                            clip: true

                                            onEditingFinished: {
                                                todoModel.setProperty(index, "text", text)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // 添加按钮（始终在列表最后）
                        Button {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 22
                            text: "+ 添加待办"
                            font.pixelSize: 10

                            background: Rectangle {
                                color: parent.hovered ? "#E3F2FD" : "#F5F5F5"
                                radius: 4
                                border.color: "#2E5090"
                                border.width: 1
                            }

                            onClicked: {
                                todoModel.append({
                                    "text": "",
                                    "completed": false
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}
