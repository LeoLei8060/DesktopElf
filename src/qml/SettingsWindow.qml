import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.15
import DesktopElf 1.0

ApplicationWindow {
    id: settingsWindow
    
    title: "桌面精灵设置"
    width: 500
    height: 600
    minimumWidth: 450
    minimumHeight: 550
    
    flags: Qt.Window | Qt.WindowCloseButtonHint | Qt.WindowMinimizeButtonHint
    modality: Qt.NonModal
    
    // Window properties
    property bool isModified: false
    
    // Color scheme
    readonly property color primaryColor: "#4a90e2"
    readonly property color backgroundColor: "#f8f9fa"
    readonly property color cardColor: "#ffffff"
    readonly property color textColor: "#333333"
    readonly property color borderColor: "#e0e0e0"
    
    background: Rectangle {
        color: backgroundColor
    }
    
    // Main content
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        
        ColumnLayout {
            width: settingsWindow.width - 40
            spacing: 20
            
            // Title
            Text {
                text: "桌面精灵设置"
                font.pixelSize: 24
                font.bold: true
                color: textColor
                Layout.alignment: Qt.AlignHCenter
            }
            
            // Basic Settings Card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: basicSettingsColumn.implicitHeight + 40
                color: cardColor
                border.color: borderColor
                border.width: 1
                radius: 8
                
                ColumnLayout {
                    id: basicSettingsColumn
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    Text {
                        text: "基本设置"
                        font.pixelSize: 18
                        font.bold: true
                        color: primaryColor
                    }
                    
                    // Sprite Image Path
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "精灵图片："
                            font.pixelSize: 12
                            color: textColor
                            Layout.preferredWidth: 80
                        }
                        
                        TextField {
                            id: spriteImageField
                            Layout.fillWidth: true
                            text: configManager.spriteImagePath
                            placeholderText: "选择精灵图片文件"
                            readOnly: true
                            
                            background: Rectangle {
                                color: "#f5f5f5"
                                border.color: borderColor
                                border.width: 1
                                radius: 4
                            }
                        }
                        
                        Button {
                            text: "浏览"
                            onClicked: spriteImageDialog.open()
                            
                            background: Rectangle {
                                color: parent.pressed ? "#3a7bc8" : (parent.hovered ? "#5ba0f2" : primaryColor)
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.pixelSize: 11
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                    
                    // Move Animation Path
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "移动动画："
                            font.pixelSize: 12
                            color: textColor
                            Layout.preferredWidth: 80
                        }
                        
                        TextField {
                            id: moveAnimationField
                            Layout.fillWidth: true
                            text: configManager.moveAnimationPath
                            placeholderText: "选择移动动画文件夹"
                            readOnly: true
                            
                            background: Rectangle {
                                color: "#f5f5f5"
                                border.color: borderColor
                                border.width: 1
                                radius: 4
                            }
                        }
                        
                        Button {
                            text: "浏览"
                            onClicked: moveAnimationDialog.open()
                            
                            background: Rectangle {
                                color: parent.pressed ? "#3a7bc8" : (parent.hovered ? "#5ba0f2" : primaryColor)
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.pixelSize: 11
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                    
                    // Jump Animation Path
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "跳跃动画："
                            font.pixelSize: 12
                            color: textColor
                            Layout.preferredWidth: 80
                        }
                        
                        TextField {
                            id: jumpAnimationField
                            Layout.fillWidth: true
                            text: configManager.jumpAnimationPath
                            placeholderText: "选择跳跃动画文件夹"
                            readOnly: true
                            
                            background: Rectangle {
                                color: "#f5f5f5"
                                border.color: borderColor
                                border.width: 1
                                radius: 4
                            }
                        }
                        
                        Button {
                            text: "浏览"
                            onClicked: jumpAnimationDialog.open()
                            
                            background: Rectangle {
                                color: parent.pressed ? "#3a7bc8" : (parent.hovered ? "#5ba0f2" : primaryColor)
                                radius: 4
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.pixelSize: 11
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                    
                    // Position Settings
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "位置："
                            font.pixelSize: 12
                            color: textColor
                            Layout.preferredWidth: 80
                        }
                        
                        Text {
                            text: "X:"
                            font.pixelSize: 11
                            color: textColor
                        }
                        
                        SpinBox {
                            id: positionXSpinBox
                            from: 0
                            to: 9999
                            value: configManager.position.x
                            
                            onValueChanged: {
                                if (value !== configManager.position.x) {
                                    isModified = true
                                }
                            }
                        }
                        
                        Text {
                            text: "Y:"
                            font.pixelSize: 11
                            color: textColor
                        }
                        
                        SpinBox {
                            id: positionYSpinBox
                            from: 0
                            to: 9999
                            value: configManager.position.y
                            
                            onValueChanged: {
                                if (value !== configManager.position.y) {
                                    isModified = true
                                }
                            }
                        }
                    }
                }
            }
            
            // Appearance Settings Card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: appearanceSettingsColumn.implicitHeight + 40
                color: cardColor
                border.color: borderColor
                border.width: 1
                radius: 8
                
                ColumnLayout {
                    id: appearanceSettingsColumn
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    Text {
                        text: "外观设置"
                        font.pixelSize: 18
                        font.bold: true
                        color: primaryColor
                    }
                    
                    // Background Color
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "背景颜色："
                            font.pixelSize: 12
                            color: textColor
                            Layout.preferredWidth: 80
                        }
                        
                        Rectangle {
                            width: 40
                            height: 25
                            color: configManager.backgroundColor
                            border.color: borderColor
                            border.width: 1
                            radius: 4
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: backgroundColorDialog.open()
                            }
                        }
                        
                        TextField {
                            id: backgroundColorField
                            Layout.fillWidth: true
                            text: configManager.backgroundColor
                            placeholderText: "#RRGGBB"
                            
                            onTextChanged: {
                                if (text !== configManager.backgroundColor) {
                                    isModified = true
                                }
                            }
                        }
                    }
                    
                    // Opacity
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "不透明度："
                            font.pixelSize: 12
                            color: textColor
                            Layout.preferredWidth: 80
                        }
                        
                        Slider {
                            id: opacitySlider
                            Layout.fillWidth: true
                            from: 0.1
                            to: 1.0
                            value: configManager.opacity
                            stepSize: 0.1
                            
                            onValueChanged: {
                                if (Math.abs(value - configManager.opacity) > 0.05) {
                                    isModified = true
                                }
                            }
                        }
                        
                        Text {
                            text: Math.round(opacitySlider.value * 100) + "%"
                            font.pixelSize: 11
                            color: textColor
                            Layout.preferredWidth: 40
                        }
                    }
                    
                    // Font Color
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "字体颜色："
                            font.pixelSize: 12
                            color: textColor
                            Layout.preferredWidth: 80
                        }
                        
                        Rectangle {
                            width: 40
                            height: 25
                            color: configManager.fontColor
                            border.color: borderColor
                            border.width: 1
                            radius: 4
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: fontColorDialog.open()
                            }
                        }
                        
                        TextField {
                            id: fontColorField
                            Layout.fillWidth: true
                            text: configManager.fontColor
                            placeholderText: "#RRGGBB"
                            
                            onTextChanged: {
                                if (text !== configManager.fontColor) {
                                    isModified = true
                                }
                            }
                        }
                    }
                    
                    // Always on Top
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "总是置顶："
                            font.pixelSize: 12
                            color: textColor
                            Layout.preferredWidth: 80
                        }
                        
                        CheckBox {
                            id: alwaysOnTopCheckBox
                            checked: configManager.alwaysOnTop
                            
                            onCheckedChanged: {
                                if (checked !== configManager.alwaysOnTop) {
                                    isModified = true
                                }
                            }
                        }
                    }
                }
            }
            
            // Timer Settings Card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: timerSettingsColumn.implicitHeight + 40
                color: cardColor
                border.color: borderColor
                border.width: 1
                radius: 8
                
                ColumnLayout {
                    id: timerSettingsColumn
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    Text {
                        text: "定时器设置"
                        font.pixelSize: 18
                        font.bold: true
                        color: primaryColor
                    }
                    
                    // Enable Hourly Chime
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "启用整点报时："
                            font.pixelSize: 12
                            color: textColor
                            Layout.preferredWidth: 120
                        }
                        
                        CheckBox {
                            id: hourlyChimeCheckBox
                            checked: timerManager.enabled
                            
                            onCheckedChanged: {
                                timerManager.enabled = checked
                                if (checked) {
                                    timerManager.startTimer()
                                } else {
                                    timerManager.stopTimer()
                                }
                            }
                        }
                    }
                    
                    // Next Trigger Time
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "下次触发时间："
                            font.pixelSize: 12
                            color: textColor
                            Layout.preferredWidth: 120
                        }
                        
                        Text {
                            text: timerManager.nextTriggerTime
                            font.pixelSize: 12
                            color: primaryColor
                        }
                    }
                }
            }
            
            // Button Row
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 20
                
                Button {
                    text: "重置默认"
                    Layout.preferredWidth: 100
                    
                    background: Rectangle {
                        color: parent.pressed ? "#d32f2f" : (parent.hovered ? "#f44336" : "#ff5722")
                        radius: 4
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        resetToDefaults()
                    }
                }
                
                Item {
                    Layout.fillWidth: true
                }
                
                Button {
                    text: "取消"
                    Layout.preferredWidth: 80
                    
                    background: Rectangle {
                        color: parent.pressed ? "#757575" : (parent.hovered ? "#9e9e9e" : "#bdbdbd")
                        radius: 4
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        settingsWindow.close()
                    }
                }
                
                Button {
                    text: "应用"
                    Layout.preferredWidth: 80
                    enabled: isModified
                    
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
                        applySettings()
                    }
                }
            }
        }
    }
    
    // File Dialogs
    FileDialog {
        id: spriteImageDialog
        title: "选择精灵图片"
        nameFilters: ["图片文件 (*.png *.jpg *.jpeg *.gif *.bmp)"]
        onAccepted: {
            spriteImageField.text = fileUrl.toString().replace("file:///", "")
            isModified = true
        }
    }
    
    FileDialog {
        id: moveAnimationDialog
        title: "选择移动动画文件夹"
        selectFolder: true
        onAccepted: {
            moveAnimationField.text = fileUrl.toString().replace("file:///", "")
            isModified = true
        }
    }
    
    FileDialog {
        id: jumpAnimationDialog
        title: "选择跳跃动画文件夹"
        selectFolder: true
        onAccepted: {
            jumpAnimationField.text = fileUrl.toString().replace("file:///", "")
            isModified = true
        }
    }
    
    ColorDialog {
        id: backgroundColorDialog
        title: "选择背景颜色"
        color: configManager.backgroundColor
        onAccepted: {
            backgroundColorField.text = color.toString()
            isModified = true
        }
    }
    
    ColorDialog {
        id: fontColorDialog
        title: "选择字体颜色"
        color: configManager.fontColor
        onAccepted: {
            fontColorField.text = color.toString()
            isModified = true
        }
    }
    
    // Functions
    function applySettings() {
        // Apply all settings
        configManager.spriteImagePath = spriteImageField.text
        configManager.moveAnimationPath = moveAnimationField.text
        configManager.jumpAnimationPath = jumpAnimationField.text
        configManager.position = Qt.point(positionXSpinBox.value, positionYSpinBox.value)
        configManager.backgroundColor = backgroundColorField.text
        configManager.opacity = opacitySlider.value
        configManager.fontColor = fontColorField.text
        configManager.alwaysOnTop = alwaysOnTopCheckBox.checked
        
        // Save configuration
        configManager.saveConfig()
        
        // Update sprite controller
        spriteController.setDefaultImagePath(configManager.spriteImagePath)
        spriteController.setMoveAnimationPath(configManager.moveAnimationPath)
        spriteController.setJumpAnimationPath(configManager.jumpAnimationPath)
        spriteController.position = configManager.position
        
        isModified = false
        
        console.log("Settings applied successfully")
    }
    
    function resetToDefaults() {
        configManager.resetToDefaults()
        
        // Update UI
        spriteImageField.text = configManager.spriteImagePath
        moveAnimationField.text = configManager.moveAnimationPath
        jumpAnimationField.text = configManager.jumpAnimationPath
        positionXSpinBox.value = configManager.position.x
        positionYSpinBox.value = configManager.position.y
        backgroundColorField.text = configManager.backgroundColor
        opacitySlider.value = configManager.opacity
        fontColorField.text = configManager.fontColor
        alwaysOnTopCheckBox.checked = configManager.alwaysOnTop
        
        isModified = true
        
        console.log("Settings reset to defaults")
    }
    
    Component.onCompleted: {
        console.log("Settings window loaded")
    }
    
    onClosing: {
        if (isModified) {
            // Could add a confirmation dialog here
            console.log("Settings window closing with unsaved changes")
        }
    }
}