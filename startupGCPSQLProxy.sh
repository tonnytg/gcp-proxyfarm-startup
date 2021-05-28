#!/bin/bash
[[ $1 == "-d" ]] && set -x; date || echo

# VARS
BUCKET="mbp-de-antonio"

# FUNC
newHash() {
    echo `gsutil stat gs://${BUCKET}/exemplo01.c | grep md5 | awk '{print $3}'`> /tmp/NHASH.lock
}

checkHash() {
    newHash
    cp /tmp/NHASH.lock /tmp/OHASH.lock
}

download() {
    checkHash
    while [ ! -f /usr/local/bin/cloud_sql_proxy ]
    do
        curl -s https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -o /usr/local/bin/cloud_sql_proxy
        chmod +x /usr/local/bin/cloud_sql_proxy
        [[ $? -eq 0 ]] && echo "Download obtido:`date`"
        sleep 15
    done
}

getConf() {
    gsutil cp gs://${BUCKET}/${BUCKET}.conf /tmp/
}

proxyRun() {
    echo "Proxy Running"
    for LINE in $(cat /tmp/${BUCKET}.conf);
    do
        /usr/local/bin/cloud_sql_proxy -h | head -n2
    done
}

# RUNNING
[[ -f /tmp/NHASH.lock ]] && echo || download
newHash
[[ $(cat /tmp/NHASH.lock) == $(cat /tmp/OHASH.lock) ]] && echo 1 || checkHash