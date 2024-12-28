# 使用 ERPNext v15 作为基础镜像
# 这个镜像已经包含了基础的 frappe bench 环境和 ERPNext
FROM frappe/erpnext:version-15

# 复制应用配置文件到容器
# apps.json 定义了需要安装的应用列表
# 注意：这个文件的路径必须与 bench 命令的工作目录一致
COPY apps.json /home/frappe/frappe-bench/sites/apps.json

# 工作目录设置
# bench 命令需要在这个目录下执行才能正常工作
WORKDIR /home/frappe/frappe-bench

# 安装 HRMS 和 Payments 应用
# 这里使用 bench get-app 而不是 git clone，因为：
# 1. bench get-app 会自动处理依赖关系
# 2. 会正确设置应用文件的权限
# 3. 会更新 bench 的应用列表
RUN echo "开始安装应用..." && \
    echo "安装 HRMS..." && \
    bench setup requirements && \
    bench init-apps && \
    bench get-app --skip-assets --branch version-15 https://github.com/frappe/hrms && \
    echo "HRMS 安装完成" && \
    echo "安装 Payments..." && \
    bench get-app --skip-assets --branch version-15 https://github.com/frappe/payments && \
    echo "Payments 安装完成" && \
    echo "构建资源文件..." && \
    bench build && \
    echo "构建完成"

# 记录构建信息
LABEL maintainer="ashanzzz" \
      version="15" \
      description="Custom ERPNext image with HRMS and Payments apps" \
      apps="erpnext,hrms,payments" \
      build-date="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# 注意事项：
# 1. bench get-app 可能会因为网络问题失败，需要重试
# 2. --skip-assets 参数用于跳过资源构建，最后统一构建可以节省时间
# 3. bench build 需要在所有应用安装完成后执行
# 4. 如果构建失败，检查：
#    - apps.json 格式是否正确
#    - bench 环境是否正常
#    - 网络连接是否稳定
