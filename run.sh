#!/bin/bash

# https://github.com/ContinuumIO/anaconda-issues/issues/32
export QT_PLUGIN_PATH=""

export PYTHONPATH="$(pwd)/pylearn2:$PYTHONPATH"
export PYLEARN2_VIEWER_COMMAND="eog --new-instance"
export PYLEARN2_DATA_PATH="$(cat .data)"

HERE="$(pwd)"
TOOL_PATH="$HERE:pylearn2/pylearn2/scripts"

ENV="$(cat "$HERE/.env" 2>/dev/null)"
if [[ -z "$ENV" || ! -d "$ENV" ]]; then
    echo "You need to run ./setup_environment.sh ."
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: $0 tool_script.py arg0 arg1 ..."
    exit 1
fi

TOOL_NAME="$1";
TOOL_PARAMS="${@:2}"

TOOL=""
for D in ${TOOL_PATH//:/ }; do
    if [ -f "$D/$TOOL_NAME" ]; then
        TOOL="$D/$TOOL_NAME"
        break
    fi
done

export PYTHONPATH="$HERE:$PYTHONPATH"
source activate "$(cat "$HERE/.env")"

if [ ! -z "$TOOL" ]; then
    # http://tldp.org/LDP/abs/html/comparison-ops.html
    if [[ $TOOL == *.py ]]; then
        TOOL="python $TOOL"
    fi
else
    alias which=which
    SYSTEM_TOOL="$(which $TOOL_NAME)"

    if [ -z "$SYSTEM_TOOL" ]; then
        echo "Could not find '$TOOL_NAME'."
        exit 1
    else
        TOOL="$SYSTEM_TOOL"
    fi
fi

echo "Running: '$TOOL'"
echo "Params : $TOOL_PARAMS"
echo "-----------------------"

$TOOL $TOOL_PARAMS
