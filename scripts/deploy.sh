#!/bin/bash

APPLICATION=${application:-app}
BRANCH=${branch:-dev}
COMMIT=${commit:-default}
VERSION=${version:-v1.0}

WORKING_DIR=$APPLICATION-$BRANCH-$COMMIT

GIT_CONFIG_URI=$GIT_CONFIG_URI
MANAGED_CHARTS_DIR=$MANAGED_CHARTS_DIR
VALUE_FILE=values-$VERSION.yaml

function try()
{
    [[ $- = *e* ]]; SAVED_OPT_E=$?
    set +e
}

function throw()
{
    exit $1
}

function catch()
{
    export ex_code=$?
    (( $SAVED_OPT_E )) && set +e
    return $ex_code
}

function throwErrors()
{
    set -e
}

function ignoreErrors()
{
    set +e
}

export CloneCodeFailure=100
export PushCodeFailure=101
export NotAllowedVersion=102

# start with a try
try
(   # open a subshell !!!
    echo "Cloning config repository..."
    export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

    git clone -b $BRANCH --single-branch --depth 1 $GIT_CONFIG_URI /tmp/$WORKING_DIR
    [ $? != 0 ] && throw $CloneCodeFailure

    cd /tmp/$WORKING_DIR

    [ ! -f "$MANAGED_CHARTS_DIR/$APPLICATION/$VALUE_FILE" ] && throw $NotAllowedVersion

    echo "Replacing commitSha..."
    sed -i "s/commitSha:.*/commitSha: $COMMIT/g" $MANAGED_CHARTS_DIR/$APPLICATION/$VALUE_FILE

    echo "Commiting changes..."
    git add . 
    git commit -m "Update $APPLICATION to commit $COMMIT on $BRANCH environment"

    echo "Pushing changes..."
    git push
    [ $? != 0 ] && throw $PushCodeFailure

    echo "Patching done!"
)
# directly after closing the subshell you need to connect a group to the catch using ||
catch || {
    # now you can handle
    case $ex_code in
        $CloneCodeFailure)
            echo "Unable to clone repository!"
        ;;
        $PushCodeFailure)
            echo "Cannot push changes to repository!"
        ;;
        $NotAllowedVersion)
            echo "Version not allowed!"
        ;;        
        *)
            echo "An unexpected exception was thrown"
            rm -rf /tmp/$WORKING_DIR
            throw $ex_code # you can rethrow the "exception" causing the script to exit if not caught
        ;;
    esac
}

echo "Cleaning working dir"
rm -rf /tmp/$WORKING_DIR