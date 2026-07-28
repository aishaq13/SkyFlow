#!/usr/bin/env bash
set -euo pipefail
FLIGHT_ID=$(curl -fsS http://localhost:8081/api/v1/flights | python3 -c 'import sys,json;print(json.load(sys.stdin)[0]["id"])')
echo "Disrupting $FLIGHT_ID"
curl -fsS -X POST "http://localhost:8081/api/v1/flights/$FLIGHT_ID/disruptions" -H 'Content-Type: application/json' -d '{"delayMinutes":60,"reason":"simulated weather disruption"}' | python3 -m json.tool
sleep 5
curl -fsS "http://localhost:8082/api/v1/recommendations/flight/$FLIGHT_ID" | python3 -m json.tool
curl -fsS "http://localhost:8083/api/v1/status/$FLIGHT_ID" | python3 -m json.tool
