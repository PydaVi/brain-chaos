#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-lab-app}"
REQUIRED_DEPLOYS=(web-frontend api-gateway orders-service catalog-service payments-mock redis)

echo "[1/6] Waiting for core deployments in namespace ${NAMESPACE}"
for deploy in "${REQUIRED_DEPLOYS[@]}"; do
  kubectl rollout status "deployment/${deploy}" -n "$NAMESPACE" --timeout=180s
  echo "  - deployment/${deploy} ready"
done

echo "[2/6] Waiting for postgres statefulset"
kubectl rollout status "statefulset/postgres" -n "$NAMESPACE" --timeout=240s
echo "  - statefulset/postgres ready"

POSTGRES_DB="$(kubectl get secret postgres-auth -n "$NAMESPACE" -o jsonpath='{.data.POSTGRES_DB}' | base64 -d)"
POSTGRES_USER="$(kubectl get secret postgres-auth -n "$NAMESPACE" -o jsonpath='{.data.POSTGRES_USER}' | base64 -d)"
POSTGRES_PASSWORD="$(kubectl get secret postgres-auth -n "$NAMESPACE" -o jsonpath='{.data.POSTGRES_PASSWORD}' | base64 -d)"

TS="$(date +%Y%m%d%H%M%S)"
ORDER_1="ORD-${TS}-001"
ORDER_2="ORD-${TS}-002"
USER_1="user_${TS}_alice@example.fake"
USER_2="user_${TS}_bob@example.fake"

echo "[3/6] Seeding synthetic data into postgres"
SQL="
CREATE TABLE IF NOT EXISTS synthetic_orders (
  id SERIAL PRIMARY KEY,
  order_code TEXT NOT NULL,
  user_email TEXT NOT NULL,
  amount_cents INT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
INSERT INTO synthetic_orders (order_code, user_email, amount_cents)
VALUES
  ('${ORDER_1}', '${USER_1}', 12990),
  ('${ORDER_2}', '${USER_2}', 4590);
SELECT COUNT(*) FROM synthetic_orders;
"

kubectl exec -n "$NAMESPACE" postgres-0 -- env PGPASSWORD="$POSTGRES_PASSWORD" \
  psql -h postgres -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 -c "$SQL"

echo "[4/6] Seeding synthetic cache data into redis"
REDIS_KEY="synthetic:session:${TS}"
REDIS_VAL="token_fake_${TS}_abc123"
kubectl exec -n "$NAMESPACE" deploy/redis -- redis-cli SET "$REDIS_KEY" "$REDIS_VAL"
ACTUAL_REDIS_VAL="$(kubectl exec -n "$NAMESPACE" deploy/redis -- redis-cli GET "$REDIS_KEY" | tr -d '\r')"
if [[ "$ACTUAL_REDIS_VAL" != "$REDIS_VAL" ]]; then
  echo "Redis validation failed: expected '${REDIS_VAL}', got '${ACTUAL_REDIS_VAL}'"
  exit 1
fi

echo "[5/6] Validating internal HTTP service reachability"
kubectl run e2e-http-check -n "$NAMESPACE" --restart=Never --rm -i \
  --image=curlimages/curl:8.12.1 --command -- sh -ceu '
    for svc in web-frontend api-gateway orders-service catalog-service payments-mock; do
      code=$(curl -s -o /tmp/body.txt -w "%{http_code}" "http://${svc}")
      echo "${svc}: HTTP ${code}"
      if [ "$code" -ne 200 ]; then
        echo "HTTP check failed for ${svc}"
        cat /tmp/body.txt
        exit 1
      fi
    done
  '

echo "[6/6] Verifying postgres records inserted"
ROW_COUNT="$(kubectl exec -n "$NAMESPACE" postgres-0 -- env PGPASSWORD="$POSTGRES_PASSWORD" \
  psql -h postgres -U "$POSTGRES_USER" -d "$POSTGRES_DB" -t -A -c "SELECT COUNT(*) FROM synthetic_orders;")"

if [[ -z "$ROW_COUNT" || "$ROW_COUNT" -lt 2 ]]; then
  echo "Postgres validation failed: expected at least 2 rows in synthetic_orders, got '${ROW_COUNT}'"
  exit 1
fi

echo "E2E synthetic validation passed."
echo "  - postgres rows in synthetic_orders: ${ROW_COUNT}"
echo "  - redis key: ${REDIS_KEY}"
echo "  - services: web-frontend/api-gateway/orders-service/catalog-service/payments-mock reachable"
