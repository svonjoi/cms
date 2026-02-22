#!/usr/bin/env bash
set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load environment variables
if [ -f "$PROJECT_ROOT/.env" ]; then
    set -a
    source "$PROJECT_ROOT/.env"
    set +a
else
    echo "Error: .env file not found at $PROJECT_ROOT/.env" >&2
    exit 1
fi

# Validate required variables
if [ -z "${DOCKER_STACK_PATH:-}" ]; then
    echo "Error: DOCKER_STACK_PATH not set in .env" >&2
    exit 1
fi

# Build docker compose base command
COMPOSE_CMD="docker compose --env-file $DOCKER_STACK_PATH/.env.cms.local -f $DOCKER_STACK_PATH/docker-compose.yml"

# Execute command in php container
# Pass all arguments directly - no nested quoting needed
$COMPOSE_CMD exec php "$@"
