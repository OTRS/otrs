#!/bin/bash
# --
# SetPermissions.sh - to set the otrs permissions 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SetPermissions.sh,v 1.2 2002-04-22 22:02:33 martin Exp $
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
export WEBUSER=wwwrun
export OTRSUSER=otrs
export OTRSDEST=/opt/OpenTRS

# set permission
echo "Setting file permissions... "
echo "root.root $OTRSDEST"
chown -R root.root $OTRSDEST

echo "$OTRSUSER.nogroup $OTRSDEST/var/" 
chown -R $OTRSUSER.nogroup $OTRSDEST/var/
chmod -R 2775 $OTRSDEST/var/article/

echo "$WEBUSER.nogroup $OTRSDEST/var/sessions/"
chown -R $WEBUSER $OTRSDEST/var/sessions/ 


