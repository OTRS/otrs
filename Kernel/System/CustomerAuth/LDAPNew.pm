# --
# Kernel/System/CustomerAuth/LDAPNew.pm - provides the ldap authentification (for AD with referals) 
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: LDAPNew.pm,v 1.1 2003-10-07 08:11:45 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
# Note: 
# available objects are: ConfigObject, LogObject and DBObject
# --

package Kernel::System::CustomerAuth::LDAPNew; 

use strict;
use Net::LDAP qw(:all);

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
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

    # module debug 0=off 1=on
    $Self->{Debug} = 0;
    # ldap server connection timeout
    $Self->{Timeout} = 120;

    # get ldap preferences
    $Self->{Host} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::Host')
     || die "Need Customer::AuthModule::LDAPHost in Kernel/Config.pm";
    $Self->{BaseDN} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::BaseDN')
     || die "Need Customer::AuthModule::LDAPBaseDN in Kernel/Config.pm";
    $Self->{UID} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::UID')
     || die "Need Customer::AuthModule::LDAPBaseDN in Kernel/Config.pm";
    $Self->{SearchUserDN} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::SearchUserDN') || '';
    $Self->{SearchUserPw} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::SearchUserPw') || '';
    $Self->{GroupDN} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::GroupDN') || '';
    $Self->{AccessAttr} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::AccessAttr') || '';
    $Self->{UserAttr} = $Self->{ConfigObject}->Get('Customer::AuthModule::LDAP::UserAttr') || 'DN';
   
    return $Self;
}
# --
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
# --
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
    # get params
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'Got no REMOTE_ADDR env!';
    # just in case for debug!
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: '$Param{User}' tried to login with Pw: '$Param{Pw}' (REMOTE_ADDR: $RemoteAddr)",
        );
    }
    # ldap connect
    $Self->{LDAP} = Net::LDAP->new($Self->{Host}, timeout => $Self->{Timeout}) or die "$@";
    # debug
    if ($Self->{Debug}) {
        $Self->{LogObject}->Log(
          Priority => 'debug',
          Message => "connect to $Self->{Host}",
        );
    }
    # bind
    if (!$Self->{LDAP}->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw})) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          Message => "First bind failed!",
        );
        return;
    }
    # debug
    if ($Self->{Debug}) {
        $Self->{LogObject}->Log(
          Priority => 'debug',
          Message => "bind with dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw}",
        );
    }
    # perform user search
    my $Filter = "($Self->{UID}=$Param{User})";
    my @Result = $Self->_LDAPSearch(
        base   => $Self->{BaseDN},
        filter => $Filter, 
    ); 
    # get whole user dn
    my $UserDN = '';
    foreach my $Result (@Result) {
        foreach my $Entry ($Result->all_entries) {
            $UserDN = $Entry->dn();
        }
    }
    # log if there is no LDAP user entry
    if (!$UserDN) {
        # failed login note
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $Param{User} login failed, no LDAP entry found!". 
            "BaseDN='$Self->{BaseDN}', Filter='$Filter', (REMOTE_ADDR: $RemoteAddr).",
        );
        # take down session
        $Self->{LDAP}->unbind;
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
        my @Result2 = $Self->_LDAPSearch (
            base   => $Self->{GroupDN},
            filter => $Filter2,
        );
        # extract it
        my $GroupDN = '';
        foreach my $Result2 (@Result2) {
            foreach my $Entry ($Result2->all_entries) {
                $GroupDN = $Entry->dn();
            }
        }
        # log if there is no LDAP entry
        if (!$GroupDN) {
            # failed login note
            $Self->{LogObject}->Log(
              Priority => 'notice',
              Message => "User: $Param{User} login failed, no LDAP group entry found".
                "GroupDN='$Self->{GroupDN}', Filter='$Filter2'! (REMOTE_ADDR: $RemoteAddr).",
            );
            # take down session 
            $Self->{LDAP}->unbind;
            return;
        }
    }        
    
    # bind with user data -> real user auth.
    my $Result = $Self->{LDAP}->bind(dn => $UserDN, password => $Param{Pw});
    if ($Result->code) {
        # failed login note
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $Param{User} ($UserDN) login failed: '".$Result->error."' (REMOTE_ADDR: $RemoteAddr).",
        );
        # take down session
        $Self->{LDAP}->unbind;
        return;
    }
    else {
        # login note
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "User: $Param{User} ($UserDN) logged in (REMOTE_ADDR: $RemoteAddr).",
        );
        # take down session
        $Self->{LDAP}->unbind;
        return $Param{User};
    }
}
# --
sub _LDAPSearch {
    my $Self = shift;
    my %Param = @_;
    my @AllResults = ();
    # perform search
    my $Result = $Self->{LDAP}->search(
        %Param,
    );
    # proccess ldap (v3) referrals
    if ($Result->code() == LDAP_REFERRAL || $Result->code() == 9) {
#        my @referrals = $Result->referrals;
        # debug
        if ($Self->{Debug}) {
            $Self->{LogObject}->Log(
              Priority => 'debug',
              Message => "referrals detected: ".$Result->error(),
            );
        }
        my @referrals = $Result->error() =~ m#(ldap://\S+)#gi;
        use URI::ldap;
        foreach my $refrl (@referrals){
            my $Link = URI::ldap->new($refrl);
            my $LDAP = Net::LDAP->new($Link->host(), port => $Link->port(), timeout => $Self->{Timeout}) ||
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => $Link->host().": $@",
            );
            # debug
            if ($Self->{Debug}) {
                $Self->{LogObject}->Log(
                  Priority => 'debug',
                  Message => "connect to ".$Link->host().":".$Link->port(),
                );
            }
            if ($LDAP) {
              if (!$LDAP->bind(dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw})) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Referral bind failed!",
                );
                return;
              }
              # debug
              if ($Self->{Debug}) {
                  $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "bind with dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw}",
                  );
              }
              # new result object
              my $NewResult = $LDAP->search(
                  %Param,
                  base => $Link->dn(),
              );
              # debug
              if ($Self->{Debug}) {
                  $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "search with filter $Param{filter}, results: ".$NewResult->all_entries(),
                  );
              }
              # log ldap errors 
#              if ($NewResult->error()) {
#                  $Self->{LogObject}->Log(
#                      Priority => 'error',
#                      Message => $NewResult->error(),
#                  );
#                  return;
#              }
              # add results with min 1 entry to array
              if ($NewResult->all_entries()) {
                   push (@AllResults, $NewResult);
              }
            }
        }
    }
    # log ldap errors 
    elsif ($Result->code()) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => $Result->error(),
        );
        return;
    }
    else {
        push (@AllResults, $Result);
    }

    # return result
    return @AllResults;
}
# --

1;
