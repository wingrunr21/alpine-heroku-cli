#!/bin/sh

apk add --no-cache git go make curl

export GOPATH=/go
PATH=$GOPATH/bin:$PATH
NODE_VERSION=$(node --version)
mkdir -p "$GOPATH"  "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Get godep and heroku cli
cd $GOPATH
go get github.com/tools/godep
go get github.com/heroku/cli

# Restore godeps
cd $GOPATH/src/github.com/heroku/cli
git checkout $HEROKU_CLI_VERSION
godep restore

# Mock out the node tgz so make build works correctly
mkdir -p "tmp/cache/node-${NODE_VERSION}"
mkdir -p "/tmp/node-${NODE_VERSION}-linux-x64/bin"
cp $(which node) "/tmp/node-${NODE_VERSION}-linux-x64/bin/node"
tar -C /tmp -czf "tmp/cache/node-v6.2.1/node-${NODE_VERSION}-linux-x64.tar.gz" "node-${NODE_VERSION}-linux-x64"

# Build and install
make build
touch /usr/local/bin/heroku # make install bombs without this
make install

# Cleanup
ln -fs $(which node) /usr/local/lib/heroku/lib/node
apk del git go make curl busybox
rm -rf /tmp/* /go /var/cache/apk/* /usr/share/man /tmp/* /root/.npm /root/.node-gyp

# Cleanup excess NPM stuff
cd /usr/local/lib/heroku/lib/npm
rm -rf man doc html *.md *.bat *.yml changelogs scripts test AUTHORS LICENSE Makefile
cd /usr/local/lib/heroku/lib
find . -name test -o -name .bin -type d  | xargs rm -rf
