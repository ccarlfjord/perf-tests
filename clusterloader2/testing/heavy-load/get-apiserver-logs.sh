#!/bin/bash

set -euo pipefail

kubectl --namespace kube-system \
        logs \
        --selector component=kube-apiserver \
        --tail -1 \
        --prefix |
        grep -vE 'audit|TLS handshake error|Auditing failed|the object has been modified|failed to retrieve openAPI'
