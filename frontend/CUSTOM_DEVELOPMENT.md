# 前端定制开发

## 仓库与基线

- 开发仓库：`D:\Documents\my_local_python\agent\weknora\WeKnora`。
- `origin`：`https://github.com/lmy138/WeKnora.git`，自己的仓库。
- `upstream`：`https://github.com/Tencent/WeKnora.git`，腾讯官方仓库。
- 当前开发分支：`custom/frontend`，从官方 `v0.8.3`（`3e22822c1`）建立。
- 原 `main` 保留在 `e8e0d2ed4`，需要查看原分支内容时可用 `git show main:<路径>`。
- 日常定制集中在 `frontend/`，保留完整仓库以便合并官方更新。

本次只建立本地分支，未创建提交，也未推送远程。首次发布自己的分支：

```powershell
git push -u origin custom/frontend
```

## 本地预览

现有 Docker 部署目录：`C:\Users\admin\mydocker\weknora`。
部署目录继续管理 `.env`、数据、部署覆盖配置和运行脚本；不要将其复制进开发仓库。

已部署官方页面：<http://localhost:8090>。
后端映射地址：<http://127.0.0.1:8091>。

首次启动，在 PowerShell 执行：

```powershell
cd D:\Documents\my_local_python\agent\weknora\WeKnora\frontend
npm.cmd ci
.\dev-local.ps1
```

以后执行 `.\dev-local.ps1` 即可。访问 <http://localhost:5173>，保存前端文件触发热更新，Ctrl+C 停止。
依赖锁文件变化后重新执行 `npm.cmd ci`。

脚本通过现有 Vite 配置将 `/api`、`/files`、`/mcp/` 转发到 Docker 后端，API WebSocket 也通过代理。
需要更换测试后端时：

```powershell
.\dev-local.ps1 -BackendUrl http://127.0.0.1:8091 -Port 5174
```

开发页面通常需要单独登录。它使用现有 Docker 数据库，上传、删除、配置修改均会影响真实数据，请使用测试账号和测试知识库。
单点登录回调、嵌入策略以及生产 Nginx 行为还需在容器入口验收。

## 跟随官方升级

先提交或妥善保存当前改动，再在仓库根目录执行（将标签替换为实际目标版本）：

```powershell
git fetch upstream --tags
git switch custom/frontend
git merge <目标官方release标签>
```

解决前端冲突后，备份部署数据及配置，再将 Docker 后端和配套服务升级到对应官方版本。
不要直接把自己的分支重置成 upstream，也不要用开发目录覆盖部署目录。

验证登录、上传、检索、流式回答及定制页面。阶段验收时构建独立命名的自定义前端镜像，保留可回退版本。
后端升级可能包含数据库迁移，回退方案需同时覆盖数据库与文件。

当前未修改部署目录，也未新增容器验收入口；本地预览需先安装依赖并启动 Vite。
