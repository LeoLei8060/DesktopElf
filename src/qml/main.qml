import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import DesktopElf 1.0

ApplicationWindow {
    id: mainWindow

    // Window properties
    width: 150
    height: 150
    visible: true  // Ensure window is visible
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"

    // Additional window properties for better visibility
    modality: Qt.NonModal
    title: "Desktop Elf"

    // Make window draggable
    property bool isDragging: false
    property point dragStartPosition

    // References to other windows
    property var settingsWindow: null
    property var fitnessWindow: null
    property var fitnessWindow2: null

    // Window positioning
    x: spriteController.position.x
    y: spriteController.position.y

    // Update window position when sprite position changes
    Connections {
        target: spriteController
        function onPositionChanged() {
            mainWindow.x = spriteController.position.x
            mainWindow.y = spriteController.position.y
        }
    }

    // Main sprite display
    Rectangle {
        id: spriteContainer
        anchors.fill: parent
        color: "transparent"

        // Smooth scale animation
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutQuad
            }
        }

        // Sprite image
        AnimatedImage {
            id: spriteImage
            anchors.centerIn: parent
            width: 120
            height: 120
            fillMode: Image.PreserveAspectFit
            source: spriteController.currentImagePath
            playing: true

            // Handle static images
            onStatusChanged: {
                if (status === Image.Error) {
                    console.log("Failed to load image:", source)
                }
            }
        }

        // Fallback for static images when AnimatedImage fails
        Image {
            id: staticImage
            anchors.centerIn: parent
            width: 120
            height: 120
            fillMode: Image.PreserveAspectFit
            source: spriteImage.status === Image.Error ? spriteController.currentImagePath : ""
            visible: spriteImage.status === Image.Error
        }

        // Glow effect for sprite
        DropShadow {
            anchors.fill: spriteImage
            source: spriteImage
            radius: 8
            samples: 16
            color: "#40000000"
            horizontalOffset: 2
            verticalOffset: 2
            z: -1  // Place behind the sprite
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            property point lastPos: Qt.point(0, 0)

            onPressed: (mouse) => {
                lastPos = Qt.point(mouse.x, mouse.y)
            }

            onPositionChanged: (mouse) => {
                var delta = Qt.point(mouse.x - lastPos.x, mouse.y - lastPos.y)
                mainWindow.x += delta.x
                mainWindow.y += delta.y
            }

            onClicked: {
                if (mouse.button === Qt.RightButton) {
                    contextMenu.popup()
                }
            }
        }
    }

    // Context menu
    ContextMenu {
        id: contextMenu

        onSettingsRequested: {
            showSettingsWindow()
        }

        onFitnessRequested: {
            showFitnessWindow()
        }

        onHideRequested: {
            mainWindow.hide()
        }

        onExitRequested: {
            Qt.quit()
        }
    }

    // Functions
    function showSettingsWindow() {
        if (!settingsWindow) {
            var component = Qt.createComponent("SettingsWindow.qml")
            if (component.status === Component.Ready) {
                settingsWindow = component.createObject(mainWindow)
                settingsWindow.show()
            } else {
                console.log("Error creating settings window:", component.errorString())
            }
        } else {
            settingsWindow.show()
            settingsWindow.raise()
        }
    }

    function showFitnessWindow() {
        console.log("Attempting to show fitness window...")
        if (!fitnessWindow2) {
            console.log("Creating new fitness window...")
            var component = Qt.createComponent("FitnessCalendar.qml")
            if (component.status === Component.Ready) {
                // 创建为独立窗口，不设置父对象
                fitnessWindow2 = component.createObject(null)
                if (fitnessWindow2) {
                    console.log("Fitness window created successfully")
                    // 不调用 show()，让 visibility: Window.FullScreen 生效
                    fitnessWindow2.raise()
                    fitnessWindow2.requestActivate()
                } else {
                    console.log("Failed to create fitness window object")
                }
            } else {
                console.log("Error creating fitness window:", component.errorString())
            }
        } else {
            console.log("Showing existing fitness window...")
            fitnessWindow2.show()
            fitnessWindow2.raise()
            fitnessWindow2.requestActivate()
        }
    }

    // Animation effects
    SequentialAnimation {
        id: jumpEffect
        running: spriteController.isAnimating

        ParallelAnimation {
            NumberAnimation {
                target: spriteContainer
                property: "y"
                from: 0
                to: -20
                duration: 300
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: spriteContainer
                property: "scale"
                from: 1.0
                to: 1.1
                duration: 300
                easing.type: Easing.OutQuad
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: spriteContainer
                property: "y"
                from: -20
                to: 0
                duration: 300
                easing.type: Easing.InQuad
            }
            NumberAnimation {
                target: spriteContainer
                property: "scale"
                from: 1.1
                to: 1.0
                duration: 300
                easing.type: Easing.InQuad
            }
        }
    }

    // Window state management
    onVisibilityChanged: {
        console.log("Window visibility changed to:", visibility)
        if (visibility === Window.Hidden) {
            // Window is hidden, but keep running
            console.log("Desktop elf hidden")
        } else if (visibility === Window.Windowed) {
            console.log("Desktop elf visible")
        }
    }

    onXChanged: console.log("Window X position changed to:", x)
    onYChanged: console.log("Window Y position changed to:", y)

    Component.onCompleted: {
        console.log("Desktop elf main window loaded")
        console.log("Initial sprite position:", spriteController.position)
        console.log("Screen size:", Screen.width, "x", Screen.height)

        // Ensure window is positioned within screen bounds
        var posX = spriteController.position.x
        var posY = spriteController.position.y

        // Clamp position to screen bounds
        posX = Math.max(0, Math.min(posX, Screen.width - width))
        posY = Math.max(0, Math.min(posY, Screen.height - height))

        x = posX
        y = posY

        console.log("Window positioned at:", x, y)
        console.log("Window visible:", visible)

        // Explicitly show the window
        show()
    }
}
