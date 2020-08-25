#!/usr/bin/env bash

set -o pipefail
set -o errexit

if [ -z "$CI_JOB_ID" ]; then
    echo "CI_JOB_ID environment variable must be set"
    exit 1
fi

if [ -z "$SSH_PRIVATE_KEY" ]; then
    echo "SSH_PRIVATE_KEY environment variables must all be set";
    exit 2
fi

# Use Splunk internal module name
find . -name '*.go' | xargs sed -i 's/github\.com\/apache\/pulsar-client-go/cd\.splunkdev\.com\/streamlio\/pulsar-client-go/g' go.mod oauth2/go.mod

TAG=v0.1-$CI_JOB_ID

eval $(ssh-agent -s)
git config user.name "Streamlio CI"
git config user.email "ssg-streamlio@splunk.com"

git commit -am "Committing version $TAG"
git tag $TAG -m "Tag for $TAG"
go-go tag

