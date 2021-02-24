#!/bin/bash

set -euo pipefail

KUBECONFIG="${KUBECONFIG:-"${HOME}/.kube/config"}"

delete_report_dir() {
  if [[ ! -d ./report/ ]]; then
    return
  fi

  read -rp "./report/ exists, do you want to delete it (Y/n)? " delete_report
  echo
  if [[ ! $delete_report =~ ^[Yy]$|^$ ]]; then
    rm -rf ./report/
  fi
}

run_suite() {
  local nodes=10
  if [[ $# -gt 0 ]]; then
    nodes="$1"
  fi

  go run cmd/clusterloader.go \
    --kubeconfig="${KUBECONFIG}" \
    --provider local \
    --enable-exec-service=false \
    --alsologtostderr \
    --testsuite=testing/heavy-load/suite.yaml \
    --report-dir report/ \
    --nodes "${nodes}"
}

main() {
  delete_report_dir
  run_suite "$@"
}

main "$@"
