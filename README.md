# cakephp_dev

A development environment for PHP CakePHP framework program : PHPのCakePHPフレームワークを使ったプログラムを開発する環境を用意するときの雛形として利用するために、いくつかスクリプトなどを用意して、まとめたものです。基本的にCakePHPのサンプルプログラムを動かせるように環境を用意しています。

まず、PHPの開発ではComposerを使うのが当たり前になってきているので、その用意をします。使っているOSでcomposerコマンドが実行できるようにするか、./composer にあるスクリプトを使って ${HOME}/.local/bin/composer を用意します。これはdocker・docker-composeを利用して [Composer · GitHub](https://github.com/composer) にある docker イメージを使います。docker・docker-compose は、あらかじめインストールしておく必要があります。

CakePHPの2020-08-20時点での最新版は4です。[ようこそ \- 4\.x](https://book.cakephp.org/4/ja/index.html) に従ってサンプルのアプリは用意できます。なお、CakePHP3 の方を使いたい場合は、[インストール \- 3\.9](https://book.cakephp.org/3/ja/installation.html) を参照すると良いでしょう。

ここでは、app4 に CakePHP4、app3 に CakePHP3 のアプリ用プロジェクトを作成します。

## 動作環境

下記の環境で動作確認をしています。

- Ubuntu 18.04
- docker version 19.03.12
- docker-compose version 1.25.3

```console
$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.5 LTS"
$ docker --version
Docker version 19.03.12, build 48a66213fe
$ docker-compose --version
docker-compose version 1.25.3, build d4d1b42b
```

## app4/app, app3/app の作成

app4 は次のようにして作成します。

```console
cd app4/
composer create-project --prefer-dist cakephp/app:4.* app
```

app3 は次のようにして作成します。

```console
cd app3/
composer create-project --prefer-dist cakephp/app:^3.9 app
```

## docker を使った動かし方

カレントディレクトリーを app4 または app3 にして作業をします。

### 動作環境の用意

Docker で PHP の環境を用意します。

まず、tool/create_env.sh をサンプルからコピーして用意します。tool/create_env.shで指定されている内容で環境を構築するので必要に応じて変更します。

```console
cp tool/create_env.sample.sh tool/create_env.sh
```

セットアップをします。

```console
sh tool/setup.sh
```

このsetup.shを使うことで、マウントしたディレクトリーの所有者を自分にするためのdockerイメージを作成できます。
また、php.ini、000-default.conf、my.cnf などをカスタマイズできるようにしてあります。

### 起動

次のコマンドで起動します。

```console
docker-compose up -d
```

### 必要なパッケージのインストール

最初に起動しただけだと動きません。dev_php7.4 のコンテナへログインして、composer コマンドで必要なパッケージをインストールします。 composer install は2回実行します。2回目の実行では postInstall が実行されます。Yを入力して進めます。

```console
$ docker exec -it -u $(id -u) dev_php7.4 bash
www-data@826abaddd8cd:~/html$ cd app
www-data@826abaddd8cd:~/html$ COMPOSER_HOME=/var/www/composer composer install
（略）
www-data@826abaddd8cd:~/html$ COMPOSER_HOME=/var/www/composer composer install
（略）
> App\Console\Installer::postInstall
（略）
Set Folder Permissions ? (Default to Y) [Y,n]? Y
www-data@826abaddd8cd:~/html$ exit
```

### 動作確認

下記にアクセスをして動作を確認します。

- <http://localhost:8080/> ... 稼働しているPHPの環境についての情報が表示されます。
- <http://localhost:8080/app/> ... CakePHP のページが表示されます。

### 停止

次のコマンドで停止します。

```console
docker-compose down
```
