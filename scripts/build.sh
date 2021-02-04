#!/bin/bash -e

type go >/dev/null 2>&1 || {
  export PATH=$PATH:/usr/local/go/bin
}

export WORKSPACE=${WORKSPACE:-$HOME}
export CONTRAIL_REGISTRY=${CONTRAIL_REGISTRY:-"localhost:5000"}
export CONTRAIL_CONTAINER_TAG=${CONTRAIL_CONTAINER_TAG:-"latest"}
export CGO_ENABLED=1

target=${CONTRAIL_REGISTRY}/tf-operator:${CONTRAIL_CONTAINER_TAG}
cd ${WORKSPACE}/contrail/tf-operator

function run_cmd(){
  local me=$(whoami)
  if [[ "root" == "$me" ]] || groups | grep -q 'docker' ; then
    $@
  fi
  echo $@ | sg docker -c bash
}

operator-sdk build $target
docker push $target
