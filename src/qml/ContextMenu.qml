import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Menu {
    id: contextMenu
    
    // Signals
    signal settingsRequested()
    signal fitnessRequested()
    signal hideRequested()
    signal exitRequested()
    
    // Menu styling
    background: Rectangle {
        implicitWidth: 180
        implicitHeight: 40
        color: "#f0f0f0"
        border.color: "#d0d0d0"
        border.width: 1
        radius: 6
        
        // Drop shadow effect
        layer.enabled: true
        layer.effect: DropShadow {
            radius: 8
            samples: 16
            color: "#40000000"
            horizontalOffset: 2
            verticalOffset: 2
        }
    }
    
    // Menu items
    MenuItem {
        id: settingsItem
        text: "设置"
        icon.source: "qrc:/resources/images/settings.svg"
        height: 32
        
        background: Rectangle {
            implicitWidth: 180
            implicitHeight: 32
            color: parent.hovered ? "#e0e0e0" : "transparent"
            radius: 4
        }
        
        contentItem: Row {
            spacing: 8
            leftPadding: 12
            rightPadding: 12
            
            Image {
                source: settingsItem.icon.source
                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
            }
            
            Text {
                text: settingsItem.text
                font.pixelSize: 12
                color: "#333333"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        onTriggered: {
            contextMenu.close()
            settingsRequested()
        }
    }
    
    MenuItem {
        id: fitnessItem
        text: "健身计划"
        icon.source: "qrc:/resources/images/fitness.svg"
        height: 32
        
        background: Rectangle {
            implicitWidth: 180
            implicitHeight: 32
            color: parent.hovered ? "#e0e0e0" : "transparent"
            radius: 4
        }
        
        contentItem: Row {
            spacing: 8
            leftPadding: 12
            rightPadding: 12
            
            Image {
                source: fitnessItem.icon.source
                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
            }
            
            Text {
                text: fitnessItem.text
                font.pixelSize: 12
                color: "#333333"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        onTriggered: {
            contextMenu.close()
            fitnessRequested()
        }
    }
    
    MenuSeparator {
        background: Rectangle {
            implicitWidth: 160
            implicitHeight: 1
            color: "#d0d0d0"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    
    MenuItem {
        id: moveItem
        text: "移动到..."
        icon.source: "qrc:/resources/images/move.svg"
        height: 32
        
        background: Rectangle {
            implicitWidth: 180
            implicitHeight: 32
            color: parent.hovered ? "#e0e0e0" : "transparent"
            radius: 4
        }
        
        contentItem: Row {
            spacing: 8
            leftPadding: 12
            rightPadding: 12
            
            Image {
                source: moveItem.icon.source
                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
            }
            
            Text {
                text: moveItem.text
                font.pixelSize: 12
                color: "#333333"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        Menu {
            id: moveSubmenu
            title: "移动到..."
            
            MenuItem {
                text: "屏幕中央"
                onTriggered: {
                    var screenCenter = Qt.point(
                        (Screen.width - 150) / 2,
                        (Screen.height - 150) / 2
                    )
                    spriteController.moveToPosition(screenCenter)
                    contextMenu.close()
                }
            }
            
            MenuItem {
                text: "左上角"
                onTriggered: {
                    spriteController.moveToPosition(Qt.point(50, 50))
                    contextMenu.close()
                }
            }
            
            MenuItem {
                text: "右上角"
                onTriggered: {
                    spriteController.moveToPosition(Qt.point(Screen.width - 200, 50))
                    contextMenu.close()
                }
            }
            
            MenuItem {
                text: "左下角"
                onTriggered: {
                    spriteController.moveToPosition(Qt.point(50, Screen.height - 200))
                    contextMenu.close()
                }
            }
            
            MenuItem {
                text: "右下角"
                onTriggered: {
                    spriteController.moveToPosition(Qt.point(Screen.width - 200, Screen.height - 200))
                    contextMenu.close()
                }
            }
        }
        
        onTriggered: moveSubmenu.popup()
    }
    
    MenuItem {
        id: animationItem
        text: "动画"
        icon.source: "qrc:/resources/images/animation.svg"
        height: 32
        
        background: Rectangle {
            implicitWidth: 180
            implicitHeight: 32
            color: parent.hovered ? "#e0e0e0" : "transparent"
            radius: 4
        }
        
        contentItem: Row {
            spacing: 8
            leftPadding: 12
            rightPadding: 12
            
            Image {
                source: animationItem.icon.source
                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
            }
            
            Text {
                text: animationItem.text
                font.pixelSize: 12
                color: "#333333"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        Menu {
            id: animationSubmenu
            title: "动画"
            
            MenuItem {
                text: "空闲动画"
                onTriggered: {
                    spriteController.startIdleAnimation()
                    contextMenu.close()
                }
            }
            
            MenuItem {
                text: "移动动画"
                onTriggered: {
                    spriteController.startMoveAnimation()
                    contextMenu.close()
                }
            }
            
            MenuItem {
                text: "跳跃动画"
                onTriggered: {
                    spriteController.startJumpAnimation()
                    contextMenu.close()
                }
            }
            
            MenuItem {
                text: "停止动画"
                onTriggered: {
                    spriteController.stopAllAnimations()
                    contextMenu.close()
                }
            }
        }
        
        onTriggered: animationSubmenu.popup()
    }
    
    MenuSeparator {
        background: Rectangle {
            implicitWidth: 160
            implicitHeight: 1
            color: "#d0d0d0"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    
    MenuItem {
        id: hideItem
        text: "隐藏"
        icon.source: "qrc:/resources/images/hide.svg"
        height: 32
        
        background: Rectangle {
            implicitWidth: 180
            implicitHeight: 32
            color: parent.hovered ? "#e0e0e0" : "transparent"
            radius: 4
        }
        
        contentItem: Row {
            spacing: 8
            leftPadding: 12
            rightPadding: 12
            
            Image {
                source: hideItem.icon.source
                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
            }
            
            Text {
                text: hideItem.text
                font.pixelSize: 12
                color: "#333333"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        onTriggered: {
            contextMenu.close()
            hideRequested()
        }
    }
    
    MenuItem {
        id: exitItem
        text: "退出"
        icon.source: "qrc:/resources/images/exit.svg"
        height: 32
        
        background: Rectangle {
            implicitWidth: 180
            implicitHeight: 32
            color: parent.hovered ? "#ffcccc" : "transparent"
            radius: 4
        }
        
        contentItem: Row {
            spacing: 8
            leftPadding: 12
            rightPadding: 12
            
            Image {
                source: exitItem.icon.source
                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
            }
            
            Text {
                text: exitItem.text
                font.pixelSize: 12
                color: "#cc0000"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        onTriggered: {
            contextMenu.close()
            exitRequested()
        }
    }
}
