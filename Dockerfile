FROM frappe/erpnext:version-15

USER root

RUN mkdir -p /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get install -y git && \
    cd /home/frappe/frappe-bench/apps && \
    git clone --depth 1 -b version-15 https://github.com/frappe/hrms && \
    git clone --depth 1 -b version-15 https://github.com/frappe/payments && \
    cd /home/frappe/frappe-bench && \
    chown -R frappe:frappe /home/frappe/frappe-bench/apps/* && \
    su frappe -c "cd /home/frappe/frappe-bench && bench build" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /home/frappe/frappe-bench/apps/*/.git

# 添加健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8000/api/method/ping || exit 1

USER frappe
WORKDIR /home/frappe/frappe-bench
