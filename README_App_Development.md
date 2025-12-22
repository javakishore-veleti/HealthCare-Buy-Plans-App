# Application (App) Development Notes

## Available Commands

Run these commands from the repository root folder.

### Angular UI

| Command | Description |
|---------|-------------|
| `npm run ui:install` | Install Angular dependencies |
| `npm run ui:start` | Start Angular app (opens browser at http://localhost:4200) |
| `npm run ui:build` | Build for development |
| `npm run ui:build:prod` | Build for production |
| `npm run ui:test` | Run unit tests |
| `npm run ui:lint` | Run linting |

### Django Backend

| Command | Description |
|---------|-------------|
| `npm run api:install` | Install Python dependencies |
| `npm run api:migrate` | Run database migrations |
| `npm run api:start` | Start Django server (http://localhost:8000) |
| `npm run api:createsuperuser` | Create admin user |
| `npm run api:shell` | Open Django shell |

### Docker Services

| Command | Description |
|---------|-------------|
| `npm run docker:mysql:start` | Start MySQL + phpMyAdmin |
| `npm run docker:mysql:stop` | Stop MySQL |
| `npm run docker:postgres:start` | Start PostgreSQL + pgAdmin |
| `npm run docker:postgres:stop` | Stop PostgreSQL |
| `npm run docker:wiremock:start` | Start WireMock (mock payment gateway) |
| `npm run docker:wiremock:stop` | Stop WireMock |
| `npm run docker:status` | Show running containers |

### Liquibase (Database Migration)

| Command | Description |
|---------|-------------|
| `npm run db:migrate` | Apply pending database changes |
| `npm run db:rollback` | Rollback last change |
| `npm run db:status` | Show pending changes |

### Quick Start

| Command | Description |
|---------|-------------|
| `npm run setup` | First-time setup (install all dependencies) |
| `npm run start` | Start Angular app |
| `npm run dev:ui` | Start Angular app |
| `npm run dev:api` | Start Django server |

### Django Admin UI Credentials
- admin@admin.com
- admin
