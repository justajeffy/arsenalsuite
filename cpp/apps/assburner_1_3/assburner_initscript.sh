#!/bin/bash
#
# based off of -- http://www.linux.com/article.pl?sid=05/08/02/1821218
#
#       /etc/rc.d/init.d/assburner
# This shell script takes care of starting and stopping assburner process
#
# Author: Matt Newell <newellm@blur.com>
#
# chkconfig: 2345 20 80
# description: Assburner - Daemon that executes assigned jobs

# Source function library.
. /etc/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ ${NETWORKING} = "no" ] && exit 0

usage() {
	echo "Used to start and stop Assburner"
	echo "Usage:"
	echo "    service assburner (stop|start|status|restart)"
	echo
	exit 2;
}


start() {
	echo -n $"Starting Assburner"
	/usr/local/bin/assburner -daemonize
	RETVAL=$?
	echo
	[ $RETVAL -eq 0 ] && touch /var/lock/subsys/assburner
	return $RETVAL
}

stop() {
	echo -n $"Shutting down Assburner"
	pid=`ps auxw |grep assburner |grep -v grep | awk '{ print $2 }'`
	if [ -n "$pid" ]; then
		if checkpid $pid 2>&1; then
			# term first, then kill if not dead
			kill -TERM $pid >/dev/null 2>&1
			if checkpid $pid && sleep 1 && 
				checkpid $pid && sleep 3 &&
				checkpid $pid ; then
			  	kill -KILL $pid >/dev/null 2>&1
			  	usleep 100000
			fi
		fi
		checkpid $pid
		RC=$?
		[ "$RC" -eq 0 ] && failure $"assburner shutdown" || success $"assburner shutdown"
		RC=$((! $RC))	
	fi
    echo
    rm -f /var/lock/subsys/assburner
    return $RC
}

status() {
	# first see if in process list
	pid=`ps auxw |grep assburner |grep -v grep  | awk '{ print $2 }'`
	if [ -n "$pid" ]; then
		echo "assburner (pid $pid) is running..."
		return 0
	fi

	# See if /var/lock/subsys/manager exists
	if [ -f /var/lock/subsys/assburner ]; then
		echo "assburner dead but subsys locked"
		return 2
	fi
	echo "assburner is stopped"
	return 3
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status $HOST
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart}"
        exit 1
        ;;
esac
exit $?
