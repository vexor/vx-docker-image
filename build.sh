set -x

VERSION=$(cat version.txt)

case $1 in
  push)
    echo docker push quay.io/dmexe/trusty:${VERSION}
    docker push quay.io/dmexe/trusty:${VERSION}
    ;;
  *)
    cd docker/trusty
    echo docker build -t quay.io/dmexe/trusty:${VERSION} .
    docker build --rm --no-cache -t quay.io/dmexe/trusty:${VERSION} .
    docker run -it quay.io/dmexe/trusty:${VERSION} /sbin/my_init -- /bin/bash /var/vexor/tests.sh
    ;;
esac
