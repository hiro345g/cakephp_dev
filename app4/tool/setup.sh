#!/bin/sh

if [ -z ${BASE_DIR} ]; then
  BASE_DIR=$(cd $(dirname $0)/..;pwd)
fi
echo "BASE_DIR=${BASE_DIR}"

# docker_template/* のコピー
cp -r ${BASE_DIR}/../docker_template/* ${BASE_DIR}/

# .env 作成
if [ ! -e ${BASE_DIR}/tool/create_env.sh ]; then
  cp ${BASE_DIR}/tool/create_env.sample.sh ${BASE_DIR}/tool/create_env.sh
fi
sh ${BASE_DIR}/tool/create_env.sh

# 000-default.confの用意
cp ${BASE_DIR}/php7.4/etc/apache2/sites-available/000-default.sample.conf \
   ${BASE_DIR}/php7.4/etc/apache2/sites-available/000-default.conf

# コンテナ停止 
cd ${BASE_DIR}
echo "docker-compose down"
docker-compose down
docker-compose rm -f

echo "docker-compose build"
for t in php7.4/var/log/apache2 php7.4/var/www/html/app php7.4/var/www/composer
do
  if [ ! -e ${BASE_DIR}/${t} ];then
    mkdir -p ${BASE_DIR}/${t}
  fi
done

cd ${BASE_DIR}
docker-compose build

echo "docker-compose up"
docker-compose up
