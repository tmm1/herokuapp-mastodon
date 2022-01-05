#!/bin/bash
set -e

./heroku-exec.sh || true

if [[ $DYNO == "web"* ]]; then
  exec foreman start -f Procfile.heroku
elif  [[ $DYNO == "worker"* ]]; then
  exec bundle exec sidekiq
elif  [[ $DYNO == "release"* ]]; then
  exec ./release.sh
fi
