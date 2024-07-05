set -eu

API_KEY="$(yq -r .auth.apikey "$CONFIG_DIR/config/config.yaml")"

HTTP_CODE=$(curl \
    -H 'accept: application/json' \
    -H "X-Api-Key: $API_KEY" \
    -o /dev/stderr \
    -w '%{http_code}\n' \
    http://localhost:$PORT/api/system/status)

exec test $HTTP_CODE -eq 200
