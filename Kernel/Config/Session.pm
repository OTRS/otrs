# --
# Kernel/Config/Session.pm - Session config file for OTRS 
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Session.pm,v 1.1 2002-10-15 09:18:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Config::Session;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub LoadSession {
    my $Self = shift;
    # ----------------------------------------------------#
    #                                                     #
    #             Start of config options!!!              #
    #                   Session stuff                     #
    #                                                     #
    # ----------------------------------------------------#

    # ----------------------------------------------------#
    # SessionModule                                       #
    # ----------------------------------------------------#
    # (How should be the session-data stored? 
    # Advantage of DB is that you can split the 
    # Frontendserver from the db-server. fs or ipc is faster.)
#    $Self->{SessionModule} = 'Kernel::System::AuthSession::DB';
#    $Self->{SessionModule} = 'Kernel::System::AuthSession::FS';
    $Self->{SessionModule} = 'Kernel::System::AuthSession::IPC';

    # SessionName
    # (Name of the session key. E. g. Session, SessionID, OTRS)
    $Self->{SessionName} = 'Session';

    # SessionCheckRemoteIP 
    # (If the application is used via a proxy-farm then the 
    # remote ip address is mostly different. In this case,
    # turn of the CheckRemoteID. ) [1|0] 
    $Self->{SessionCheckRemoteIP} = 1;

    # SessionDeleteIfNotRemoteID
    # (Delete session if the session id is used with an 
    # invalied remote IP?) [0|1]
    $Self->{SessionDeleteIfNotRemoteID} = 1;

    # SessionMaxTime
    # (Max valid time of one session id in second (8h = 28800).)
    $Self->{SessionMaxTime} = 28800;

    # SessionDeleteIfTimeToOld
    # (Delete session's witch are requested and to old?) [0|1]
    $Self->{SessionDeleteIfTimeToOld} = 1;

    # SessionUseCookie
    # (Should the session management use html cookies?
    # It's more comfortable to send links -==> if you have a valid 
    # session, you don't have to login again.) [0|1]
    # Note: If the client browser disabled html cookies, the system
    # will work as usual, append SessionID to links!
#    $Self->{SessionUseCookie} = 1;

    # SessionDir
    # directory for all sessen id informations (just needed if 
    # $Self->{SessionModule}='Kernel::System::AuthSession::FS)
    $Self->{SessionDir} = $Self->{Home} . '/var/sessions';

    # SessionTable*
    # (just needed if $Self->{SessionModule}='Kernel::System::AuthSession::DB)  
    # SessionTable 
    $Self->{SessionTable} = 'session';
    # SessionTable id column
    $Self->{SessionTableID} = 'session_id';
    # SessionTable value column
    $Self->{SessionTableValue} = 'value';

}
# --


1;

