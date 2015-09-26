#!/usr/bin/env bash

apt-get update
apt-get upgrade

#Add apt repositories
touch /tmp/installLog.txt
apt-get install git -y
apt-get install wget -y

echo "glass:glasscannotlogin::::/home/glass/:/usr/sbin/nologin" > glassfish_user.txt
newusers glassfish_user.txt
wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie;" -a /tmp/installLog.txt -t 1 -O /var/tmp/jdk.tar.gz http://download.oracle.com/otn-pub/java/java_ee_sdk/7u3/java_ee_sdk-7u1.zip
wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie;" -a /tmp/installLog.txt -t 1 -O /var/tmp/glassfish.zip http://download.oracle.com/otn-pub/java/glassfish/3122/ogs-3.1.2.2.zip

su -s /bin/bash glass
cd /home/glass

#Get application source code
git clone https://www.github.com/tcamick/golden-ami

# now I am in /home/glass
cp /var/tmp/glassfish.zip .
cp /var/tmp/jdk.tar.gz .

tar -zxvf jdk.tar.gz
# bin directory is ~glass/jdk1.8.0_51/bin == THIS WILL CHANGE ==
unzip glassfish.zip

# bin directory containing asadmin is ~glass/glassfish4/bin == THIS MAY CHANGE ==
#Use vim to edit the glass .bash_profile file to put these two bin's BEFORE anything else. Resulting file is:
echo "
# User specific environment and startup programs
PATH=$PATH:$HOME/bin
PATH=$HOME/glassfish3/bin:$PATH
PATH=$HOME/jdk1.8.0_51/bin:$PATH
export PATH
" >> /home/glass/.bash_profile
# back to root
exit
# set glassfish to run on startup
cp /home/glass/golden-ami/packer-scripts/scripts/glassfish.sh /etc/init.d
chmod a+rx /etc/init.d/glassfish.sh
chkconfig --add glassfish.sh

reboot
