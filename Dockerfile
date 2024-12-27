FROM frappe/erpnext:version-15

ARG APPS_JSON_BASE64

# bench 命令需要在特定目录下运行
WORKDIR /home/frappe/frappe-bench

# 安装步骤
RUN echo "${APPS_JSON_BASE64}" | base64 -d > /tmp/apps.json \
    # 创建新站点
    && bench new-site my-site.local \
        --admin-password=admin \
        --mariadb-root-password=admin \
    # 安装应用
    && bench --site my-site.local install-app hrms \
    && bench --site my-site.local install-app payments \
    # 设置为默认站点
    && bench use my-site.local
