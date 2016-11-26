#!/bin/bash
for f in /docker-entrypoint-init.d/*; do
	case "$f" in
		*.sh)     echo "$0: running $f"; . "$f" ;;
		*)        echo "$0: ignoring $f" ;;
	esac
	echo	
done
/usr/bin/supervisord 




