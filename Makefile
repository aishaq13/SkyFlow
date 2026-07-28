.PHONY: build test up down smoke
build: ; mvn clean package
test: ; mvn test
up: build ; docker compose up --build -d
down: ; docker compose down -v
smoke: ; bash scripts/smoke-test.sh
