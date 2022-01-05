FROM tootsuite/mastodon:v3.4.4 AS base

# add extra packages
USER root
RUN mkdir -p /var/cache/apt && \
    apt-get update && \
    apt-get -y --no-install-recommends install \
	  bash curl nginx openssh iproute2 python && \
	apt-get clean
RUN gem install foreman
RUN rm -f /etc/nginx/sites-available/default /etc/nginx/modules-available/* && \
    mkdir -p /run/nginx/{temp,log} && \
    chown -R mastodon:mastodon /run/nginx && \
    rm -rf /var/lib/nginx /var/log/nginx && \
    ln -nsf /run/nginx/temp /var/lib/nginx && \
    ln -nsf /run/nginx/log /var/log/nginx
RUN rm -rf .env .env.production && touch .env .env.production
RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh

# copy over our extra stuff
COPY --chown=mastodon:mastodon Procfile* nginx* release.sh /opt/mastodon/
RUN mkdir -p /opt/mastodon/cache/nginx && chown -R mastodon:mastodon /opt/mastodon/cache

# heroku ps:exec deps
RUN mkdir -p /app/.profile.d
COPY heroku-exec.sh /app/.profile.d/

FROM base AS frontend
USER mastodon
