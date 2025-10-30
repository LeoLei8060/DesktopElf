import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Rectangle {
    id: calendarCell
    
    // Properties
    property date cellDate: new Date()
    property bool isCurrentMonth: true
    property bool isToday: false
    property bool isSelected: false
    property bool hasPlans: false
    property real completionRate: 0.0
    
    // Signals
    signal clicked(date date)
    
    // Layout
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumHeight: 60
    
    // Colors
    readonly property color normalColor: "#ffffff"
    readonly property color hoverColor: "#f0f8ff"
    readonly property color selectedColor: "#4a90e2"
    readonly property color todayColor: "#e3f2fd"
    readonly property color otherMonthColor: "#f5f5f5"
    readonly property color completedColor: "#4caf50"
    readonly property color partialColor: "#ff9800"
    readonly property color pendingColor: "#f44336"
    
    // Appearance
    color: {
        if (isSelected) return selectedColor
        if (isToday) return todayColor
        if (!isCurrentMonth) return otherMonthColor
        if (mouseArea.containsMouse) return hoverColor
        return normalColor
    }
    
    border.color: "#e0e0e0"
    border.width: 1
    
    // Content
    Column {
        anchors.centerIn: parent
        spacing: 4
        
        // Date number
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: cellDate.getDate()
            font.pixelSize: 14
            font.bold: isToday || isSelected
            color: {
                if (isSelected) return "white"
                if (!isCurrentMonth) return "#999999"
                if (isToday) return "#1976d2"
                return "#333333"
            }
        }
        
        // Plan indicator
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 20
            height: 4
            radius: 2
            visible: hasPlans
            color: {
                if (completionRate >= 1.0) return completedColor
                if (completionRate > 0.0) return partialColor
                return pendingColor
            }
        }
        
        // Completion percentage (for cells with plans)
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: hasPlans ? Math.round(completionRate * 100) + "%" : ""
            font.pixelSize: 8
            color: {
                if (isSelected) return "white"
                if (completionRate >= 1.0) return completedColor
                if (completionRate > 0.0) return partialColor
                return pendingColor
            }
            visible: hasPlans
        }
    }
    
    // Mouse interaction
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        onClicked: {
            calendarCell.clicked(cellDate)
        }
    }
    
    // Hover effect
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: "#4a90e2"
        border.width: 2
        radius: 4
        visible: mouseArea.containsMouse && !isSelected
        opacity: 0.5
    }
    
    // Selection effect
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: "white"
        border.width: 2
        radius: 4
        visible: isSelected
    }
    
    // Today indicator
    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 2
        width: 8
        height: 8
        radius: 4
        color: "#1976d2"
        visible: isToday && !isSelected
    }
}