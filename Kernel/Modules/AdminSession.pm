# --
# Kernel/Modules/AdminSession.pm - to control all session ids
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminSession.pm,v 1.7 2002-10-25 11:46:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminSession;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject PermissionObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $Subaction = $Self->{Subaction}; 
    my $SessionObject = $Self->{SessionObject};
    my $WantSessionID = $Self->{ParamObject}->GetParam(Param => 'WantSessionID') || '';

    # --
    # permission check
    # --
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        return $Self->{LayoutObject}->NoPermission();
    }

    # print session screen
    if ($Subaction eq '' || !$Subaction) {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Sessions');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminSession();

        my @List = $SessionObject->GetAllSessionIDs();
        foreach my $SessionID (@List) {
            my %Data = $SessionObject->GetSessionIDData(SessionID => $SessionID);
            $Output .= $Self->{LayoutObject}->AdminSessionTable(SessionID => $SessionID, %Data);
        }
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # kill session id
    elsif ($Subaction eq 'Kill') {
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=AdminSession");    
        # FIXME
        $SessionObject->RemoveSessionID(SessionID => $WantSessionID);    
    }
    # kill all session id
    elsif ($Subaction eq 'KillAll') {
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=AdminSession");    
        # FIXME
        my @List = $SessionObject->GetAllSessionIDs();
        foreach my $SessionID (@List) {
            # killall sessions but not the own one!
            if ($WantSessionID ne $SessionID) {
                $SessionObject->RemoveSessionID(SessionID => $SessionID);    
            }
        }
    }
    # else ! error!
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
                Message => 'No Subaction!!',
                Comment => 'Please contact your admin');
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;

