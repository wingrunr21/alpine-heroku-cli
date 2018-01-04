FROM node:8.8.0-alpine
MAINTAINER Stafford Brunk <stafford.brunk@gmail.com>
LABEL version='6.14.43'
LABEL description='Heroku CLI packaged on alpine linux'

ENV HEROKU_CLI_VERSION '6.14.43'
RUN yarn global add heroku-cli@$HEROKU_CLI_VERSION

ENTRYPOINT ["/usr/local/bin/heroku"]
