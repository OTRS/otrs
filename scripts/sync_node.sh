#!/bin/sh
# --
# scripts/sync_node.sh - to sync a otrs web server node with rsync
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: sync_node.sh,v 1.5 2009-02-16 12:50:17 tr Exp $
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

if ! test $1; then
    echo "Usage: $0 dest_node.host /opt/dest_note_otrs/ /opt/local_otrs/ '/etc/init.d/apache restart' remote_user"
    exit 1;
fi

NODE=$1
NODEDIR=$2
LOCDIR=$3
REMOTECMD=$4
REMOTEUSER=$5

#
# check needed files
#
if ! test `which rsync`; then
    echo "Error: Need rsync!"
    exit 5
fi
if ! test `which ssh`; then
    echo "Error: Need ssh!"
    exit 5
fi

#
# check needed options
#
if ! test $NODE; then
    echo "Error: Need Node as ARG0!"
    exit 5
fi

if ! test $NODEDIR; then
    echo "Error: Need NodeDir (remote otrs home directory) as ARG1!"
    exit 5
fi

if ! test $LOCDIR; then
    echo "Error: Need LocDir (local otrs home directory) as ARG2!"
    exit 5
fi

if ! test $REMOTECMD; then
    echo "Error: Need RemoteCMD (remode cmd to restart the webserver) as ARG3!"
    exit 5
fi

if ! test $REMOTEUSER; then
    REMOTEUSER="root"
fi

# sync otrs
rsync -azv --delete -e ssh $LOCDIR/ $REMOTEUSER@$NODE:$NODEDIR
# restart webserver (because of mod_perl)
ssh $REMOTEUSER@$NODE \'$REMOTECMD\'

exit;
