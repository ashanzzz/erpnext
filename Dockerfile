FROM frappe/erpnext:version-15

ARG APPS_JSON_BASE64
RUN echo "${APPS_JSON_BASE64}" | base64 -d > /tmp/apps.json \
    && install-apps
