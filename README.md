# Desktop Elf - 桌面精灵

一个可爱的桌面精灵应用程序，使用 Qt5 + QML + C++ 开发。

## 功能特性

- 🧚‍♀️ 可爱的桌面精灵显示
- 🎮 鼠标交互（拖拽移动、左键跳跃、右键菜单）
- ⏰ 整点自动移动功能
- ⚙️ 丰富的设置选项
- 📅 健身计划管理
- 🎨 自定义精灵图片和动画

## 系统要求

- Windows 10/11
- Qt 5.15.2 或更高版本
- MinGW64 编译器
- CMake 3.16 或更高版本

## 编译构建

### 方法一：使用构建脚本（推荐）

1. 确保 Qt5 和 MinGW64 已安装并添加到 PATH 环境变量
2. 双击运行 `build.bat` 脚本
3. 等待编译完成

### 方法二：手动构建

```bash
# 创建构建目录
mkdir build
cd build

# 配置项目
cmake .. -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release

# 编译
cmake --build . --config Release
```

## 运行应用

编译完成后，在 `build` 目录下会生成 `DesktopElf.exe` 文件：

```bash
cd build
DesktopElf.exe
```

## 使用说明

### 基本操作

- **拖拽移动**：按住鼠标左键拖拽精灵到任意位置
- **跳跃动画**：单击鼠标左键触发跳跃动画
- **右键菜单**：右键点击精灵显示功能菜单

### 右键菜单功能

- **设置**：打开设置窗口，配置精灵外观和行为
- **健身计划**：打开健身日历，管理每日健身计划
- **移动到...**：快速移动精灵到屏幕特定位置
- **动画**：控制精灵动画播放
- **隐藏**：临时隐藏精灵
- **退出**：关闭应用程序

### 设置选项

#### 基本设置
- **精灵图片**：选择自定义精灵图片文件
- **移动动画**：设置移动时的动画序列
- **跳跃动画**：设置跳跃时的动画序列
- **初始位置**：设置精灵启动时的位置

#### 外观设置
- **背景颜色**：调整精灵背景色
- **不透明度**：调整精灵透明度
- **字体颜色**：调整文字颜色
- **窗口置顶**：设置是否始终显示在最前

#### 定时器设置
- **启用定时器**：开启/关闭整点自动移动
- **整点报时**：开启/关闭整点提醒
- **下次触发**：显示下次自动移动时间

## 项目结构

```
DesktopElf/
├── src/                    # 源代码目录
│   ├── controllers/        # C++ 控制器类
│   │   ├── SpriteController.h/cpp    # 精灵控制器
│   │   ├── ConfigManager.h/cpp       # 配置管理器
│   │   ├── TimerManager.h/cpp        # 定时器管理器
│   │   └── FitnessManager.h/cpp      # 健身管理器
│   ├── qml/               # QML 界面文件
│   │   ├── main.qml       # 主窗口
│   │   ├── ContextMenu.qml # 右键菜单
│   │   ├── SettingsWindow.qml # 设置窗口
│   │   ├── FitnessCalendar.qml # 健身日历
│   │   └── CalendarCell.qml # 日历单元格
│   └── main.cpp           # 程序入口
├── resources/             # 资源文件
│   ├── config/           # 配置文件
│   └── images/           # 图片资源
├── CMakeLists.txt        # CMake 构建配置
├── resources.qrc         # Qt 资源文件
├── build.bat            # Windows 构建脚本
└── README.md            # 项目说明
```

## 自定义配置

应用程序的配置文件位于 `resources/config/default_config.json`，包含以下设置：

- 精灵图片路径
- 动画序列路径
- 窗口位置和外观
- 定时器设置
- 健身计划配置

## 开发说明

### 技术栈
- **Qt 5.15.2**：跨平台应用框架
- **QML**：声明式用户界面语言
- **C++17**：核心逻辑实现
- **CMake**：构建系统

### 架构设计
- **MVC 模式**：分离界面和逻辑
- **信号槽机制**：组件间通信
- **资源管理**：统一的资源文件管理
- **配置系统**：JSON 格式配置文件

## 许可证

本项目采用 MIT 许可证，详见 LICENSE 文件。

## 贡献

欢迎提交 Issue 和 Pull Request 来改进项目！

## 联系方式

如有问题或建议，请通过以下方式联系：
- GitHub Issues
- Email: support@desktopelf.com