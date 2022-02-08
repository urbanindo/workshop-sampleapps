#!/bin/bash

#Abort script at first error
# set -ex

CI_STAGE=$1
CMD_PATH=$2
BRANCH_NAME=$3
PUSH=$4


_main() {
    _setup_tools
    _init
    _set_env_name
    case $CI_STAGE in
        version|v)
            _version
            ;;
        test)
            _run_test
            ;;
        build-base)
            _build_base
            ;;
        build)
            _build
            ;;
        *)
            _usage
            ;;
    esac
}

_setup_tools() {
    echo "Install Gcloud"
    gcloud version || true
    if [ ! -d "$HOME/google-cloud-sdk/bin" ]
    then
        rm -rf $HOME/google-cloud-sdk
        export CLOUDSDK_CORE_DISABLE_PROMPTS=1
        curl https://sdk.cloud.google.com | bash > /dev/null # Silence gcloud installation
    fi
    # Add gcloud to $PATH
    source /home/travis/google-cloud-sdk/path.bash.inc
    gcloud version
}

_set_env_name() {
    if [[ "$BRANCH_NAME" == master ]]; then
        ENV_NAME=prod
    elif [[ "$BRANCH_NAME" == release ]]; then
        ENV_NAME=release
    elif [[ "$BRANCH_NAME" == develop ]]; then
        ENV_NAME=develop
    else
        ENV_NAME=$BRANCH_NAME-develop
    fi
}

_validation() {
    if [[ -z $CI_STAGE ]] || [[ -z $CMD_PATH ]] || [[ -z $BRANCH_NAME ]];
        then
            echo "[error] -- not enough arguments"
            echo "Usage : $0 build CMD_PATH ENV_NAME"
            exit 1
    fi    
}

_build_base() {
    _auth_gcr
    case "$BUILD_BASE" in
    true)
        #set build_base=true in .env file to force build base image
        echo "[info] -- build and push docker base image $DOCKER_IMAGE:$IMAGE_TAG_BASE"
        docker build -t $DOCKER_IMAGE:$IMAGE_TAG_BASE . -f $DOCKERFILE_BASE
        docker push $DOCKER_IMAGE:$IMAGE_TAG_BASE
        ;;
    *)
        #default is detect changes on go.sum and go.mod files
        echo "[info] -- detect changes for docker base image $DOCKER_IMAGE:$IMAGE_TAG_BASE"
        go_sum=$(git diff --name-only HEAD^ | grep '^go.sum')
        go_mod=$(git diff --name-only HEAD^ | grep '^go.mod')
        [ -n "$go_sum" ] || [ -n "$go_mod" ] && \
            docker build -t $DOCKER_IMAGE:$IMAGE_TAG_BASE . -f $DOCKERFILE_BASE && \
            docker push $DOCKER_IMAGE:$IMAGE_TAG_BASE
            exit 0
        ;;
    esac
}

_build() {
    _validation
    _auth_gcr

    #set docker image tag
    APP_NAME=$(basename $CMD_PATH)
    IMAGE_VERSION=$(git rev-parse --short HEAD)-$(date +%y%m%d%H%M%S)
    IMAGE_TAG=$APP_NAME-$ENV_NAME-$IMAGE_VERSION

    echo "[info] -- building docker image for $DOCKER_IMAGE:$IMAGE_TAG"
    docker build -t $DOCKER_IMAGE:$IMAGE_TAG -f $DOCKERFILE . --build-arg CMD_PATH=$CMD_PATH

    case "$PUSH" in
    no-push)
        echo "[info] -- push image disabled"
        ;;
    *)
        echo "[info] -- pushing $DOCKER_IMAGE:$IMAGE_TAG"
        docker push $DOCKER_IMAGE:$IMAGE_TAG
        ;;
    esac
}

_auth_gcr() {
    cat build/ci/gcr-user-b64.enc | base64 -d > $GCR_USER
    gcloud auth activate-service-account gcr-user@core-v3-283604.iam.gserviceaccount.com --key-file=$GCR_USER
    gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://asia.gcr.io
}

# _setup_git_cred() {
#     echo "[info] -- setup git credential"
#     git config --global url.git@github.com:.insteadOf https://github.com/
#     cp config/.ssh/id_rsa ~/.ssh/id_rsa
#     printf "Host github.com\n\tStrictHostKeyChecking no\n\tIdentityFile ~/.ssh/id_rsa" > ~/.ssh/config
# }

_run_test() {
    # _setup_git_cred
    echo "[info] - running unit test"
    # make test
}

_init() {
    echo "[info] -- load .env config"
    if [[ -n $CI_CONFIG_DIR ]]; then
        CI_CONFIG=$CI_CONFIG_DIR
    else
        CI_CONFIG=.env
    fi
    export $(grep -v '^#' $CI_CONFIG | xargs)
}

_usage() {
    echo "Usage : $0 build CMD_PATH ENV_NAME"
    echo "====================================="
    echo "E.g : $0 build cmd/graphql develop"
    echo "====================================="
    echo "Available command : test, version, build, build-base"
}

_version() {
    echo "Version : 0.2.0"
}

_main "$@"; exit