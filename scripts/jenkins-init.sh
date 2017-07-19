#!/bin/bash

# volume setup
vgchange -ay

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then
    pvcreate ${DEVICE} -y
    vgcreate data ${DEVICE} -y
    lvcreate --name volume1 -l 100%FREE data -y
    mkfs.ext4 /dev/data/volume1
fi

mkdir -p /var/lib/jenkins
echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
mount /var/lib/jenkins
rm -rf /var/lib/jenkins/lost+found
chown jenkins: /var/lib/jenkins -R

# install jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
echo "deb http://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list
apt-get update
apt-get install -y jenkins=${JENKINS_VERSION} unzip

# install pip
wget -q https://bootstrap.pypa.io/get-pip.py
python get-pip.py
python3 get-pip.py
rm -f get-pip.py
# install awscli
pip install awscli

# install terraform
cd /usr/local/bin
wget -q https://releases.hashicorp.com/terraform/0.9.11/terraform_0.9.11_linux_amd64.zip
unzip terraform_0.9.11_linux_amd64.zip
# install packer
wget -q https://releases.hashicorp.com/packer/1.0.2/packer_1.0.2_linux_amd64.zip
unzip packer_1.0.2_linux_amd64.zip
# clean up
apt-get clean
rm terraform_0.9.11_linux_amd64.zip
rm packer_1.0.2_linux_amd64.zip
