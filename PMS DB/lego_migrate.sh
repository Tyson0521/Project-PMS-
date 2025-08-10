#!/bin/bash

# Flyway configuration
FLYWAY_CMD="./flyway"  # Change to "flyway" if installed globally
DB_URL="jdbc:postgresql://localhost:5432/PMS"
DB_USER="postgres"
DB_PASS="P@55word"

echo "🚀 Running Flyway migrations from ./migration folder..."
$FLYWAY_CMD -url="$DB_URL" -user="$DB_USER" -password="$DB_PASS" -locations=filesystem:./migration migrate

echo "✅ Migration completed."
