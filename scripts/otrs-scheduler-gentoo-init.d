#!/sbin/runscript
# --
# otrs-scheduler-gentoo-init.d - initscript for the OTRS Scheduler Daemon
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
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
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
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
