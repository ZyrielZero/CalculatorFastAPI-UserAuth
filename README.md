# FastAPI Calculator

A small web calculator built on FastAPI. The backend exposes four arithmetic
endpoints with Pydantic validation and structured logging; the frontend is a
single Jinja2-rendered page that calls them with fetch.

## Setup and Run (Docker Compose)

The stack runs three services: the FastAPI app, PostgreSQL 16, and pgAdmin 4.

```bash
docker compose up --build
```

| Service    | URL                    | Credentials                     |
|------------|------------------------|---------------------------------|
| Calculator | http://localhost:8000  | -                               |
| pgAdmin    | http://localhost:5050  | admin@example.org / admin       |
| PostgreSQL | localhost:5432         | postgres / postgres, db fastapi_db |

Inside pgAdmin, register the server with host `db` (the Compose service
name), not localhost.

### Local run without Docker

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
playwright install chromium
python main.py
```

## Database

`sql/module9_raw_sql.sql` contains the Module 9 SQL walkthrough: table
creation for a one-to-many users/calculations schema with an
`ON DELETE CASCADE` foreign key, inserts, single-table and join queries,
an update, a delete, and a cascade demonstration. Run it section by
section in the pgAdmin Query Tool against `fastapi_db`.

Screenshots of every step with output are in
`docs/Module9_SQL_Screenshots.pdf`.

## API

| Endpoint    | Method | Body                 | Success             | Error                          |
|-------------|--------|----------------------|---------------------|--------------------------------|
| `/add`      | POST   | `{"a": 1, "b": 2}`   | `{"result": 3}`     | `400 {"error": "..."}`         |
| `/subtract` | POST   | `{"a": 5, "b": 2}`   | `{"result": 3}`     | `400 {"error": "..."}`         |
| `/multiply` | POST   | `{"a": 2, "b": 3}`   | `{"result": 6}`     | `400 {"error": "..."}`         |
| `/divide`   | POST   | `{"a": 6, "b": 2}`   | `{"result": 3.0}`   | `400` on zero divisor          |

Malformed payloads (missing fields, non-numeric values) return 400 with an
`error` field via a custom validation handler.

## Tests

```bash
pytest                     # full suite: unit, integration, e2e
pytest tests/unit          # operations layer, 100% coverage enforced
pytest tests/integration   # endpoints via TestClient
pytest tests/e2e           # Playwright browser tests against a live server
```

The e2e fixture starts the app with the same interpreter running pytest and
uses Playwright's auto-waiting assertions, so results are stable locally
and in CI.

## CI

GitHub Actions runs all three suites on every push and pull request to main.
