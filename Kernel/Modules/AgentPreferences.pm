# --
# Kernel/Modules/AgentPreferences.pm - provides agent preferences
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPreferences.pm,v 1.24 2004-09-16 22:04:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPreferences;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.24 $';
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
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject SessionObject UserObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;

    if ($Self->{Subaction} eq 'UpdatePw') {
        $Output = $Self->UpdatePw();
    }
    elsif ($Self->{Subaction} eq 'UpdateCustomQueues') {
        $Output = $Self->UpdateCustomQueues();
    }
    elsif ($Self->{Subaction}) {
        $Output = $Self->UpdateGeneric();
    }
    else {
        # get header
        $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Preferences');
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->Form();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --
sub Form {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # --
    # get param
    # --
    my $What = $Self->{ParamObject}->GetParam(Param => 'What') || '';
    # --
    # get notification
    # --
    if ($What) {
        $Output .= $Self->{LayoutObject}->Notify(Info => 'Preferences updated successfully!');
    }
    # --
    # get form
    # --
    my %QueueData = $Self->{QueueObject}->GetAllQueues(
        UserID => $Self->{UserID},
        Type => 'ro',
    );
    my @CustomQueueIDs = $Self->{QueueObject}->GetAllCustomQueues(UserID => $Self->{UserID});
    $Output .= $Self->{LayoutObject}->AgentPreferencesForm(
        QueueData => \%QueueData,
        CustomQueueIDs => \@CustomQueueIDs,
        RefreshTime => $Self->{UserRefreshTime} || $Self->{ConfigObject}->Get('Refresh'),
    );
    return $Output;
}
# --
sub UpdatePw {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $Pw = $Self->{ParamObject}->GetParam(Param => 'NewPw') || '';
    my $Pw1 = $Self->{ParamObject}->GetParam(Param => 'NewPw1') || '';

    if ($Pw eq $Pw1 && $Pw) {
        if ($Self->{ConfigObject}->Get('DemoSystem')) {
            $Output .= $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentPreferences&What=1",
            );
        }
        elsif ($Self->{UserObject}->SetPassword(UserLogin => $Self->{UserLogin}, PW => $Pw)) {
                $Output .= $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentPreferences&What=1",
                );
        }
        else {
            # get header
            $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Preferences');
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify();
            $Output .= $Self->Form();
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    else {
        # get header
        $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Preferences');
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify(Info => 'Passwords dosn\'t match! Please try it again!');
        $Output .= $Self->Form();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --
sub UpdateCustomQueues  {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my @QueueIDs = $Self->{ParamObject}->GetArray(Param => 'QueueID');
    
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM personal_queues WHERE user_id = $Self->{UserID}",
    );
    foreach my $ID (@QueueIDs) {
        # db quote
        $ID = $Self->{DBObject}->Quote($ID);

        $Self->{DBObject}->Do(
                SQL => "INSERT INTO personal_queues (queue_id, user_id) " .
                " VALUES ($ID, $Self->{UserID})",
        );
    }
    # mk redirect
    $Output .= $Self->{LayoutObject}->Redirect(
        OP => "Action=AgentPreferences&What=1",
    );
    return $Output;
}
# --
sub UpdateGeneric {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $Topic = $Self->{ParamObject}->GetParam(Param => 'GenericTopic');

    if (defined($Topic)) {
        # pref update db
        if (!$Self->{ConfigObject}->Get('DemoSystem')) {
            $Self->{UserObject}->SetPreferences(
                UserID => $Self->{UserID},
                Key => $Self->{Subaction},
                Value => $Topic,
            );
        }
        # update SessionID
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => $Self->{Subaction},
            Value => $Topic,
        );
        # mk rediect
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "Action=AgentPreferences&What=1",
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'No Topic selected!',
            Comment => 'Please one and try it again!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }

    return $Output;
}
# --

1;
