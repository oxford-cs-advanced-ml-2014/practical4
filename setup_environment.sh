#!/bin/bash

set -e

#ROOT=$(dirname $(readlink -e $0))
ROOT="$(pwd)"
LOCAL_MACHINE_SCRATCH_SPACE=/home/scratch
#ENV="$(mktemp -u -d -p "$LOCAL_MACHINE_SCRATCH_SPACE" "conda_env.$USER.XXXXXXXXXXXX")/conda"

ENV="$ROOT/env"

function safe_call {
    # usage:
    #   safe_call function param1 param2 ...

    HERE=$(pwd)
    "$@"
    cd "$HERE"
}

function conda_install {
    conda install --yes "$1"
}

function pip_install {
    pip install "$1"
}

function install_pylearn2 {
    if [ -d "pylearn2" ]; then
        echo "Existing version of pylearn2 found, removing."
        rm -rf pylearn2
    fi  

    git clone https://github.com/lisa-lab/pylearn2.git

    cd pylearn2
    python setup.py develop
}

conda update --yes conda

conda create --yes --prefix "$ENV" python pip
source activate "$ENV"

# https://github.com/ContinuumIO/anaconda-issues/issues/32
cp .qt.conf "$ENV/bin/qt.conf"

echo "$ENV" > "$ROOT/.env"

safe_call conda_install numpy
safe_call conda_install scipy
#safe_call conda_install scikit-learn
safe_call conda_install matplotlib pil
safe_call conda_install pyyaml
safe_call pip_install git+git://github.com/Theano/Theano.git
#safe_call install_pylearn2 
