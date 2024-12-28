# 使用 ERPNext v15 作为基础镜像
FROM frappe/erpnext:version-15

# 切换到 frappe 用户
USER frappe

# 设置工作目录
WORKDIR /home/frappe/frappe-bench

# 复制应用配置文件
COPY apps.json /home/frappe/frappe-bench/sites/apps.json

# 安装应用
RUN cd /home/frappe/frappe-bench && \
    echo "初始化环境..." && \
    echo "克隆 HRMS..." && \
    git clone --depth 1 -b version-15 https://github.com/frappe/hrms apps/hrms && \
    echo "克隆 Payments..." && \
    git clone --depth 1 -b version-15 https://github.com/frappe/payments apps/payments && \
    echo "安装依赖..." && \
    pip install --no-cache-dir -e "apps/hrms[develop]" && \
    pip install --no-cache-dir -e "apps/payments[develop]" && \
    echo "更新应用列表..." && \
    echo 'frappe\nerpnext\nhrms\npayments' > sites/apps.txt && \
    echo "构建资源..." && \
    bench build

# 添加构建信息
LABEL maintainer="ashanzzz" \
      version="15" \
      description="Custom ERPNext image with HRMS and Payments apps" \
      apps="erpnext,hrms,payments"

# 设置默认命令
CMD ["bench", "start"]
