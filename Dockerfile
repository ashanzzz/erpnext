FROM frappe/erpnext:version-15

COPY apps.json /tmp/apps.json

# 安装git（用于克隆apps）
RUN apt-get update && apt-get install -y git \
    && cd /home/frappe/frappe-bench/apps \
    && git clone --depth 1 -b version-15 https://github.com/frappe/hrms \
    && git clone --depth 1 -b version-15 https://github.com/frappe/payments \
    && cd /home/frappe/frappe-bench \
    && bench build \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
