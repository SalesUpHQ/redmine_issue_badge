#!/bin/bash
set -e
bundle install -j4 --without postgresql rmagick test
bundle exec rake generate_secret_token

bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:create && bundle exec rake db:migrate
bundle exec rake redmine:plugins:migrate

exec "$@"