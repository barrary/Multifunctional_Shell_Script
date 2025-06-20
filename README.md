```
# Multifunctional Shell Script

[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 项目简介

`Multifunctional_Shell_Script` 是一个集成多种实用功能的 Linux Shell 脚本集合，旨在帮助运维和开发人员快速完成服务管理、文件备份、系统巡检、端口检查等常见任务。

本项目包含一个整合型主脚本（`Multifunctional_Script.sh`），以及若干功能模块拆分脚本，支持灵活调用和二次开发。

---

## 目录结构
```

.
 ├── Multifunctional_Script.sh       # 主入口整合脚本，包含全部功能
 ├── MANAGE_SERVICE.sh               # 服务管理功能模块（启动、停止、重启、状态查询）
 ├── BACKUP_FILES.sh                 # 文件与目录备份模块
 ├── SYSTEM_INSPECTION.sh            # 系统巡检功能模块（主机名、OS版本、CPU、内存、磁盘等）
 ├── PORT_CHECK.sh                   # 端口监听检查模块
 ├── main.sh                        # 备用测试或演示脚本
 ├── README.md                      # 项目说明文档（你正在阅读的文件）
 └── LICENSE                       # 开源许可证文件

```
## 功能介绍

### 1. 服务管理（`MANAGE_SERVICE.sh`）

- 支持通过 `systemctl` 启动、停止、重启、查看状态服务。
- 交互式输入操作类型和服务名。

### 2. 文件备份（`BACKUP_FILES.sh`）

- 交互式指定备份源文件/目录及目标路径。
- 支持递归备份并反馈备份状态。

### 3. 系统巡检（`SYSTEM_INSPECTION.sh`）

- 采集当前主机名、操作系统版本、登录用户、网卡IP、CPU和内存信息、磁盘使用情况。
- 格式化输出，方便快速了解系统健康状态。

### 4. 端口检查（`PORT_CHECK.sh`）

- 输入端口号，检测是否被监听。
- 支持 TCP 和 UDP 端口监听状态查询。

### 5. 主入口脚本（`Multifunctional_Script.sh`）

- 集成以上所有模块。
- 提供统一交互菜单，用户根据选项快速调用对应功能。

---
```

## 快速开始

1. 克隆仓库

```
git clone https://github.com/barrary/Multifunctional_Shell_Script.git
cd Multifunctional_Shell_Script
```

2. 赋予脚本执行权限

```
chmod +x *.sh
```

3. 运行主入口脚本

```
./main.sh
```

4. 按照菜单提示操作即可

## 模块化设计理念

本项目采用了“整合+拆分”相结合的设计：

- **整合脚本**：`Multifunctional_Script.sh` 集成所有功能，方便一站式使用。
- **功能模块拆分**：各功能拆分为独立脚本，方便单独维护、复用和二次开发。

你可以直接使用主入口，也可以将模块脚本嵌入你自己的自动化流程中。

------

## 适用环境

- Linux 系统（CentOS、Ubuntu 等均适用）
- 需有 `bash` 环境
- 依赖基础系统命令：`systemctl`、`cp`、`ip`、`netstat`、`free`、`df` 等

------

## 贡献指南

欢迎提交 Issues 和 Pull Requests：

- 请确保代码风格统一，注释清晰
- 功能扩展或 Bug 修复请详细描述
- 任何问题或建议均欢迎交流

------

## 许可证

本项目采用 MIT 许可证，详见 LICENSE。

------

## 作者

```
barrary
```