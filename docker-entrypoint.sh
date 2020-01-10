#!/bin/sh

# Error function
die() { echo "error: $@" 1>&2 ; exit 1; }


if [ ! -z "$GIT_KEYFILE" ]
then
  [ ! -f "$GIT_KEYFILE" ] && die "Git clone key not found."

  eval $(ssh-agent -s)
  ssh-add ${GIT_KEYFILE}

  git config --global user.email "webhookd@bot.com"
  git config --global user.name "Webhookd bot"
fi

exec "$@"

