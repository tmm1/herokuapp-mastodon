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
```

#### App

Create the app and addons:

```
$ heroku create mastodon-test --manifest
```

Generate secrets:

```
$ heroku config:set OTP_SECRET=$(docker run --rm -it tootsuite/mastodon:latest bin/rake secret)
$ heroku config:set SECRET_KEY_BASE=$(docker run --rm -it tootsuite/mastodon:latest bin/rake secret)
$ heroku config:set $(docker run --rm -e OTP_SECRET=placeholder -e SECRET_KEY_BASE=placeholder -it tootsuite/mastodon:latest bin/rake mastodon:webpush:generate_vapid_key | xargs)
```

