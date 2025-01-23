FROM frappe/erpnext:version-15

USER root

# 安装必要工具并解析 APPS_JSON_BASE64
RUN apt-get update && apt-get install -y git jq && \
    echo "$APPS_JSON_BASE64" | base64 -d > /home/frappe/apps.json && \
    echo "解析后的 apps.json 内容：" && cat /home/frappe/apps.json && \
    # 循环克隆 apps.json 中的应用
    for app in $(jq -c '.[]' /home/frappe/apps.json); do \
        url=$(echo $app | jq -r '.url'); \
        branch=$(echo $app | jq -r '.branch'); \
        echo "正在克隆应用 $url (分支: $branch)" && \
        git clone --depth 1 -b $branch $url /home/frappe/frappe-bench/apps/$(basename $url .git) || exit 1; \
    done && \
    # 调整权限并构建
    chown -R frappe:frappe /home/frappe/frappe-bench/apps && \
    su frappe -c "bench build" && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8000/api/method/ping || exit 1

USER frappe
WORKDIR /home/frappe/frappe-bench
