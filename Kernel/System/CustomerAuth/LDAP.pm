# --
# Kernel/System/CustomerAuth/LDAP.pm - provides the ldap authentification
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: LDAP.pm,v 1.18 2006-12-14 13:30:45 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerAuth::LDAP;

use strict;
use Net::LDAP;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = '$Revision: 1.18 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(LogObject ConfigObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # get ldap preferences
    $Self->{Host} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::Host'.$Param{Count})
        || die "Need Customer::AuthModule::LDAPHost in Kernel/Config.pm";
    $Self->{BaseDN} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::BaseDN'.$Param{Count})
        || die "Need Customer::AuthModule::LDAPBaseDN in Kernel/Config.pm";
    $Self->{UID} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::UID'.$Param{Count})
        || die "Need Customer::AuthModule::LDAPBaseDN in Kernel/Config.pm";
    $Self->{SearchUserDN} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::SearchUserDN'.$Param{Count}) || '';
    $Self->{SearchUserPw} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::SearchUserPw'.$Param{Count}) || '';
    $Self->{GroupDN} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::GroupDN'.$Param{Count}) || '';
    $Self->{AccessAttr} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::AccessAttr'.$Param{Count}) || '';
    $Self->{UserAttr} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::UserAttr'.$Param{Count}) || 'DN';
    $Self->{UserSuffix} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::UserSuffix'.$Param{Count}) || '';
    $Self->{DestCharset} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::Charset'.$Param{Count}) || 'utf-8';

    # ldap filter always used
    $Self->{AlwaysFilter} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::AlwaysFilter'.$Param{Count}) || '';
    # Net::LDAP new params
    if ($Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::Params'.$Param{Count})) {
        $Self->{Params} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::Params'.$Param{Count});
    }
    else {
        $Self->{Params} = {};
    }

    return $Self;
}

sub GetOption {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{What}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need What!");
        return;
    }
    # module options
    my %Option = (
        PreAuth => 0,
    );
    # return option
    return $Option{$Param{What}};
}

sub Auth {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(User Pw)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    $Param{User} = $Self->_ConvertTo($Param{User}, $Self->{ConfigObject}->Get('DefaultCharset'));
    $Param{Pw} = $Self->_ConvertTo($Param{Pw}, $Self->{ConfigObject}->Get('DefaultCharset'));
    # get params
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    # remove leading and trailing spaces
    $Param{User} =~ s/^\s+//;
    $Param{User} =~ s/\s+$//;
    # add user suffix
    if ($Self->{UserSuffix}) {
        $Param{User} .= $Self->{UserSuffix};
        # just in case for debug
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "CustomerUser: ($Param{User}) added $Self->{UserSuffix} to username!",
            );
        }
    }
    # just in case for debug!
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "CustomerUser: '$Param{User}' tried to authentificate with Pw: '$Param{Pw}' ".
                "(REMOTE_ADDR: $RemoteAddr)",
        );
    }
    # ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
    my $LDAP = Net::LDAP->new($Self->{Host}, %{$Self->{Params}}) or die "$@";
    my $Result = '';
    if ($Self->{SearchUserDN} && $Self->{SearchUserPw}) {
        $Result = $LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw});
    }
    else {
        $Result = $LDAP->bind();
    }
    if ($Result->code) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "First bind failed! ".$Result->error(),
        );
        return;
    }
    # build filter
    my $Filter = "($Self->{UID}=$Param{User})";
    # prepare filter
    if ($Self->{AlwaysFilter}) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }
    # perform user search
    $Result = $LDAP->search (
        base   => $Self->{BaseDN},
        filter => $Filter,
    );
    if ($Result->code) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Search failed! ".$Result->error,
        );
        return;
    }
    # get whole user dn
    my $UserDN = '';
    foreach my $Entry ($Result->all_entries) {
        $UserDN = $Entry->dn();
    }
    # log if there is no LDAP user entry
    if (!$UserDN) {
        # failed login note
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "CustomerUser: $Param{User} authentification failed, no LDAP entry found!".
                "BaseDN='$Self->{BaseDN}', Filter='$Filter', (REMOTE_ADDR: $RemoteAddr).",
        );
        # take down session
        $LDAP->unbind;
        return;
    }

    # check if user need to be in a group!
    if ($Self->{AccessAttr} && $Self->{GroupDN}) {
        # just in case for debug
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "check for groupdn!",
            );
        }
        # search if we're allowed to
        my $Filter2 = '';
        if ($Self->{UserAttr} eq 'DN') {
            $Filter2 = "($Self->{AccessAttr}=$UserDN)";
        }
        else {
            $Filter2 = "($Self->{AccessAttr}=$Param{User})";
        }
        my $Result2 = $LDAP->search (
            base   => $Self->{GroupDN},
            filter => $Filter2
        );
        if ($Result2->code) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Search failed! base='".$Self->{GroupDN}."', filter='".$Filter2."', ".$Result->error,
            );
            return;
        }
        # extract it
        my $GroupDN = '';
        foreach my $Entry ($Result2->all_entries) {
            $GroupDN = $Entry->dn();
        }
        # log if there is no LDAP entry
        if (!$GroupDN) {
            # failed login note
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "CustomerUser: $Param{User} authentification failed, no LDAP group entry found".
                    "GroupDN='$Self->{GroupDN}', Filter='$Filter2'! (REMOTE_ADDR: $RemoteAddr).",
            );
            # take down session
            $LDAP->unbind;
            return;
        }
    }

    # bind with user data -> real user auth.
    $Result = $LDAP->bind(dn => $UserDN, password => $Param{Pw});
    if ($Result->code) {
        # failed login note
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "CustomerUser: $Param{User} authentification failed: '".$Result->error."' (REMOTE_ADDR: $RemoteAddr).",
        );
        # take down session
        $LDAP->unbind;
        return;
    }
    else {
        # login note
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "CustomerUser: $Param{User} authentification ok (REMOTE_ADDR: $RemoteAddr).",
        );
        # take down session
        $LDAP->unbind;
        return $Param{User};
    }
}

sub _ConvertTo {
    my $Self = shift;
    my $Text = shift;
    my $Charset = shift;
    if (!$Charset || !$Self->{DestCharset}) {
        $Self->{EncodeObject}->Encode(\$Text);
        return $Text;
    }
    if (!defined($Text)) {
        return;
    }
    else {
        return $Self->{EncodeObject}->Convert(
            Text => $Text,
            From => $Charset,
            To => $Self->{DestCharset},
        );
    }
}

1;
