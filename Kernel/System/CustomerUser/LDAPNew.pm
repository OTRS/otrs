# --
# Kernel/System/CustomerUser/LDAPNew.pm - some customer user functions in LDAP (for AD with referals)
# Copyright (C) 2002 Wiktor Wodecki <wiktor.wodecki@net-m.de>
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: LDAPNew.pm,v 1.1 2003-10-07 07:38:16 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerUser::LDAPNew;

use strict;
use Net::LDAP qw(:all);

use vars qw(@ISA $VERSION);
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
    foreach (qw(DBObject ConfigObject LogObject PreferencesObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # module debug level (0|1) 
    $Self->{Debug} = 0;
    # ldap server connection timeout
    $Self->{Timeout} = 120;
    # max shown user a search list
    $Self->{UserSearchListLimit} = 200;

    # get ldap preferences
    $Self->{Host} = $Self->{ConfigObject}->Get('CustomerUser')->{'Params'}->{'Host'}
     || die "Need CustomerUser->Params->Host in Kernel/Config.pm";
    $Self->{BaseDN} = $Self->{ConfigObject}->Get('CustomerUser')->{'Params'}->{'BaseDN'}
     || die "Need CustomerUser->Params->BaseDN in Kernel/Config.pm";
    $Self->{SScope} = $Self->{ConfigObject}->Get('CustomerUser')->{'Params'}->{'SSCOPE'}
     || die "Need CustomerUser->Params->SSCOPE in Kernel/Config.pm";
    $Self->{SearchUserDN} = $Self->{ConfigObject}->Get('CustomerUser')->{'Params'}->{'UserDN'} || '';
    $Self->{SearchUserPw} = $Self->{ConfigObject}->Get('CustomerUser')->{'Params'}->{'UserPw'} || '';

    $Self->{CustomerKey} = $Self->{ConfigObject}->Get('CustomerUser')->{'CustomerKey'}
     || die "Need CustomerUser->CustomerKey in Kernel/Config.pm";
    $Self->{CustomerID} = $Self->{ConfigObject}->Get('CustomerUser')->{'CustomerID'}
     || die "Need CustomerUser->CustomerID in Kernel/Config.pm";

    # ldap connect 
    $Self->{LDAP} = Net::LDAP->new($Self->{Host}, timeout => $Self->{Timeout}) or die "$@";
    # debug
    if ($Self->{Debug}) {
        $Self->{LogObject}->Log(
          Priority => 'debug',
          Message => "connect to $Self->{Host}",
        );
    }
    # ldap bind (maybe with SearchUserDN and SearchUserPw)
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
    return $Self;
}
# --
sub CustomerName {
    my $Self = shift;
    my %Param = @_;
    my $Name = '';
    # --
    # check needed stuff
    # --
    if (!$Param{UserLogin}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserLogin!");
        return;
    }
    # --
    # build filter
    # --
    my $Filter = "($Self->{CustomerKey}=$Param{UserLogin})";
    # --
    # perform user search
    # --
    my @Result = $Self->_LDAPSearch(
        base => $Self->{BaseDN},
        scope => $Self->{SScope},
        filter => $Filter, 
        sizelimit => $Self->{UserSearchListLimit},
    );
    foreach my $Result (@Result) {
      foreach my $entry ($Result->all_entries) {
        foreach (@{$Self->{ConfigObject}->Get('CustomerUser')->{CustomerUserNameFields}}) {
            if (!$Name) {
                $Name = $entry->get_value($_);
            }
            else {
                $Name .= ' '.$entry->get_value($_);
            }
        }
      }
    }
    return $Name;
}   
# --
sub CustomerSearch {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{Search} && !$Param{UserLogin} && !$Param{PostMasterSearch}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Search, UserLogin or PostMasterSearch!");
        return;
    }
    # --
    # build filter
    # --
    my $Filter = '';
    if ($Param{Search}) {
        if ($Self->{ConfigObject}->Get('CustomerUser')->{CustomerUserSearchFields}) {
            $Filter = '(|';
            foreach (@{$Self->{ConfigObject}->Get('CustomerUser')->{CustomerUserSearchFields}}) {
                $Filter.= "($_=$Param{Search})";
            }
            $Filter .= ')';
        }
        else {
            $Filter = "($Self->{CustomerKey}=$Param{Search})";
        }
    }
    elsif ($Param{PostMasterSearch}) {
        if ($Self->{ConfigObject}->Get('CustomerUser')->{CustomerUserPostMasterSearchFields}) {
            $Filter = '(|';
            foreach (@{$Self->{ConfigObject}->Get('CustomerUser')->{CustomerUserPostMasterSearchFields}}) {
                $Filter.= "($_=$Param{PostMasterSearch})";
            }
            $Filter .= ')';
        }
    }
    elsif ($Param{UserLogin}) {
        $Filter = "($Self->{CustomerKey}=$Param{UserLogin})";
    }
    # --
    # perform user search
    # --
    my @Result = $Self->_LDAPSearch(
        base => $Self->{BaseDN},
        scope => $Self->{SScope},
        filter => $Filter, 
        sizelimit => $Self->{UserSearchListLimit},
    );
    # --
    # log ldap errors 
    # --
    my %Users = ();
    foreach my $Result (@Result) {
        foreach my $entry ($Result->all_entries) {
            my $CustomerString = '';
            foreach (@{$Self->{ConfigObject}->Get('CustomerUser')->{CustomerUserListFields}}) {
                my $Value = $entry->get_value($_);
                if ($Value) {
                    if ($_ =~ /^targetaddress$/i) {
                        $Value =~ s/SMTP:(.*)/$1/;
                    }
                    $CustomerString .= $Value.' ';
                }
            }
            $CustomerString =~ s/^(.*\s)(.+?\@.+?\..+?)(\s|)$/"$1" <$2>/;
            if ($entry->get_value($Self->{CustomerKey})) {
                $Users{$entry->get_value($Self->{CustomerKey})} = $CustomerString;
            }
        }
    }
    return %Users;
}   
# --
sub CustomerUserList {
    my $Self = shift;
    my %Param = @_;
    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;
    # --
    # perform user search
    # --
    my @Result = $Self->_LDAPSearch(
        base => $Self->{BaseDN},
        scope => $Self->{SScope},
        filter => "($Self->{CustomerKey}=*)",
        sizelimit => $Self->{UserSearchListLimit},
    );
    my %Users = ();
    foreach my $Result (@Result) {
      foreach my $entry ($Result->all_entries) {
        my $CustomerString = '';
        foreach (qw(CustomerKey CustomerID)) {
            my $Value = $entry->get_value($Self->{ConfigObject}->Get('CustomerUser')->{$_});
            if ($Value) {
                $CustomerString .= $Value.' ';
            }
        }
        $Users{$entry->get_value($Self->{CustomerKey})} = $CustomerString;
      }
    }
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
    # perform user search
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
        $Filter = "($Self->{CustomerKey}=$Param{User})";
    }
    my @Result = $Self->_LDAPSearch(
        base => $Self->{BaseDN},
        scope => $Self->{SScope},
        filter => $Filter, 
        attrs => $attrs,
    );
    # --
    # get first entry
    # --
    my $Result2 = '';
    if ($Result[0]) {
        $Result2 = $Result[0]->entry(0);
    }
    if (!$Result2) {
        return;
    }
    # --
    # get customer user info
    # --
    foreach my $Entry (@{$Self->{ConfigObject}->Get('CustomerUser')->{Map}}) {
        my $Value = $Result2->get_value($Entry->[2]) || '';
        if ($Value && $Entry->[2] =~ /^targetaddress$/i) {
            $Value =~ s/SMTP:(.*)/$1/;
        }
        $Data{$Entry->[0]} = $Value;
    }
    # --
    # check data
    # --
    if (! exists $Data{UserLogin} && $Param{User}) {
#        $Self->{LogObject}->Log(
#          Priority => 'notice',
#          Message => "Panic! No UserData for customer user: '$Param{User}'!!!",
#        );
        return;
    }
    if (! exists $Data{UserLogin} && $Param{CustomerID}) {
#        $Self->{LogObject}->Log(
#          Priority => 'notice',
#          Message => "Panic! No UserData for customer id: '$Param{CustomerID}'!!!",
#        );
        return;
    }
    # compat!
    $Data{UserID} = $Data{UserLogin};
    # --
    # get preferences
    # --
    my %Preferences = $Self->{PreferencesObject}->GetPreferences(UserID => $Data{UserID});

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
sub DESTROY {
    my $Self = shift;
    my %Param = @_;
    # take down session
    $Self->{LDAP}->unbind;
    return 1;
}
# --
1;
