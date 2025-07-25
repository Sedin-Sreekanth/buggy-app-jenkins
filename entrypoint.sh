#!/bin/bash
set -e


echo ">>> ENTRYPOINT SCRIPT STARTED"

echo "Running database migrations..."
bundle exec rails db:migrate

echo "Starting Puma server..."
bundle exec puma -C config/puma.rb
