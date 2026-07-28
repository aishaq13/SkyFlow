# SkyFlow — Airline Operations Recovery Simulator

SkyFlow is a portfolio-grade distributed systems project that models airline flight disruptions and automatically evaluates recovery options using simulated operational data. It does **not** use or claim access to any airline's internal systems.

## What it demonstrates

- Java 21 and Spring Boot microservices
- Kafka-based event processing
- Rule-based gate and aircraft reassignment
- PostgreSQL persistence with Flyway
- Redis-backed operational projections
- REST APIs, health checks, Docker, Kubernetes, and CI

## Services

| Service | Port | Responsibility |
|---|---:|---|
| operations-service | 8081 | Flights, gates, aircraft, disruptions, assignment updates |
| recovery-service | 8082 | Constraint filtering, recommendation scoring, audit history |
| query-service | 8083 | Redis-backed current operational status |

## Run locally

Requirements: Java 21, Maven 3.9+, Docker Desktop, Docker Compose.

```bash
mvn clean package
docker compose up --build -d
bash scripts/smoke-test.sh
```

Open health endpoints:

- `http://localhost:8081/actuator/health`
- `http://localhost:8082/actuator/health`
- `http://localhost:8083/actuator/health`

## Demo flow

1. `operations-service` seeds one scheduled flight, three gates, and three aircraft.
2. Submit a disruption through `POST /api/v1/flights/{id}/disruptions`.
3. Kafka delivers the disruption to `recovery-service`.
4. The recovery engine selects a compatible available gate and aircraft and calculates a projected delay.
5. The recommendation is persisted and published.
6. `operations-service` applies the recommendation and emits an operational update.
7. `query-service` stores the current flight view in Redis.

## Core constraints implemented

- Gate must be at the disrupted flight's departure airport.
- Gate must be available and compatible with the aircraft type.
- Replacement aircraft must be available at the correct airport.
- Aircraft availability must fall within the recovery window.
- Candidate score rewards lower projected delay.

## API examples

```bash
curl http://localhost:8081/api/v1/flights
curl http://localhost:8081/api/v1/gates
curl http://localhost:8081/api/v1/aircraft

curl -X POST http://localhost:8081/api/v1/flights/FLIGHT_ID/disruptions \
  -H 'Content-Type: application/json' \
  -d '{"delayMinutes":60,"reason":"simulated weather disruption"}'

curl http://localhost:8082/api/v1/recommendations/flight/FLIGHT_ID
curl http://localhost:8083/api/v1/status/FLIGHT_ID
```

## Repository layout

```text
common/              Shared events and DTOs
operations-service/  Operational source of truth
recovery-service/    Recovery rules and recommendations
query-service/       Redis projection/read API
k8s/                 Kubernetes deployment examples
docs/                Architecture documentation
scripts/              Smoke test
```

## Honest resume wording

> Developed a distributed airline operations simulator using Java, Spring Boot, Kafka, PostgreSQL, and Redis to model flight disruptions and evaluate rule-based gate and aircraft reassignment scenarios. Implemented event-driven services, persistent recommendation history, operational read models, health checks, Docker Compose, Kubernetes manifests, and automated CI.

Do not add performance numbers until you run and document repeatable benchmarks.
