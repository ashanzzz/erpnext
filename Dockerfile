FROM frappe/erpnext:version-15

COPY apps.json /tmp/apps.json

# 切换到root用户进行安装
USER root

# 安装git和必要工具
RUN mkdir -p /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get install -y git && \
    cd /home/frappe/frappe-bench/apps && \
    git clone --depth 1 -b version-15 https://github.com/frappe/hrms && \
    git clone --depth 1 -b version-15 https://github.com/frappe/payments && \
    cd /home/frappe/frappe-bench && \
    chown -R frappe:frappe /home/frappe/frappe-bench/apps/* && \
    sudo -H -u frappe bash -c "bench build" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 切换回frappe用户
USER frappe

# 设置工作目录
WORKDIR /home/frappe/frappe-bench
