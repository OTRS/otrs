# --
# Kernel/Modules/CustomerPreferences.pm - provides agent preferences
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerPreferences.pm,v 1.1 2002-10-20 15:40:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerPreferences;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
    foreach (
      'ParamObject', 
      'DBObject', 
      'QueueObject', 
      'LayoutObject', 
      'ConfigObject', 
      'LogObject', 
      'SessionObject',
      'UserObject',
    ) {
        die "Got no $_" if (!$Self->{$_});
    }

    # get params
    $Self->{Want} = $Self->{ParamObject}->GetParam(Param => 'Want') || '';

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
    elsif ($Self->{Subaction} =~ /^User/) {
        $Output = $Self->UpdateGeneric();
    }
    else {
        $Output = $Self->Form();
    }
    return $Output;
}
# --
sub Form {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $UserID = $Self->{UserID};
    
    $Output .= $Self->{LayoutObject}->CustomerHeader(Title => 'Preferences');
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();

    $Output .= $Self->{LayoutObject}->CustomerPreferencesForm(
        RefreshTime => $Self->{UserRefreshTime} || $Self->{ConfigObject}->Get('Refresh'),
    );

    $Output .= $Self->{LayoutObject}->CustomerFooter();
    
    return $Output;
}
# --
sub UpdatePw {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $Pw = $Self->{ParamObject}->GetParam(Param => 'NewPw') || '';
    my $Pw1 = $Self->{ParamObject}->GetParam(Param => 'NewPw1') || '';
    my $UserID = $Self->{UserID};
    
    if ($Pw eq $Pw1 && $Pw) {
        $Self->{UserObject}->SetPassword(UserLogin => $Self->{UserLogin}, PW => $Pw);
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "&Action=CustomerPreferences",
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->CustomerHeader();
        $Output .= $Self->{LayoutObject}->CustomerWarning(
            Message => 'Passwords dosn\'t match! Please try it again!',
            Comment => 'Passwords dosn\'t match! Please try it again!',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
    }
    
    return $Output;
}
# --
sub UpdateCustomQueues  {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my @QueueIDs = $Self->{ParamObject}->GetArray(Param => 'QueueID');
    my $UserID = $Self->{UserID};
    
    if (@QueueIDs) {
        $Self->{DBObject}->Do(
            SQL => "DELETE FROM personal_queues WHERE user_id = $UserID",
        );
        foreach (@QueueIDs) {
            $Self->{DBObject}->Do(
                SQL => "INSERT INTO personal_queues (queue_id, user_id) " .
                " VALUES ($_, $UserID)",
            );
        }
        # mk redirect
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "&Action=CustomerPreferences",
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->CustomerHeader();
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => 'No Queue selected!',
            Comment => 'Please min. 1 queue!',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
    }
    return $Output;
}
# --
sub UpdateGeneric {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $UserID = $Self->{UserID};
    my $Topic = $Self->{ParamObject}->GetParam(Param => 'GenericTopic');

    if (defined($Topic)) {
        # pref update db
        $Self->{UserObject}->SetPreferences(
            UserID => $UserID,
            Key => $Self->{Subaction},
            Value => $Topic,
        );
        # update SessionID
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => $Self->{Subaction},
            Value => $Topic,
        );
        # mk rediect
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "&Action=CustomerPreferences",
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->CustomerHeader();
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => 'No Topic selected!',
            Comment => 'Please one and try it again!',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
    }

    return $Output;
}
# --

1;
