## Mastodon on Heroku, using Docker

[Mastodon](https://github.com/mastodon/mastodon) is a free, open-source social network server based on ActivityPub.

The Mastodon server is implemented a rails app, which relies on postgres and redis. It uses sidekiq for background jobs, along with a separate nodejs http streaming server.

Docker images: https://hub.docker.com/r/tootsuite/mastodon/

Dockerfile: https://github.com/mastodon/mastodon/blob/main/Dockerfile

docker-compose.yml: https://github.com/mastodon/mastodon/blob/main/docker-compose.yml

Heroku Docker Deploys: https://devcenter.heroku.com/categories/deploying-with-docker

### Setup

#### CLI

Setup your heroku account and CLI:

```
$ brew install heroku
$ heroku login
$ heroku update beta
$ heroku plugins:install @heroku-cli/plugin-manifest
$ heroku container:login
```

#### App

Create the app and addons:

```
$ heroku create mastodon-test --manifest
$ heroku config:set LOCAL_DOMAIN=mastodon-test.herokuapp.com
```

Generate secrets:

```
$ heroku config:set OTP_SECRET=$(docker run --rm -it tootsuite/mastodon:latest bin/rake secret)
$ heroku config:set SECRET_KEY_BASE=$(docker run --rm -it tootsuite/mastodon:latest bin/rake secret)
$ heroku config:set $(docker run --rm -e OTP_SECRET=placeholder -e SECRET_KEY_BASE=placeholder -it tootsuite/mastodon:latest bin/rake mastodon:webpush:generate_vapid_key | xargs)
```

#### Settings

##### Storage for uploaded user photos and videos

See [lib/tasks/mastodon.rake](https://github.com/mastodon/mastodon/blob/5ba46952af87e42a64962a34f7ec43bc710bdcaf/lib/tasks/mastodon.rake#L137) for environment variables available for Wasabi, Minio or Google Cloud Storage.

```
$ heroku config:set S3_ENABLED=true S3_BUCKET=bbb AWS_ACCESS_KEY_ID=xxx AWS_SECRET_ACCESS_KEY=yyy
```

##### Federation

```
$ heroku config:set LIMITED_FEDERATION_MODE=true
```

##### Outgoing email

```
$ heroku addons:create mailgun
$ heroku config | grep MAILGUN_
$ heroku config:set SMTP_SERVER= SMTP_LOGIN= SMTP_PASSWORD= SMTP_FROM_ADDRESS=
```

##### ElasticSearch (optional)

```
$ heroku addons:create bonsai
$ heroku config:get BONSAI_URL
$ heroku config:set ES_ENABLED=true ES_HOST= ES_PORT= ES_USER= ES_PASS=

```

#### Deploy

Push to heroku, to build container and deploy:
(Migrations will automatically be run as part of the release command.)

```
$ git push heroku
```
