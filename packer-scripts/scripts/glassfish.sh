#!/bin/sh
#
# /etc/init.d/glassfish
# init script for GlassFish 4.0 on my Bastion instance in EC2
# Appends information to a log file in $glassInitLog
# At start, creates an entry with the EC2 instance id in $instanceIdFile
# Runs glassfish under the glass account
# Adapted from http://www.tldp.org/HOWTO/HighQuality-Apps-HOWTO/boot.html
# USAGE: Place this script in the /etc/init.d directory and use
#  chkconfig --add to set the runlevel links.
#  - Norman Wilde, August 31, 2014
#
# chkconfig: 2345 85 15
# description: glassfish server daemon
#
# processname: glassfish
# config: /etc/MySystem/mySystem.conf
# config: /etc/sysconfig/mySystem
# pidfile: /var/run/MySystem.pid

RETVAL=0
prog="glassfish"
glassInitLog="/var/tmp/glassInitLog"
instanceIdFile="/var/tmp/instanceId"
glassfishBin="/home/glass/glassfish3/bin"
awsBin="/opt/aws/bin"

start() {
        echo -n $"Starting $prog:"
        rm -f $instanceIdFile

# Run the following commands using -l to use the glass account's
# path, which must have the current paths for aws, for jdk/bin
# and glassfish/bin

        runuser -l glass -c 'echo `date `' >> $glassInitLog
        runuser -l glass -c 'echo `ec2-metadata -i `' > $instanceIdFile
        runuser -l glass -c 'asadmin start-domain' >> $glassInitLog

#       RETVAL=$?
#       [ "$RETVAL" = 0 ] && touch /var/lock/subsys/$prog
        echo
}

stop() {
        echo -n $"Stopping $prog:"
        runuser -l glass -c 'echo `date `' >> $glassInitLog
        runuser -l glass -c 'asadmin stop-domain' >> $glassInitLog
        echo
}

case "$1" in
        start)
                start
                ;;
        stop)
                stop
                ;;
        restart)
                stop
                start
                ;;
        *)
                echo $"Usage: $0 {start|stop|restart}"
                RETVAL=1
esac
exit $RETVAL
