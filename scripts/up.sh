#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v kubectl >/dev/null; then
  echo "kubectl est requis" >&2
  exit 1
fi

kubectl apply -k "${ROOT}/k8s/base"
kubectl -n taskboard-obs rollout status deploy/prometheus --timeout=180s
kubectl -n taskboard-obs rollout status deploy/grafana --timeout=180s

echo
echo "Prometheus : kubectl -n taskboard-obs port-forward svc/prometheus 9090:9090"
echo "Grafana    : kubectl -n taskboard-obs port-forward svc/grafana 3000:3000"
echo "  (admin / admin — démo locale uniquement)"
echo
echo "Prérequis : API TaskBoard déjà déployée (namespace taskboard),"
echo "  voir https://github.com/Curtis736/taskboard-k8s"
