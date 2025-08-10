#!/bin/bash

# Database connection details
DB_NAME="PMS"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"

echo "⚠️ Dropping all tables and functions in $DB_NAME..."

# Drop all tables
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "
DO \$\$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END;
\$\$;
"

# Drop all functions
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "
DO \$\$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT proname, oidvectortypes(proargtypes) args
              FROM pg_proc
              JOIN pg_namespace ns ON (pg_proc.pronamespace = ns.oid)
              WHERE ns.nspname = 'public') LOOP
        EXECUTE 'DROP FUNCTION IF EXISTS ' || quote_ident(r.proname) || '(' || r.args || ') CASCADE';
    END LOOP;
END;
\$\$;
"

echo "All tables and functions dropped."
