# --
# AgentPreferences.pm - provides agent preferences
# Copyright (C) 2001,2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPreferences.pm,v 1.3 2002-04-12 16:33:35 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPreferences;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
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
    foreach ('ParamObject', 'DBObject', 'QueueObject', 'LayoutObject', 'ConfigObject', 'LogObject', 'SessionObject') {
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
    
    if ($Self->{Subaction} eq 'SearchByTn') {
        $Output = $Self->SearchByTn();
    }
    elsif ($Self->{Subaction} eq 'UpdatePw') {
        $Output = $Self->UpdatePw();
    }
    elsif ($Self->{Subaction} eq 'UpdateLanguage') {
        $Output = $Self->UpdateLanguage();
    }
    elsif ($Self->{Subaction} eq 'UpdateCustomQueues') {
        $Output = $Self->UpdateCustomQueues();
    }
    elsif ($Self->{Subaction} eq 'UpdateCharset') {
        $Output = $Self->UpdateCharset();
    }
    elsif ($Self->{Subaction} eq 'UpdateTheme') {
        $Output = $Self->UpdateTheme();
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
    
    $Output .= $Self->{LayoutObject}->Header(Title => 'Preferences');
    my %LockedData = $Self->{DBObject}->GetLockedCount(UserID => $UserID);
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
    my %QueueData = $Self->{QueueObject}->GetAllQueues(UserID => $UserID);
    my @CustomQueueIDs = $Self->{QueueObject}->GetAllCustomQueues(UserID => $UserID);
    $Output .= $Self->{LayoutObject}->AgentPreferencesForm(
        QueueData => \%QueueData,
        CustomQueueIDs => \@CustomQueueIDs,
    );

    $Output .= $Self->{LayoutObject}->Footer();
    
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
    my $UserLogin = $Self->{UserLogin};
    
    if ($Pw eq $Pw1 && $Pw) {
        my $NewPw = crypt($Pw, $UserLogin);
        $Self->{DBObject}->Do(
            SQL => "UPDATE user SET pw = '$NewPw' where id = $UserID",
        );
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "&Action=AgentPreferences",
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'Passwords dosn\'t match! Please try it again!',
            Comment => 'Passwords dosn\'t match! Please try it again!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    
    return $Output;
}
# --
sub UpdateLanguage {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $LanguageID = $Self->{ParamObject}->GetParam(Param => 'LanguageID') || '';
    my $UserID = $Self->{UserID};
    
    if ($LanguageID) {
        # get value
        $Self->{DBObject}->Prepare(SQL => "SELECT language FROM language where id = $LanguageID");
        my $Language = '';
        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
            $Language = $RowTmp[0];
        }

        # pref update db
        $Self->{DBObject}->SetPreferences(
            UserID => $UserID,
            Key => 'UserLanguage',
            Value => $Language, 
        );
        # update SessionID
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'UserLanguage',
            Value => $Language,
        );

        # mk redirect
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "&Action=AgentPreferences",
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'No LanguageID selected!',
            Comment => 'Please one and try it again!',
        );
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
            OP => "&Action=AgentPreferences",
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'No Queue selected!',
            Comment => 'Please min. 1 queue!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --
sub UpdateCharset {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $UserID = $Self->{UserID};
    my $CharsetID = $Self->{ParamObject}->GetParam(Param => 'CharsetID') || '';
    
    if ($CharsetID) {
        # get value
        $Self->{DBObject}->Prepare(SQL => "SELECT charset FROM charset where id = $CharsetID");
        my $Charset = '';
        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
            $Charset = $RowTmp[0];
        }

        # pref update db
        $Self->{DBObject}->SetPreferences(
            UserID => $UserID,
            Key => 'UserCharset',
            Value => $Charset,
        );
        # update SessionID
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'UserCharset',
            Value => $Charset,
        );

        # mk redirect
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "&Action=AgentPreferences",
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'No CharsetID selected!',
            Comment => 'Please one and try it again!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    
    return $Output;
}
# --
sub UpdateTheme {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $UserID = $Self->{UserID};
    my $ThemeID = $Self->{ParamObject}->GetParam(Param => 'ThemeID') || '';

    if ($ThemeID) {
        # get value
        $Self->{DBObject}->Prepare(SQL => "SELECT theme FROM theme where id = $ThemeID");
        my $Theme = '';
        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
            $Theme = $RowTmp[0];
        }

        # pref update db
        $Self->{DBObject}->SetPreferences(
            UserID => $UserID,
            Key => 'UserTheme',
            Value => $Theme,
        );
        # update SessionID
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'UserTheme',
            Value => $Theme,
        );
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'UserThemeID',
            Value => $ThemeID,
        );

        # mk rediect
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "&Action=AgentPreferences",
        );
    }
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'No ThemeID selected!',
            Comment => 'Please one and try it again!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }

    return $Output;
}
# --

1;
