#!/bin/bash

#set -e

info () {
    echo "[INFO] $@"
}

appSetup () {

    info "Executing appSetup"

    touch /config/.tvhalreadysetup

}

appStart () {
    info "Executing appStart"
    [ -f /config/.tvhalreadysetup ] && echo "Skipping setup..." || appSetup

    # Start the services
    /usr/bin/supervisord
}

appHelp () {
        echo "Available options:"
        echo " app:start          - Starts all services needed for tvheadend"
        echo " app:setup          - First time setup."
        echo " app:help           - Displays the help"
        echo " [command]          - Execute the specified linux command eg. /bin/bash."
}

case "$1" in
        app:start)
                appStart
                ;;
        app:setup)
                appSetup
                ;;
        app:help)
                appHelp
                ;;
        *)
                if [ -x $1 ]; then
                        $1
                else
                        prog=$(which $1)
                        if [ -n "${prog}" ] ; then
                                shift 1
                                $prog $@
                        else
                                appHelp
                        fi
                fi
                ;;
esac

exit 0

