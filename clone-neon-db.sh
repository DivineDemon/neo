#!/usr/bin/env bash
#
# Clone a Neon (or any Postgres) database from SOURCE to TARGET.
# Transfers schema (tables, indexes, constraints) and all data.
#
# Usage:
#   SOURCE_DATABASE_URL="postgresql://..." TARGET_DATABASE_URL="postgresql://..." ./clone-neon-db.sh
#
# Or export the vars first:
#   export SOURCE_DATABASE_URL="postgresql://user:pass@host/source_db?sslmode=require"
#   export TARGET_DATABASE_URL="postgresql://user:pass@host/target_db?sslmode=require"
#   ./clone-neon-db.sh
#

set -e

# Prefer PostgreSQL 17 client if available (Neon runs Postgres 17)
if [ -x "/opt/homebrew/opt/postgresql@17/bin/pg_dump" ]; then
  export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
fi

if [ -z "$SOURCE_DATABASE_URL" ] || [ -z "$TARGET_DATABASE_URL" ]; then
  echo "Error: SOURCE_DATABASE_URL and TARGET_DATABASE_URL must be set."
  echo ""
  echo "Usage:"
  echo "  SOURCE_DATABASE_URL=\"postgresql://...\" TARGET_DATABASE_URL=\"postgresql://...\" ./clone-neon-db.sh"
  exit 1
fi

DUMP_FILE="${DUMP_FILE:-./neon-clone-dump.sql}"

echo "Dumping schema and data from source database..."
pg_dump "$SOURCE_DATABASE_URL" \
  --no-owner \
  --no-acl \
  --clean \
  --if-exists \
  -f "$DUMP_FILE"

echo "Restoring into target database..."
psql "$TARGET_DATABASE_URL" -f "$DUMP_FILE"

echo "Removing dump file..."
rm -f "$DUMP_FILE"

echo "Done. Source database has been cloned to target."
