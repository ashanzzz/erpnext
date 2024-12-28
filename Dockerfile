# 使用 ERPNext v15 作为基础镜像
FROM frappe/erpnext:version-15

# 切换到 frappe 用户
USER frappe

# 设置工作目录
WORKDIR /home/frappe/frappe-bench

# 复制应用配置文件
COPY apps.json /home/frappe/frappe-bench/sites/apps.json

# 分步安装应用
RUN set -ex; \
    echo "===== 开始安装过程 ====="; \
    \
    echo "1. 克隆应用源码"; \
    cd apps; \
    git clone --depth 1 -b version-15 https://github.com/frappe/hrms; \
    git clone --depth 1 -b version-15 https://github.com/frappe/payments; \
    cd ..; \
    \
    echo "2. 初始化应用列表"; \
    bench setup requirements --dev; \
    \
    echo "3. 安装 Python 依赖"; \
    pip install -e apps/hrms; \
    pip install -e apps/payments; \
    \
    echo "4. 更新应用列表"; \
    bench setup requirements; \
    bench setup system; \
    \
    echo "5. 初始化数据库"; \
    bench --site site1.local install-app hrms; \
    bench --site site1.local install-app payments; \
    \
    echo "6. 构建前端资源"; \
    cd /home/frappe/frappe-bench; \
    yarn install; \
    bench build; \
    \
    echo "===== 安装完成 =====";

# 添加构建信息
LABEL maintainer="ashanzzz" \
      version="15" \
      description="Custom ERPNext image with HRMS and Payments apps" \
      apps="erpnext,hrms,payments" \
      build-date="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# 设置默认命令
CMD ["bench", "start"]
