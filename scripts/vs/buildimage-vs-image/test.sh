#!/bin/bash -xe

echo ${JOB_NAME##*/}.${BUILD_NUMBER}

ls -l

docker login -u $REGISTRY_USERNAME -p $REGISTRY_PASSWD sonicdev-microsoft.azurecr.io:443
docker pull sonicdev-microsoft.azurecr.io:443/docker-sonic-mgmt:latest

cat $PRIVATE_KEY > pkey.txt

mkdir -p $HOME/sonic-vm/images
cp target/sonic-vs.img.gz $HOME/sonic-vm/images/
gzip -fd $HOME/sonic-vm/images/sonic-vs.img.gz

ls -l $HOME/sonic-vm/images

cd sonic-mgmt/ansible
sed -i s:use_own_value:johnar: veos.vtb
echo abc > password.txt
cd ../../
docker run --rm=true -v $(pwd):/data -w /data -i sonicdev-microsoft.azurecr.io:443/docker-sonic-mgmt ./scripts/vs/buildimage-vs-image/runtest.sh
