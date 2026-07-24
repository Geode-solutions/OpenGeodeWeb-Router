#!/usr/bin/env bash
set -uo pipefail

PARENT="${PARENT:?PARENT env var required}"
SERVICE_NAME="${K_SERVICE:?K_SERVICE env var required}"

delete_service() {
    echo "Flask appears down → Deleting service ${PARENT}/services/${SERVICE_NAME}"

    # Get an OAuth2 access token from the GCE/Cloud Run metadata server
    local token
    token=$(curl -s -H "Metadata-Flavor: Google" \
        "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" \
        | jq -r .access_token)

    if [ -z "$token" ]; then
        echo "Delete failed: could not obtain access token"
        return 1
    fi

    local http_code
    http_code=$(curl -s -o /tmp/delete_response.json -w "%{http_code}" \
        -X DELETE \
        -H "Authorization: Bearer ${token}" \
        "https://run.googleapis.com/v2/${PARENT}/services/${SERVICE_NAME}")

    if [[ "$http_code" == 2* ]]; then
        echo "Service deletion request accepted (HTTP ${http_code})"
    else
        echo "Delete failed (HTTP ${http_code}): $(cat /tmp/delete_response.json)"
    fi
}

while true; do
    sleep 30
    response=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "http://127.0.0.1/geode/health")
    echo "response ${response}"

    if [ "$response" != "200" ]; then
        delete_service
        break
    fi
done