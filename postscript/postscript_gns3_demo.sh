#!/bin/bash

ZTD_SERVER_IP="10.204.11.100"
ADDON_SCRIPTS_PATH=/tftpboot/sonic/postscript_addons/
SAVE_CONFIG_FILE=save_config.sh
ADMIN_HOME=/home/admin/
CGI=/cgi-bin/callback.sh
APP=http://
CRONLINE=${ADMIN_HOME}${SAVE_CONFIG_FILE}
CRONROOT=/var/spool/cron/crontabs/root

# Request callback script at http server (cgi-script)
# This creates a file with name <ip-address> amd hostname in it on the server end
/usr/bin/curl -s ${APP}${ZTD_SERVER_IP}${CGI}

sleep 2

# Save config permanent
config save -y

sleep 2

# get save_config.sh addon script and add to crontab
/usr/bin/curl -s ${APP}${ZTD_SERVER_IP}${ADDON_SCRIPTS_PATH}${SAVE_CONFIG_FILE} -o ${ADMIN_HOME}${SAVE_CONFIG_FILE}
sleep 2
chmod a+x ${ADMIN_HOME}${SAVE_CONFIG_FILE}

# Check if save_config script present in crontab
if [[ ! -f "${CRONROOT}" ]]; then touch ${CRONROOT}; fi

if ! grep -q "${CRONLINE}" "${CRONROOT}"; then
   echo "* * * * * sudo $CRONLINE" >> ${CRONROOT}
fi

