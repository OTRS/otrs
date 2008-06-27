# --
# Kernel/System/CustomerUser/LDAP.pm - some customer user functions in LDAP
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LDAP.pm,v 1.42 2008-06-27 17:11:06 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::CustomerUser::LDAP;

use strict;
use warnings;
use Net::LDAP;
use Kernel::System::Encode;
use Kernel::System::Cache;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.42 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject PreferencesObject CustomerUserMap)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # max shown user a search list
    $Self->{UserSearchListLimit} = $Self->{CustomerUserMap}->{CustomerUserSearchListLimit} || 200;

    # get ldap preferences
    if ( defined( $Self->{CustomerUserMap}->{Params}->{Die} ) ) {
        $Self->{Die} = $Self->{CustomerUserMap}->{Params}->{Die};
    }
    else {
        $Self->{Die} = 1;
    }

    # host
    if ( $Self->{CustomerUserMap}->{Params}->{Host} ) {
        $Self->{Host} = $Self->{CustomerUserMap}->{Params}->{Host};
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need CustomerUser->Params->Host in Kernel/Config.pm',
        );
        return;
    }

    # base dn
    if ( defined $Self->{CustomerUserMap}->{Params}->{BaseDN} ) {
        $Self->{BaseDN} = $Self->{CustomerUserMap}->{Params}->{BaseDN};
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need CustomerUser->Params->BaseDN in Kernel/Config.pm',
        );
        return;
    }

    # scope
    if ( $Self->{CustomerUserMap}->{Params}->{SSCOPE} ) {
        $Self->{SScope} = $Self->{CustomerUserMap}->{Params}->{SSCOPE};
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need CustomerUser->Params->SSCOPE in Kernel/Config.pm',
        );
        return;
    }

    # search user
    $Self->{SearchUserDN} = $Self->{CustomerUserMap}->{Params}->{UserDN} || '';
    $Self->{SearchUserPw} = $Self->{CustomerUserMap}->{Params}->{UserPw} || '';

    # customer key
    if ( $Self->{CustomerUserMap}->{CustomerKey} ) {
        $Self->{CustomerKey} = $Self->{CustomerUserMap}->{CustomerKey};
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need CustomerUser->CustomerKey in Kernel/Config.pm',
        );
        return;
    }

    # customer id
    if ( $Self->{CustomerUserMap}->{CustomerID} ) {
        $Self->{CustomerID} = $Self->{CustomerUserMap}->{CustomerID};
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need CustomerUser->CustomerID in Kernel/Config.pm',
        );
        return;
    }

    # ldap filter always used
    $Self->{AlwaysFilter} = $Self->{CustomerUserMap}->{Params}->{AlwaysFilter} || '';

    # Net::LDAP new params
    if ( $Self->{CustomerUserMap}->{Params}->{Params} ) {
        $Self->{Params} = $Self->{CustomerUserMap}->{Params}->{Params};
    }
    else {
        $Self->{Params} = {};
    }

    # ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
    $Self->{LDAP} = Net::LDAP->new( $Self->{Host}, %{ $Self->{Params} } );
    if ( !$Self->{LDAP} ) {
        if ( $Self->{Die} ) {
            die "Can't connect to $Self->{Host}: $@";
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't connect to $Self->{Host}: $@",
            );
            return;
        }
    }
    my $Result = '';
    if ( $Self->{SearchUserDN} && $Self->{SearchUserPw} ) {
        $Result
            = $Self->{LDAP}->bind( dn => $Self->{SearchUserDN}, password => $Self->{SearchUserPw} );
    }
    else {
        $Result = $Self->{LDAP}->bind();
    }
    if ( $Result->code ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "First bind failed! " . $Result->error(),
        );
        return;
    }

    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    # cache object
    if ( $Self->{CustomerUserMap}->{CacheTTL} ) {
        $Self->{CacheObject} = Kernel::System::Cache->new(%Param);
    }
    $Self->{SourceCharset} = $Self->{CustomerUserMap}->{Params}->{SourceCharset} || '';
    $Self->{DestCharset}   = $Self->{CustomerUserMap}->{Params}->{DestCharset}   || '';
    $Self->{ExcludePrimaryCustomerID}
        = $Self->{CustomerUserMap}->{CustomerUserExcludePrimaryCustomerID} || 0;
    $Self->{SearchPrefix} = $Self->{CustomerUserMap}->{CustomerUserSearchPrefix};
    if ( !defined $Self->{SearchPrefix} ) {
        $Self->{SearchPrefix} = '';
    }
    $Self->{SearchSuffix} = $Self->{CustomerUserMap}->{CustomerUserSearchSuffix};
    if ( !defined $Self->{SearchSuffix} ) {
        $Self->{SearchSuffix} = '*';
    }

    # cache key prefix
    if ( !defined $Param{Count} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => 'Need Count param, update Kernel/System/CustomerUser.pm to v1.32 or higher!',
        );
        $Param{Count} = '';
    }
    $Self->{CacheType} = 'CustomerUser' . $Param{Count};

    # get valid filter if used
    $Self->{ValidFilter} = $Self->{CustomerUserMap}->{CustomerUserValidFilter} || '';

    return $Self;
}

