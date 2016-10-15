#!/bin/bash

# Make configurable
GROUP=ssh_bastion

readonly SCRIPT_NAME=$(basename "$0")

log() {
    echo "$@"
    logger -p user.notice -t "$SCRIPT_NAME" "$@"
}

# Delete users not in group?
# getent passwd | grep -v -e "/bin/false$" -e "bin/nologin$" -e "^root" -e "^sync"

aws iam get-group --group-name ${GROUP} --query 'Users[].[UserName]' --output text | while read -r User; do
  if id -u "$User" >/dev/null 2>&1; then
    echo "$User exists"
  else
    log "Adding user $User"
    /usr/sbin/adduser --disabled-password --gecos "" "$User"
  fi
done
