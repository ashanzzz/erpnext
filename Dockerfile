FROM frappe/erpnext:version-15

# 复制配置文件
COPY apps.json /home/frappe/frappe-bench/sites/apps.json

# 安装和构建应用
RUN cd /home/frappe/frappe-bench \
    && bench get-app --skip-assets --branch version-15 https://github.com/frappe/hrms \
    && bench get-app --skip-assets --branch version-15 https://github.com/frappe/payments \
    && bench build

WORKDIR /home/frappe/frappe-bench
