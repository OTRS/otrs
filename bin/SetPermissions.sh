#!/bin/bash
# --
# SetPermissions.sh - to set the otrs permissions 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SetPermissions.sh,v 1.6 2002-06-20 21:50:27 martin Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

echo "SetPermissions.sh <\$Revision: 1.6 $> - set OpenTRS file permissions"
echo "Copyright (c) 2002 Martin Edenhofer <martin@otrs.org>"

if ! test $1 || ! test $2 || ! test $3; then 
    # --
    # check required options
    # --
    echo ""
    echo "Usage: SetPermissions.sh <OTRS_HOME> <OTRS_USER> <WEBSERVER_USER> [OTRS_GROUP] [WEB_GROUP]"
    echo ""
    echo "  Try: SetPermissions.sh /opt/OpenTRS otrs wwwrun"                      
    echo ""
    exit 1;
else 
    # --
    # system settings
    # --
    WEBUSER=$3
    OTRSUSER=$2
    OTRSDEST=$1
    OTRSGROUP=nogroup
    WEBGROUP=nogroup
    [ "$4" != "" ]&& OTRSGROUP=$4
    [ "$5" != "" ]&& WEBGROUP=$5
fi


# --
# set permission
# --
echo "Setting file permissions... "
# set all files to root.root (safe is safe)
echo "chown -R root.root $OTRSDEST"
chown -R root.root $OTRSDEST

# set the $HOME to the OpenTRS user
echo "chown $OTRSUSER.$OTRSGROUP $OTRSDEST"
chown $OTRSUSER.$OTRSGROUP $OTRSDEST

# set the fetchmail rc to OpenTRS user
echo "chown $OTRSUSER.$OTRSGROUP $OTRSDEST/.fetchmailrc"
chown $OTRSUSER.$OTRSGROUP $OTRSDEST/.fetchmailrc
echo "chmod 0710 $OTRSDEST/.fetchmailrc"
chmod 0710 $OTRSDEST/.fetchmailrc

# set the var directory to OpenTRS and webserver user
echo "chown -R $OTRSUSER.$OTRSGROUP $OTRSDEST/var/" 
chown -R $OTRSUSER.$OTRSGROUP $OTRSDEST/var/
chmod -R 2775 $OTRSDEST/var/article/

# set the var/sessions directory to OpenTRS and webserver user
echo "chown -R $WEBUSER.$WEBGROUP $OTRSDEST/var/sessions/"
chown -R $WEBUSER.$WEBGROUP $OTRSDEST/var/sessions/ 

# set the var/log/TicketCounter.log file to OpenTRS and webserver user
echo "$OTRSUSER.$WEBGROUP $OTRSDEST/var/log/TicketCounter.log"
chown $OTRSUSER.$WEBGROUP $OTRSDEST/var/log/TicketCounter.log
chmod 2775 $OTRSDEST/var/log/TicketCounter.log

# set the DeleteSessionIDs.pl just to OpenTRS user
echo "chown $OTRSUSER.root $OTRSDEST/bin/DeleteSessionIDs.pl"
chown $OTRSUSER.root $OTRSDEST/bin/DeleteSessionIDs.pl 

# set the UnlockTickets.pl just to OpenTRS user
echo "chown $OTRSUSER.root $OTRSDEST/bin/UnlockTickets.pl"
chown $OTRSUSER.root $OTRSDEST/bin/UnlockTickets.pl

exit;

