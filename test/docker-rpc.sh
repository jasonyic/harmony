#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

cleanup() { 
  containers=$(docker ps -a | awk -v i="^$1.*" '{if($2~i){print$1}}')
  if [ -z $containers ]; then
    docker stop $containers
    docker rm $(cat $containers  | tr '\n' ' ')
  fi
}

docker_test="harmony-localnet-test"

cleanup $docker_test

case ${1} in
run)
    docker pull harmonyone/localnet-test
    docker run -it --name "$docker_test" \
      -p 9500:9500 -p 9501:9501 -p 9599:9599 -p 9598:9598 -p 9799:9799 -p 9798:9798 -p 9899:9899 -p 9898:9898 \
      -v "$DIR/../:/go/src/github.com/harmony-one/harmony" harmonyone/localnet-test -n -k

    ;;
attach)
    docker exec -it "$docker_name" /bin/bash
    ;;
*)
    echo "
Node API tests

Param:     Help:
run        Run the Node API tests
attach     Attach onto the Node API testing docker image for inspection
"
    exit 0
    ;;
esac

