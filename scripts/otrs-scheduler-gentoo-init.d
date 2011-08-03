#!/sbin/runscript
# --
# otrs-scheduler-gentoo-init.d - initscript for the OTRS Scheduler Daemon
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: otrs-scheduler-gentoo-init.d,v 1.1 2011-08-03 23:17:27 ep Exp $
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
# or see L<http://www.gnu.org/licenses/agpl.txt>.
# --

PIDFILE="${OTRS_HOME}"/var/run/scheduler.pid

depend() {
    need localmount net
    after bootmisc mysql postgres
}

start() {
    ebegin "Starting the OTRS Scheduler Daemon..."
    start-stop-daemon \
        --start \
        --user ${OTRS_USER} \
        --group ${OTRS_GROUP} \
        --chdir ${OTRS_HOME} \
        --pidfile ${PIDFILE} \
        --interpreted \
        --exec ${OTRS_HOME}/bin/otrs.Scheduler.pl \
        -- \
        -a start
    eend $?
}

stop() {
    ebegin "Stopping the OTRS Scheduler Daemon..."
    start-stop-daemon \
        --stop \
        --pidfile ${PIDFILE} \
        --interpreted \
        --exec ${OTRS_HOME}/bin/otrs.Scheduler.pl
    eend $?
}

status() {
    ebegin "Checking status of the OTRS Scheduler Daemon..."
    ${OTRS_HOME}/bin/otrs.Scheduler.pl -a status
    eend $?
}
