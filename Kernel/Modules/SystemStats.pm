# --
# Kernel/Modules/SystemStats.pm - show stats of otrs
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SystemStats.pm,v 1.7 2003-03-23 21:34:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::SystemStats;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject UserObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $Subaction = $Self->{Subaction};
    my $NextScreen = $Self->{NextScreen};
    my $BackScreen = $Self->{BackScreen};
    my $UserID = $Self->{UserID};
    my $UserLogin = $Self->{UserLogin};
    my $DataDir = $Self->{ConfigObject}->Get('StatsPicDir') || '/opt/OpenTRS/var/pics/stats';
    
    if ($Subaction eq '' || !$Subaction) {

        # fetch files
        my @Index;
        my @List = glob("$DataDir/*");
        foreach (@List) {
            s!^.*/!!;
            push (@Index, $_);
        }
        # print page ...
        $Output .= $Self->{LayoutObject}->Header(Title => 'Stats',);
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $UserID);
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        
        # fetch data
        my %SytemTickets;
        my $SQL = "SELECT count(*), tsd.name FROM " .
        " ticket st, ticket_state tsd " .
        " WHERE " .
        " tsd.id = st.ticket_state_id " .
        " GROUP BY tsd.name";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
            $SytemTickets{$RowTmp[1]} = $RowTmp[0];
        }
        
        $Output .= $Self->{LayoutObject}->SystemStats(
            Files => \@Index,
            SystemTickts => \%SytemTickets
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin'
        );
        $Self->{LogObject}->Log(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin'
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
