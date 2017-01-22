FROM mhart/alpine-node:base-6.2.1
MAINTAINER Stafford Brunk <stafford.brunk@gmail.com>
LABEL version='5.6.12'
LABEL description='Heroku CLI packaged on alpine linux'

ENV HEROKU_CLI_VERSION 'v5.6.12'
COPY setup_heroku_cli.sh /tmp
RUN /tmp/setup_heroku_cli.sh

ENTRYPOINT ["/usr/local/bin/heroku"]
