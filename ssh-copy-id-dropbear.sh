#!/bin/sh

if [ "$#" -ne 1 ]; then
  echo "Example: ${0} root@192.168.1.1"
  exit 1
fi

cat ~/.ssh/id_rsa.pub | ssh ${1} "cat >> /etc/dropbear/authorized_keys && chmod 0600 /etc/dropbear/authorized_keys && chmod 0700 /etc/dropbear"
