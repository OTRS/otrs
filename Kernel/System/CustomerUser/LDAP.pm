# --
# Kernel/System/CustomerUser/LDAP.pm - some customer user functions in LDAP
# Copyright (C) 2002 Wiktor Wodecki <wiktor.wodecki@net-m.de>
# --
# $Id: LDAP.pm,v 1.1 2003-01-19 15:57:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerUser::LDAP;

use strict;
use Net::LDAP;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # --
    # check needed objects
    # --
    foreach (qw(DBObject ConfigObject LogObject PreferencesObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # --
    # Debug 0=off 1=on
    # --
    $Self->{Debug} = 0;

    # --
    # get ldap preferences
    # --
    $Self->{Host} = $Self->{ConfigObject}->Get('CustomerUser')->{'Params'}->{'Host'}
     || die "Need CustomerUser->Params->Host in Kernel/Config.pm";
    $Self->{BaseDN} = $Self->{ConfigObject}->Get('CustomerUser')->{'Params'}->{'BaseDN'}
     || die "Need CustomerUser->Params->BaseDN in Kernel/Config.pm";
    $Self->{SScope} = $Self->{ConfigObject}->Get('CustomerUser')->{'Params'}->{'SSCOPE'}
     || die "Need CustomerUser->Params->SSCOPE in Kernel/Config.pm";
    $Self->{SearchUserDN} = $Self->{ConfigObject}->Get('CustomerUser')->{'Params'}->{'UserDN'} || '';
    $Self->{SearchUserPw} = $Self->{ConfigObject}->Get('CustomerUser')->{'Params'}->{'UserPW'} || '';

    $Self->{UserID} = $Self->{ConfigObject}->Get('CustomerUser')->{'CustomerKey'}
     || die "Need CustomerUser->CustomerKey in Kernel/Config.pm";
    $Self->{CustomerID} = $Self->{ConfigObject}->Get('CustomerUser')->{'CustomerID'}
     || die "Need CustomerUser->CustomerID in Kernel/Config.pm";

    return $Self;
}
# --
sub CustomerList {
    my $Self = shift;
    my %Param = @_;
    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;
    # --
    # ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
    # --
    my $LDAP = Net::LDAP->new($Self->{Host}) or die "$@";
    if (!$LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw})) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          Message => "First bind failed!",
        );
        return;
    }

    # --
    # perform user search
    # FIXME: check for valid customers
    # --
    my $Result = $LDAP->search (
        base => $Self->{BaseDN},
        scope => $Self->{SScope},
        filter => "($Self->{UserID}=*)",
    );
    $Result->code && die $Result->error;
    my %Users = ();
    foreach my $entry ($Result->all_entries) {
        my $CustomerString = '';
        foreach (@{$Self->{ConfigObject}->Get('CustomerUser')->{CustomerListFileds}}) {
            $CustomerString .= $entry->get_value($_).' ';
        }
        $Users{$entry->get_value($Self->{CustomerID})} = $CustomerString;
    }
    # --
    # take down session
    # --
    $LDAP->unbind;

    return %Users;
}
# --
sub CustomerUserList {
    my $Self = shift;
    my %Param = @_;
    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;
    # --
    # ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
    # --
    my $LDAP = Net::LDAP->new($Self->{Host}) or die "$@";
    if (!$LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw})) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          Message => "First bind failed!",
        );
        return;
    }
    # --
    # perform user search
    # FIXME: check for valid customers
    # --
    my $Result = $LDAP->search (
        base => $Self->{BaseDN},
        scope => $Self->{SScope},
        filter => "($Self->{UserID}=*)",
    );
    $Result->code && die $Result->error;
    my %Users = ();
    foreach my $entry ($Result->all_entries) {
        my $CustomerString = '';
        foreach (@{$Self->{ConfigObject}->Get('CustomerUser')->{CustomerListFileds}}) {
            $CustomerString .= $entry->get_value($_).' ';
        }
        $Users{$entry->get_value($Self->{UserID})} = $CustomerString;
    }
    # --
    # take down session
    # --
    $LDAP->unbind;

    return %Users;
}
# --
sub CustomerUserDataGet {
    my $Self = shift;
    my %Param = @_;
    my %Data;
    # --
    # check needed stuff
    # --
    if (!$Param{User} && !$Param{CustomerID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need User or CustomerID!");
        return;
    }
    # --
    # ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
    # --
    my $LDAP = Net::LDAP->new($Self->{Host}) or die "$@";
    if (!$LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw})) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          Message => "First bind failed!",
        );
        return;
    }

    # --
    # perform user search
    # FIXME: check for valid customers
    # --
    my $attrs = '';
    foreach my $Entry (@{$Self->{ConfigObject}->Get('CustomerUser')->{Map}}) {
        $attrs .= "\'$Entry->[2]\',";
    }
    $attrs = substr $attrs,0,-1;
    my $Filter = '';
    if ($Param{CustomerID}) {
        $Filter = "($Self->{CustomerID}=$Param{CustomerID})";
    }
    else {
        $Filter = "($Self->{UserID}=$Param{User})";
    }
    my $Result = $LDAP->search (
        base => $Self->{BaseDN},
        scope => $Self->{SScope},
        filter => $Filter, 
        attrs => $attrs,
    );
    my $result2 = $Result->entry(0);

    foreach my $Entry (@{$Self->{ConfigObject}->Get('CustomerUser')->{Map}}) {
        $Data{$Entry->[0]} = $result2->get_value($Entry->[2]) || '';
    }

    # --
    # check data
    # --
    if (! exists $Data{UserLogin} && $Param{User}) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "Panic! No UserData for customer user: '$Param{User}'!!!",
        );
        # --
        # take down session
        # --
        $LDAP->unbind;
        return;
    }
    if (! exists $Data{UserLogin} && $Param{CustomerID}) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "Panic! No UserData for customer id: '$Param{CustomerID}'!!!",
        );
        # --
        # take down session
        # --
        $LDAP->unbind;
        return;
    }
    # compat!
    $Data{UserID} = $Data{UserLogin};
    # --
    # get preferences
    # --
    my %Preferences = $Self->{PreferencesObject}->GetPreferences(UserID => $Data{UserID});
    # --
    # take down session
    # --
    $LDAP->unbind;

    # return data
    return (%Data, %Preferences);
}
# --
sub CustomerUserAdd {
    my $Self = shift;
    my %Param = @_;
    $Self->{LogObject}->Log(Priority => 'error', Message => "Not supported for this module!");
    return;
}
# --
sub CustomerUserUpdate {
    my $Self = shift;
    my %Param = @_;
    $Self->{LogObject}->Log(Priority => 'error', Message => "Not supported for this module!");
    return;
}   
# --
sub SetPassword {
    my $Self = shift;
    my %Param = @_;
    $Self->{LogObject}->Log(Priority => 'error', Message => "Not supported for this module!");
    return;
}
# --
sub GetGroups {
    return;
}
# --
sub GenerateRandomPassword {
    my $Self = shift;
    my %Param = @_;
    # Generated passwords are eight characters long by default.
    my $Size = $Param{Size} || 8;

    # The list of characters that can appear in a randomly generated password.
    # Note that users can put any character into a password they choose themselves.
    my @PwChars = (0..9, 'A'..'Z', 'a'..'z', '-', '_', '!', '@', '#', '$', '%', '^', '&', '*');

    # The number of characters in the list.
    my $PwCharsLen = scalar(@PwChars);

    # Generate the password.
    my $Password = '';
    for ( my $i=0 ; $i<$Size ; $i++ ) {
        $Password .= $PwChars[rand($PwCharsLen)];
    }

    # Return the password.
    return $Password;
}
# --

1;
