#!/usr/bin/env bash

export AWS_PROFILE=${AWS_PROFILE:-default}
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-1}

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
SOURCE_DIR="$DIR/../source"
STACK_ENV=${STACK_ENV:-production}
STACK_NAME="atlas-image-handler-$STACK_ENV"

deploy_stack() {
    set -x
    aws cloudformation deploy \
        --no-fail-on-empty-changeset \
        --stack-name ${STACK_NAME} \
        --template-file "$DIR/atlas-image-handler.template" \
        --capabilities CAPABILITY_NAMED_IAM \
        --parameter-overrides \
        FunctionBucket=atlas-lambdas \
        FunctionBucketKeyPrefix=atlas-image-handler/${STACK_ENV} \
        SourceBuckets=att-atlas-files,att-atlas-staging-files \
        BasePath=/image-handler
}

build() {
    set -x
    cd ${SOURCE_DIR}/image-handler
    npm install
    npm run build

    aws s3 cp dist/image-handler.zip s3://atlas-lambdas-us-east-1/atlas-image-handler/${STACK_ENV}/ --acl bucket-owner-full-control
}

update_code() {
    aws lambda update-function-code \
      --function-name ${STACK_NAME} \
      --s3-bucket atlas-lambdas-${AWS_DEFAULT_REGION} \
      --s3-key atlas-image-handler/${STACK_ENV}/image-handler.zip
}

action=${1:-"deploy_stack"}
if [[ "$action" == "deploy_stack" ]]; then
    deploy_stack
    exit 0
fi

if [[ "$action" == "build" ]]; then
    build
    exit 0
fi

if [[ "$action" == "update" ]]; then
    update_code
    exit 0
fi

echo "Usage: ./atlas-deploy.sh deploy_stack|build|update"
