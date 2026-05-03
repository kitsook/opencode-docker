#!/bin/sh
set -e

# The container starts as the user defined in the Dockerfile.
# We just need to ensure the entrypoint passes the command.

exec "$@"
