#!/bin/bash

#exit on error
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

asdf install
bundle
yarn
bundle exec rails db:setup
bundle exec rails db:migrate
bundle exec rails db:seed
