#!/bin/sh
# --
# SetPermissions.sh - to set the otrs permissions
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: SetPermissions.sh,v 1.36 2009-11-09 15:24:13 mn Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

echo "SetPermissions.sh <\$Revision: 1.36 $> - set OTRS file permissions"
echo "Copyright (C) 2001-2009 OTRS AG, http://otrs.org/\n";

if ! test $1 || ! test $2 || ! test $3; then
    # check required options
    echo ""
    echo "Usage: SetPermissions.sh <OTRS_HOME> <OTRS_USER> <WEBSERVER_USER> [OTRS_GROUP] [WEB_GROUP]"
    echo ""
    echo "  Try: SetPermissions.sh /opt/otrs otrs wwwrun"
    echo ""
    exit 1;
else
    # system settings
    WEBUSER=$3
    OTRSUSER=$2
    OTRSDEST=$1
    OTRSGROUP=nogroup
    WEBGROUP=nogroup
    [ "$4" != "" ]&& OTRSGROUP=$4
    [ "$5" != "" ]&& WEBGROUP=$5
fi


`dirname "$0"`/otrs.SetPermissions.pl \
   --web-user="$WEBUSER" \
   --otrs-user="$OTRSUSER" \
   --web-group="$WEBGROUP" \
   --otrs-group="$OTRSGROUP" \
   "$OTRSDEST"

exit;
