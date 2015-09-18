#!/usr/bin/env bash

apt-get update
apt-get upgrade

#Add apt repositories
touch /tmp/installLog.txt
apt-get install git -y
apt-get install wget -y
apt-get install unzip -y

echo "glass:glasscannotlogin::::/home/glass/:/usr/sbin/nologin" > glassfish_user.txt
newusers glassfish_user.txt
wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie;" -a /tmp/installLog.txt -t 1 -O /var/tmp/jdk.zip http://download.oracle.com/otn-pub/java/java_ee_sdk/7u3/java_ee_sdk-7u1.zip
wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie;" -a /tmp/installLog.txt -t 1 -O /var/tmp/glassfish.zip http://download.oracle.com/otn-pub/java/glassfish/3122/ogs-3.1.2.2.zip

#Go to glass user's home
cd /home/glass/

#We only want applications to be run with glass permissions
#Get application source code
git clone https://www.github.com/tcamick/golden-ami
chown -R glass:glass /home/glass/golden-ami

cp /var/tmp/glassfish.zip /home/glass/glassfish.zip
cp /var/tmp/jdk.zip /home/glass/jdk.zip

unzip /home/glass/jdk.tar.gz
unzip /home/glass/glassfish.zip

chown -R glass:glass /home/glass/glassfish3
chown -R glass:glass /home/glass/jdk

# bin directory containing asadmin is ~glass/glassfish4/bin == THIS MAY CHANGE ==
#Use vim to edit the glass .bash_profile file to put these two bin's BEFORE anything else. Resulting file is:
echo "
# User specific environment and startup programs
#PATH=$PATH:/home/glass/bin
PATH=/home/glass/glassfish3/bin:$PATH
PATH=/home/glass/jdk1.8.0_51/bin:$PATH
export PATH
" >> /home/glass/.bash_profile
# back to root

# set glassfish to run on startup
cp /home/glass/golden-ami/packer-scripts/scripts/glassfish.sh /etc/init.d/glassfish.sh
chmod a+rx /etc/init.d/glassfish.sh

reboot
