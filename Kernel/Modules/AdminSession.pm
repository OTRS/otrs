# --
# Kernel/Modules/AdminSession.pm - to control all session ids
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminSession.pm,v 1.10.2.1 2003-05-12 10:51:25 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminSession;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.10.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $WantSessionID = $Self->{ParamObject}->GetParam(Param => 'WantSessionID') || '';

    # kill session id
    if ($Self->{Subaction} eq 'Kill') {
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=AdminSession");    
        # FIXME
        $Self->{SessionObject}->RemoveSessionID(SessionID => $WantSessionID);    
    }
    # kill all session id
    elsif ($Self->{Subaction} eq 'KillAll') {
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=AdminSession");    
        # FIXME
        my @List = $Self->{SessionObject}->GetAllSessionIDs();
        foreach my $SessionID (@List) {
            # killall sessions but not the own one!
            if ($WantSessionID ne $SessionID) {
                $Self->{SessionObject}->RemoveSessionID(SessionID => $SessionID);    
            }
        }
    }
    # else, show session list 
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Sessions');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        my @List = $Self->{SessionObject}->GetAllSessionIDs();
        my $Counter = @List;
        $Output .= $Self->{LayoutObject}->AdminSession(Counter => $Counter);
        foreach my $SessionID (@List) {
            my %Data = $Self->{SessionObject}->GetSessionIDData(SessionID => $SessionID);
            $Output .= $Self->{LayoutObject}->AdminSessionTable(SessionID => $SessionID, %Data);
        }
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;

