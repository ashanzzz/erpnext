FROM frappe/erpnext:version-15

ARG APPS_JSON_BASE64
# 修改安装命令路径，使用完整路径
RUN echo "${APPS_JSON_BASE64}" | base64 -d > /tmp/apps.json \
    && bench install-app hrms \
    && bench install-app payments
