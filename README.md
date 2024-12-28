# Custom ERPNext Docker Image

这是一个包含 HRMS 和 Payments 应用的自定义 ERPNext Docker 镜像。

## 包含的应用

- ERPNext (version-15)
- HRMS (version-15)
- Payments (version-15)

## 构建状态

[![构建并推送Docker镜像](https://github.com/ashanzzz/erpnext/actions/workflows/docker-build.yml/badge.svg)](https://github.com/ashanzzz/erpnext/actions/workflows/docker-build.yml)

## 使用方法

```bash
# 拉取镜像
docker pull ghcr.io/ashanzzz/erpnext:version-15

# 使用 docker-compose
version: "3"
services:
  erpnext:
    image: ghcr.io/ashanzzz/erpnext:version-15
    ...
