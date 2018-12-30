#!/bin/bash
#
# Startup script for SBFSpotUploadDaemon
#

# Check, if there is an environment parameter
if [ "$UPLOADDAEMON_CONFIGFILE" == "" ]; then
	echo "No configfile name in environment."
	echo "Assuming /config/SBFspotUpload.cfg"
	echo
	UPLOADDAEMON_CONFIGFILE="/config/SBFspotUpload.cfg"
fi
echo "Executing SBFspotUploadDaemon:"
echo "/opt/sbfspot/SBFspotUploadDaemon $UPLOADDAEMON_CONFIGFILE ..."
/opt/sbfspot/SBFspotUploadDaemon -c"$UPLOADDAEMON_CONFIGFILE"
