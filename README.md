# Neo

## Cloning a Neon database to another account

This copies **schema** (tables, indexes, constraints) and **data** from one Neon database to another using standard PostgreSQL tools.

### Prerequisites

- **PostgreSQL client tools** installed: `pg_dump` and `psql`.
  - macOS (Homebrew): `brew install libpq` then ensure `pg_dump` and `psql` are on your `PATH` (e.g. `export PATH="/opt/homebrew/opt/libpq/bin:$PATH"`).
  - Or install full Postgres: `brew install postgresql`.

### Usage

1. Get the **direct** connection strings (not pooled) from both Neon projects:
   - Original (source): Neon Console → Connection details → **Direct connection**.
   - New (target): same for the target project.

2. Run the script with both URLs (do not commit these; they contain secrets):

```bash
SOURCE_DATABASE_URL="postgresql://user:password@ep-xxx.region.aws.neon.tech/source_db?sslmode=require" \
TARGET_DATABASE_URL="postgresql://user:password@ep-yyy.region.aws.neon.tech/target_db?sslmode=require" \
./clone-neon-db.sh
```

Or export and run:

```bash
export SOURCE_DATABASE_URL="postgresql://..."
export TARGET_DATABASE_URL="postgresql://..."
./clone-neon-db.sh
```

3. Optional: use a custom dump file path:

```bash
DUMP_FILE=/tmp/my-dump.sql SOURCE_DATABASE_URL="..." TARGET_DATABASE_URL="..." ./clone-neon-db.sh
```

### What gets copied

- All tables and their data  
- Indexes, constraints, sequences  
- Views (as definitions)

The script uses `--no-owner` and `--no-acl` so objects are owned by the user in the target database, which is what you want when moving between accounts.
