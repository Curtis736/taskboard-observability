# TaskBoard — observabilité (Prometheus + Grafana, kind)

[![CI](https://github.com/Curtis736/taskboard-observability/actions/workflows/validate.yml/badge.svg)](https://github.com/Curtis736/taskboard-observability/actions)
[![Licence](https://img.shields.io/badge/licence-MIT-blue.svg)](LICENSE)

Produit **TaskBoard** · scrape de [`taskboard-api`](https://github.com/Curtis736/taskboard-api) (`GET /metrics`) dans un cluster **kind**. Pas d’EKS, pas de stack cloud payante. Les logs ECS / CloudWatch restent dans [`aws-ecs-terraform`](https://github.com/Curtis736/aws-ecs-terraform).

Manifests Kustomize : Prometheus (service discovery Kubernetes, rétention 24 h) et Grafana provisionné (datasource + dashboard). CI : `kubeconform` + `promtool check config`.

## Lancer en local

```bash
# 1. Cluster + API (repo voisin)
cd ../taskboard-k8s && ./scripts/kind-up.sh

# 2. Observabilité
cd ../taskboard-observability
chmod +x scripts/up.sh
./scripts/up.sh

kubectl -n taskboard-obs port-forward svc/prometheus 9090:9090
kubectl -n taskboard-obs port-forward svc/grafana 3000:3000
```

Grafana : http://127.0.0.1:3000 (admin / admin, démo locale). Dashboard **TaskBoard API**.

Cible scrape : Service `taskboard-api` dans le namespace `taskboard` (port `http`).

## Architecture

```
kind
 ├── ns/taskboard          taskboard-api  ──/metrics──►
 └── ns/taskboard-obs      Prometheus ──► Grafana
```

Sur AWS, l’équivalent « logs + métriques managés » est CloudWatch (groupe de logs 7 jours dans `aws-ecs-terraform`) — volontairement pas de second control plane.

## CI

Pas de cluster en Actions. Pas de secrets AWS.

## Suite TaskBoard

| Couche | Dépôt |
| --- | --- |
| UI (S3 + CloudFront) | [s3-static-site](https://github.com/Curtis736/s3-static-site) |
| API | [taskboard-api](https://github.com/Curtis736/taskboard-api) |
| Kubernetes | [taskboard-k8s](https://github.com/Curtis736/taskboard-k8s) |
| GitOps | [taskboard-gitops](https://github.com/Curtis736/taskboard-gitops) |
| Observabilité | ce dépôt |
| ECS / VPC | [aws-ecs-terraform](https://github.com/Curtis736/aws-ecs-terraform) |
| Modules Terraform | [taskboard-terraform-modules](https://github.com/Curtis736/taskboard-terraform-modules) |
| CI réutilisable | [taskboard-actions](https://github.com/Curtis736/taskboard-actions) |

## Licence

MIT — voir [LICENSE](LICENSE).
