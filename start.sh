#!/bin/bash
#
# Startup script for SBFSpotUploadDaemon
#

# Check, if there is an environment parameter
if [ "$SBFSPOT_UPLOADDAEMON_FILENAME" == "" ]; then
	echo "No configfile name in environment."
	echo "Assuming /config/SBspotUpload.cfg"
	echo
	SBFSPOT_UPLOADDAEMON_FILENAME="/config/SBFspotUpload.cfg"
fi
echo "Executing SBFspotUploadDaemon: /opt/sbfspot/SBFspotUploadDaemon $SBFSPOT_UPLOADDAEMON_FILENAME ..."
/opt/sbfspot/SBFspotUploadDaemon $SBFSPOT_UPLOADDAEMON_FILENAME

