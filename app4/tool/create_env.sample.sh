#!/bin/sh
if [ -z ${BASE_DIR} ]; then
  BASE_DIR=$(cd $(dirname $0)/..;pwd)
fi
echo "BASE_DIR=${BASE_DIR}"

echo "HOST_USER_ID=$(id -u)" > ${BASE_DIR}/.env
echo "HOST_GROUP_ID=$(id -g)" >> ${BASE_DIR}/.env
cat << EOS >> ${BASE_DIR}/.env
MYSQL_ROOT_PASSWORD=secret
MYSQL_DATABASE=app
MYSQL_USER=user001
MYSQL_PASSWORD=pass001
EOS