sub CustomerName {
    my ( $Self, %Param ) = @_;

    my $Name = '';

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserLogin!' );
        return;
    }

    # build filter
    my $Filter = "($Self->{CustomerKey}=$Param{UserLogin})";

    # prepare filter
    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Name = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => 'CustomerName::' . $Filter,
        );
        if ( defined($Name) ) {
            return $Name;
        }
    }

    # perform user search
    my $Result = $Self->{LDAP}->search(
        base      => $Self->{BaseDN},
        scope     => $Self->{SScope},
        filter    => $Filter,
        sizelimit => $Self->{UserSearchListLimit},
    );
    if ( $Result->code ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Search failed! ' . $Result->error,
        );
        return;
    }
    for my $Entry ( $Result->all_entries ) {
        for my $Field ( @{ $Self->{CustomerUserMap}->{CustomerUserNameFields} } ) {
            if ( defined( $Entry->get_value($Field) ) ) {
                if ( !$Name ) {
                    $Name = $Self->_Convert( $Entry->get_value($Field) );
                }
                else {
                    $Name .= ' ' . $Self->_Convert( $Entry->get_value($Field) );
                }
            }
        }
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => 'CustomerName::' . $Filter,
            Value => $Name,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }
    return $Name;
}

sub CustomerSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Search} && !$Param{UserLogin} && !$Param{PostMasterSearch} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Search, UserLogin or PostMasterSearch!'
        );
        return;
    }

    # build filter
    my $Filter = '';
    if ( $Param{Search} ) {
        my $Count = 0;
        my @Parts = split( /\+/, $Param{Search}, 6 );
        for my $Part (@Parts) {
            $Part = $Self->{SearchPrefix} . $Part . $Self->{SearchSuffix};
            $Part =~ s/%%/%/g;
            $Part =~ s/\*\*/*/g;
            $Count++;

            if ( $Self->{CustomerUserMap}->{CustomerUserSearchFields} ) {
                $Filter .= '(|';
                for my $Field ( @{ $Self->{CustomerUserMap}->{CustomerUserSearchFields} } ) {
                    $Filter .= "($Field=" . $Self->_ConvertTo($Part) . ")";
                }
                $Filter .= ')';
            }
            else {
                $Filter .= "($Self->{CustomerKey}=$Part)";
            }
        }
        if ( $Count > 1 ) {
            $Filter = "(&$Filter)";
        }
    }
    elsif ( $Param{PostMasterSearch} ) {
        if ( $Self->{CustomerUserMap}->{CustomerUserPostMasterSearchFields} ) {
            $Filter = '(|';
            for my $Field ( @{ $Self->{CustomerUserMap}->{CustomerUserPostMasterSearchFields} } ) {
                $Filter .= "($Field=$Param{PostMasterSearch})";
            }
            $Filter .= ')';
        }
    }
    elsif ( $Param{UserLogin} ) {
        $Filter = "($Self->{CustomerKey}=$Param{UserLogin})";
    }

    # prepare filter
    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # add valid filter
    if ( $Self->{ValidFilter} ) {
        $Filter = "(&$Filter$Self->{ValidFilter})";
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Users = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => 'CustomerSearch::' . $Filter,
        );
        if ($Users) {
            return %{$Users};
        }
    }

    # perform user search
    my $Result = $Self->{LDAP}->search(
        base      => $Self->{BaseDN},
        scope     => $Self->{SScope},
        filter    => $Filter,
        sizelimit => $Self->{UserSearchListLimit},
    );

    # log ldap errors
    if ( $Result->code ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Result->error,
        );
    }
    my %Users = ();
    for my $entry ( $Result->all_entries ) {
        my $CustomerString = '';
        for my $Field ( @{ $Self->{CustomerUserMap}->{CustomerUserListFields} } ) {
            my $Value = $Self->_Convert( $entry->get_value($Field) );
            if ($Value) {
                if ( $_ =~ /^targetaddress$/i ) {
                    $Value =~ s/SMTP:(.*)/$1/;
                }
                $CustomerString .= $Value . ' ';
            }
        }
        $CustomerString =~ s/^(.*)\s(.+?\@.+?\..+?)(\s|)$/"$1" <$2>/;
        if ( defined( $entry->get_value( $Self->{CustomerKey} ) ) ) {
            $Users{ $Self->_Convert( $entry->get_value( $Self->{CustomerKey} ) ) }
                = $CustomerString;
        }
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => 'CustomerSearch::' . $Filter,
            Value => \%Users,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }
    return %Users;
}

sub CustomerUserList {
    my ( $Self, %Param ) = @_;

    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;

    # prepare filter
    my $Filter = "($Self->{CustomerKey}=*)";
    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # add valid filter
    if ( $Self->{ValidFilter} && $Valid ) {
        $Filter = "(&$Filter$Self->{ValidFilter})";
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Users = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => "CustomerUserList::$Filter",
        );
        if ($Users) {
            return %{$Users};
        }
    }

    # perform user search
    my $Result = $Self->{LDAP}->search(
        base      => $Self->{BaseDN},
        scope     => $Self->{SScope},
        filter    => $Filter,
        sizelimit => $Self->{UserSearchListLimit},
    );

    # log ldap errors
    if ( $Result->code() ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Result->error(),
        );
    }
    my %Users = ();
    for my $entry ( $Result->all_entries ) {
        my $CustomerString = '';
        for my $Field (qw(CustomerKey CustomerID)) {
            $CustomerString
                .= $Self->_Convert( $entry->get_value( $Self->{CustomerUserMap}->{$Field} ) ) . ' ';
        }
        $Users{ $Self->_Convert( $entry->get_value( $Self->{CustomerKey} ) ) } = $CustomerString;
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => "CustomerUserList::$Filter",
            Value => \%Users,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }
    return %Users;
}

sub CustomerIDs {
    my ( $Self, %Param ) = @_;

    my @CustomerIDs = ();

    # check needed stuff
    if ( !$Param{User} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need User!' );
        return;
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $CustomerIDs = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => "CustomerIDs::$Param{User}",
        );
        if ($CustomerIDs) {
            return @{$CustomerIDs};
        }
    }

    # get customer data
    my %Data = $Self->CustomerUserDataGet( User => $Param{User}, );

    # there are multi customer ids
    if ( $Data{UserCustomerIDs} ) {
        for my $Split ( ';', ',', '|' ) {
            if ( $Data{UserCustomerIDs} =~ /$Split/ ) {
                my @IDs = split( /$Split/, $Data{UserCustomerIDs} );
                for my $ID (@IDs) {
                    $ID =~ s/^\s+//g;
                    $ID =~ s/\s+$//g;
                    push( @CustomerIDs, $ID );
                }
            }
            else {
                $Data{UserCustomerIDs} =~ s/^\s+//g;
                $Data{UserCustomerIDs} =~ s/\s+$//g;
                push( @CustomerIDs, $Data{UserCustomerIDs} );
            }
        }
    }

    # use also the primary customer id
    if ( $Data{UserCustomerID} && !$Self->{ExcludePrimaryCustomerID} ) {
        push( @CustomerIDs, $Data{UserCustomerID} );
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => 'CustomerIDs::' . $Param{User},
            Value => \@CustomerIDs,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }
    return @CustomerIDs;
}

sub CustomerUserDataGet {
    my ( $Self, %Param ) = @_;

    my %Data;

    # check needed stuff
    if ( !$Param{User} && !$Param{CustomerID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need User or CustomerID!' );
        return;
    }

    # perform user search
    my $attrs = '';
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        $attrs .= "\'$Entry->[2]\',";
    }
    $attrs = substr $attrs, 0, -1;
    my $Filter = '';
    if ( $Param{CustomerID} ) {
        $Filter = "($Self->{CustomerID}=$Param{CustomerID})";
    }
    else {
        $Filter = "($Self->{CustomerKey}=$Param{User})";
    }

    # prepare filter
    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Data = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => 'CustomerUserDataGet::' . $Filter,
        );
        if ($Data) {
            return %{$Data};
        }
    }

    # perform search
    my $Result = $Self->{LDAP}->search(
        base   => $Self->{BaseDN},
        scope  => $Self->{SScope},
        filter => $Filter,
        attrs  => $attrs,
    );

    # log ldap errors
    if ( $Result->code() ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Result->error(),
        );
        return;
    }

    # get first entry
    my $Result2 = $Result->entry(0);
    if ( !$Result2 ) {
        return;
    }

    # get customer user info
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        my $Value = $Self->_Convert( $Result2->get_value( $Entry->[2] ) ) || '';
        if ( $Value && $Entry->[2] =~ /^targetaddress$/i ) {
            $Value =~ s/SMTP:(.*)/$1/;
        }
        $Data{ $Entry->[0] } = $Value;
    }

    # check data
    if ( !exists $Data{UserLogin} && $Param{User} ) {
        return;
    }
    if ( !exists $Data{UserLogin} && $Param{CustomerID} ) {
        return;
    }

    # compat!
    $Data{UserID} = $Data{UserLogin};

    # get preferences
    my %Preferences = $Self->{PreferencesObject}->GetPreferences( UserID => $Data{UserID} );

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => 'CustomerUserDataGet::' . $Filter,
            Value => { %Data, %Preferences },
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }

    # return data
    return ( %Data, %Preferences );
}

sub CustomerUserAdd {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Customer backend is ro!' );
        return;
    }
    $Self->{LogObject}->Log( Priority => 'error', Message => 'Not supported for this module!' );
    return;
}

sub CustomerUserUpdate {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Customer backend is ro!' );
        return;
    }
    $Self->{LogObject}->Log( Priority => 'error', Message => 'Not supported for this module!' );
    return;
}

sub SetPassword {
    my ( $Self, %Param ) = @_;

    my $Pw = $Param{PW} || '';

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Customer backend is ro!' );
        return;
    }
    $Self->{LogObject}->Log( Priority => 'error', Message => 'Not supported for this module!' );
    return;
}

sub GenerateRandomPassword {
    my ( $Self, %Param ) = @_;

    # Generated passwords are eight characters long by default.
    my $Size = $Param{Size} || 8;

    # The list of characters that can appear in a randomly generated password.
    # Note that users can put any character into a password they choose themselves.
    my @PwChars
        = ( 0 .. 9, 'A' .. 'Z', 'a' .. 'z', '-', '_', '!', '@', '#', '$', '%', '^', '&', '*' );

    # The number of characters in the list.
    my $PwCharsLen = scalar(@PwChars);

    # Generate the password.
    my $Password = '';
    for ( my $i = 0; $i < $Size; $i++ ) {
        $Password .= $PwChars[ rand($PwCharsLen) ];
    }

    # Return the password.
    return $Password;
}

sub _Convert {
    my ( $Self, $Text ) = @_;

    if ( !$Self->{SourceCharset} || !$Self->{DestCharset} ) {
        return $Text;
    }
    if ( !defined($Text) ) {
        return;
    }
    else {
        return $Self->{EncodeObject}->Convert(
            Text => $Text,
            From => $Self->{SourceCharset},
            To   => $Self->{DestCharset},
        );
    }
}

sub _ConvertTo {
    my ( $Self, $Text ) = @_;

    if ( !$Self->{SourceCharset} || !$Self->{DestCharset} ) {
        $Self->{EncodeObject}->Encode( \$Text );
        return $Text;
    }
    if ( !defined($Text) ) {
        return;
    }
    else {
        return $Self->{EncodeObject}->Convert(
            Text => $Text,
            To   => $Self->{SourceCharset},
            From => $Self->{DestCharset},
        );
    }
}

sub Destroy {
    my ( $Self, %Param ) = @_;

    # take down session
    if ( $Self->{LDAP} ) {
        $Self->{LDAP}->unbind;
    }
    return 1;
}

1;
