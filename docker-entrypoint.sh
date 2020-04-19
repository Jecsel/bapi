#!/bin/sh
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# echo "Waiting database"
# while ! nc -z mysql-server 3306; do sleep 0.1; done
# echo "Postgres is up"

# echo "Waiting for Redis to start..."
# while ! nc -z redis-server 6379; do sleep 0.1; done
# echo "Redis is up - execuring command"

exec bundle exec "$@"