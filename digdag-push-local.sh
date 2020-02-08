  
#!/bin/sh

ROOT="$(cd $(dirname $0); pwd)"
NETWORK_NAME="$(docker network ls --filter 'name=digdag-server' -q)"

(
    cd $ROOT
    docker run --rm -it -v `pwd`/:/vol --network $NETWORK_NAME my-digdag-server_digdag /vol/workflow/digdag-push.sh -e 'http://digdag:65432' ${@}
)
