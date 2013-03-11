# --
# Kernel/System/CustomerUser/LDAP.pm - some customer user functions in LDAP
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerUser::LDAP;

use strict;
use warnings;

use Net::LDAP;

use Kernel::System::Cache;
use Kernel::System::Time;

use vars qw(@ISA $VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (
        qw(DBObject ConfigObject LogObject PreferencesObject CustomerUserMap MainObject EncodeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{TimeObject} = Kernel::System::Time->new( %{$Self} );

    # max shown user a search list
    $Self->{UserSearchListLimit} = $Self->{CustomerUserMap}->{CustomerUserSearchListLimit} || 200;

    # get ldap preferences
    $Self->{Die} = 0;
    if ( defined $Self->{CustomerUserMap}->{Params}->{Die} ) {
        $Self->{Die} = $Self->{CustomerUserMap}->{Params}->{Die};
    }

    # params
    if ( $Self->{CustomerUserMap}->{Params}->{Params} ) {
        $Self->{Params} = $Self->{CustomerUserMap}->{Params}->{Params};
    }

    # Net::LDAP new params
    elsif ( $Self->{ConfigObject}->Get( 'AuthModule::LDAP::Params' . $Param{Count} ) ) {
        $Self->{Params} = $Self->{ConfigObject}->Get( 'AuthModule::LDAP::Params' . $Param{Count} );
    }
    else {
        $Self->{Params} = {};
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

    # group dn
    $Self->{GroupDN} = $Self->{CustomerUserMap}->{Params}->{GroupDN} || '';

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

    # charset settings
    $Self->{SourceCharset} = $Self->{CustomerUserMap}->{Params}->{SourceCharset} || '';
    $Self->{DestCharset}   = $Self->{CustomerUserMap}->{Params}->{DestCharset}   || '';

    # set cache type
    $Self->{CacheType} = 'CustomerUser' . $Param{Count};

    # create cache object, but only if CacheTTL is set in customer config
    if ( $Self->{CustomerUserMap}->{CacheTTL} ) {
        $Self->{CacheObject} = Kernel::System::Cache->new( %{$Self} );
    }

    # get valid filter if used
    $Self->{ValidFilter} = $Self->{CustomerUserMap}->{CustomerUserValidFilter} || '';

    # connect first if Die is enabled, make sure that connection is possible, else die
    if ( $Self->{Die} ) {
        return if !$Self->_Connect();
    }

    return $Self;
}

sub _Connect {
    my ( $Self, %Param ) = @_;

    # return if connection is already open
    return 1 if $Self->{LDAP};

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

    my $Result;
    if ( $Self->{SearchUserDN} && $Self->{SearchUserPw} ) {
        $Result = $Self->{LDAP}->bind(
            dn       => $Self->{SearchUserDN},
            password => $Self->{SearchUserPw},
        );
    }
    else {
        $Result = $Self->{LDAP}->bind();
    }

    if ( $Result->code() ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'First bind failed! ' . $Result->error(),
        );
        $Self->{LDAP}->disconnect();
        return;
    }

    return 1;
}

sub CustomerName {
    my ( $Self, %Param ) = @_;

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
    my $Name = '';
    if ( $Self->{CacheObject} ) {
        my $Name = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => 'CustomerName::' . $Param{UserLogin},
        );
        return $Name if defined $Name;
    }

    # create ldap connect
    return if !$Self->_Connect();

    # perform user search
    my $Result = $Self->{LDAP}->search(
        base      => $Self->{BaseDN},
        scope     => $Self->{SScope},
        filter    => $Filter,
        sizelimit => $Self->{UserSearchListLimit},
        attrs     => $Self->{CustomerUserMap}->{CustomerUserNameFields},
    );

    if ( $Result->code() ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Search failed! ' . $Result->error(),
        );
        return;
    }

    for my $Entry ( $Result->all_entries() ) {

        for my $Field ( @{ $Self->{CustomerUserMap}->{CustomerUserNameFields} } ) {

            if ( defined $Entry->get_value($Field) ) {

                if ( !$Name ) {
                    $Name = $Self->_ConvertFrom( $Entry->get_value($Field) );
                }
                else {
                    $Name .= ' ' . $Self->_ConvertFrom( $Entry->get_value($Field) );
                }
            }
        }
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => 'CustomerName::' . $Param{UserLogin},
            Value => $Name,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }

    return $Name;
}

sub CustomerSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Search} && !$Param{UserLogin} && !$Param{PostMasterSearch} && !$Param{CustomerID} )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Search, UserLogin, PostMasterSearch or CustomerID!'
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
            $Part =~ s/(\%+)/\%/g;
            $Part =~ s/(\*+)\*/*/g;
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
    elsif ( $Param{CustomerID} ) {
        $Filter = "($Self->{CustomerID}=$Param{CustomerID})";
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
        return %{$Users} if ref $Users eq 'HASH';
    }

    # create ldap connect
    return if !$Self->_Connect();

    # combine needed attrs
    my @Attributes
        = ( @{ $Self->{CustomerUserMap}->{CustomerUserListFields} }, $Self->{CustomerKey} );

    # perform user search
    my $Result = $Self->{LDAP}->search(
        base      => $Self->{BaseDN},
        scope     => $Self->{SScope},
        filter    => $Filter,
        sizelimit => $Self->{UserSearchListLimit},
        attrs     => \@Attributes,
    );

    # log ldap errors
    if ( $Result->code() ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Result->error(),
        );
    }

    my %Users;
    for my $Entry ( $Result->all_entries() ) {

        my $CustomerString = '';

        for my $Field ( @{ $Self->{CustomerUserMap}->{CustomerUserListFields} } ) {

            my $Value = $Self->_ConvertFrom( $Entry->get_value($Field) );

            if ($Value) {
                if ( $Field =~ /^targetaddress$/i ) {
                    $Value =~ s/SMTP:(.*)/$1/;
                }
                $CustomerString .= $Value . ' ';
            }
        }

        $CustomerString =~ s/^(.*)\s(.+?\@.+?\..+?)(\s|)$/"$1" <$2>/;

        if ( defined $Entry->get_value( $Self->{CustomerKey} ) ) {
            $Users{ $Self->_ConvertFrom( $Entry->get_value( $Self->{CustomerKey} ) ) }
                = $CustomerString;
        }
    }

    # check if user need to be in a group!
    if ( $Self->{GroupDN} ) {

        for my $Filter2 ( sort keys %Users ) {

            my $Result2 = $Self->{LDAP}->search(
                base      => $Self->{GroupDN},
                scope     => $Self->{SScope},
                filter    => 'memberUid=' . $Filter2,
                sizelimit => $Self->{UserSearchListLimit},
                attrs     => ['1.1'],
            );

            if ( !$Result2->all_entries() ) {
                delete $Users{$Filter2};
            }
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
        return %{$Users} if ref $Users eq 'HASH';
    }

    # create ldap connect
    return if !$Self->_Connect();

    # combine needed attrs
    my @Attributes = ( $Self->{CustomerKey}, $Self->{CustomerID} );

    # perform user search
    my $Result = $Self->{LDAP}->search(
        base      => $Self->{BaseDN},
        scope     => $Self->{SScope},
        filter    => $Filter,
        sizelimit => $Self->{UserSearchListLimit},
        attrs     => \@Attributes,
    );

    # log ldap errors
    if ( $Result->code() ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Result->error(),
        );
    }

    my %Users;
    for my $Entry ( $Result->all_entries() ) {

        my $CustomerString = '';
        for my $Field (@Attributes) {

            my $FieldValue = $Entry->get_value($Field);
            $FieldValue = defined $FieldValue ? $FieldValue : '';

            $CustomerString .= $Self->_ConvertFrom($FieldValue) . ' ';
        }

        my $KeyValue = $Entry->get_value( $Self->{CustomerKey} );
        $KeyValue = defined $KeyValue ? $KeyValue : '';

        $Users{ $Self->_ConvertFrom($KeyValue) } = $CustomerString;
    }

    # check if user need to be in a group!
    if ( $Self->{GroupDN} ) {

        for my $Filter2 ( sort keys %Users ) {

            my $Result2 = $Self->{LDAP}->search(
                base      => $Self->{GroupDN},
                scope     => $Self->{SScope},
                filter    => 'memberUid=' . $Filter2,
                sizelimit => $Self->{UserSearchListLimit},
                attrs     => ['1.1'],
            );

            if ( !$Result2->all_entries() ) {
                delete $Users{$Filter2};
            }
        }
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

sub CustomerIDList {
    my ( $Self, %Param ) = @_;

    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;
    my $SearchTerm = $Param{SearchTerm} || '';

    my $CacheKey = "CustomerIDList::${Valid}::$SearchTerm";

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Result = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
        return @{$Result} if ref $Result eq 'ARRAY';
    }

    # prepare filter
    my $Filter = "($Self->{CustomerID}=*)";
    if ($SearchTerm) {

        my $SearchFilter = $Self->{SearchPrefix} . $SearchTerm . $Self->{SearchSuffix};
        $SearchFilter =~ s/(\%+)/\%/g;
        $SearchFilter =~ s/(\*+)\*/*/g;
        $Filter = "($Self->{CustomerID}=$SearchFilter)";

    }

    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # add valid filter
    if ( $Self->{ValidFilter} && $Valid ) {
        $Filter = "(&$Filter$Self->{ValidFilter})";
    }

    # create ldap connect
    return if !$Self->_Connect();

    # combine needed attrs
    my @Attributes = ( $Self->{CustomerKey}, $Self->{CustomerID} );

    # perform user search
    my $Result = $Self->{LDAP}->search(
        base      => $Self->{BaseDN},
        scope     => $Self->{SScope},
        filter    => $Filter,
        sizelimit => $Self->{UserSearchListLimit},
        attrs     => \@Attributes,
    );

    # log ldap errors
    if ( $Result->code() ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Result->error(),
        );
    }

    my %Users;
    for my $Entry ( $Result->all_entries() ) {

        my $FieldValue = $Entry->get_value( $Self->{CustomerID} );
        $FieldValue = defined $FieldValue ? $FieldValue : '';

        my $KeyValue = $Entry->get_value( $Self->{CustomerKey} );
        $KeyValue = defined $KeyValue ? $KeyValue : '';
        $Users{ $Self->_ConvertFrom($KeyValue) } = $Self->_ConvertFrom($FieldValue);
    }

    # check if user need to be in a group!
    if ( $Self->{GroupDN} ) {
        for my $Filter2 ( sort keys %Users ) {
            my $Result2 = $Self->{LDAP}->search(
                base      => $Self->{GroupDN},
                scope     => $Self->{SScope},
                filter    => 'memberUid=' . $Filter2,
                sizelimit => $Self->{UserSearchListLimit},
                attrs     => ['1.1'],
            );
            if ( !$Result2->all_entries() ) {
                delete $Users{$Filter2};
            }
        }
    }

    # make CustomerIDs unique
    my %Tmp;
    @Tmp{ values %Users } = undef;
    my @Result = keys %Tmp;

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => $CacheKey,
            Value => \@Result,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }

    return @Result;
}

sub CustomerIDs {
    my ( $Self, %Param ) = @_;

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
        return @{$CustomerIDs} if ref $CustomerIDs eq 'ARRAY';
    }

    # get customer data
    my %Data = $Self->CustomerUserDataGet( User => $Param{User}, );

    # there are multi customer ids
    my @CustomerIDs;
    if ( $Data{UserCustomerIDs} ) {

        # used separators
        separator:
        for my $Separator ( ';', ',', '|' ) {

            next separator if $Data{UserCustomerIDs} !~ /\Q$Separator\E/;

            # split it
            my @IDs = split /\Q$Separator\E/, $Data{UserCustomerIDs};

            for my $ID (@IDs) {
                $ID =~ s/^\s+//g;
                $ID =~ s/\s+$//g;
                push @CustomerIDs, $ID;
            }

            last separator;
        }

        # fallback if no separator got found
        if ( !@CustomerIDs ) {
            $Data{UserCustomerIDs} =~ s/^\s+//g;
            $Data{UserCustomerIDs} =~ s/\s+$//g;
            push @CustomerIDs, $Data{UserCustomerIDs};
        }
    }

    # use also the primary customer id
    if ( $Data{UserCustomerID} && !$Self->{ExcludePrimaryCustomerID} ) {
        push @CustomerIDs, $Data{UserCustomerID};
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

    # check needed stuff
    if ( !$Param{User} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need User!' );
        return;
    }

    # perform user search
    my @Attributes;
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        push( @Attributes, $Entry->[2] );
    }
    my $Filter = "($Self->{CustomerKey}=$Param{User})";

    # prepare filter
    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Data = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => 'CustomerUserDataGet::' . $Param{User},
        );
        return %{$Data} if ref $Data eq 'HASH';
    }

    # create ldap connect
    return if !$Self->_Connect();

    # perform search
    my $Result = $Self->{LDAP}->search(
        base   => $Self->{BaseDN},
        scope  => $Self->{SScope},
        filter => $Filter,
        attrs  => \@Attributes,
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
    my %Data;
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {

        my $Value = $Self->_ConvertFrom( $Result2->get_value( $Entry->[2] ) ) || '';

        if ( $Value && $Entry->[2] =~ /^targetaddress$/i ) {
            $Value =~ s/SMTP:(.*)/$1/;
        }

        $Data{ $Entry->[0] } = $Value;
    }

    return if !$Data{UserLogin};

    # compat!
    $Data{UserID} = $Data{UserLogin};

    # get preferences
    my %Preferences = $Self->GetPreferences( UserID => $Data{UserLogin} );

    # add last login timestamp
    if ( $Preferences{UserLastLogin} ) {
        $Preferences{UserLastLoginTimestamp} = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $Preferences{UserLastLogin},
        );
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => 'CustomerUserDataGet::' . $Param{User},
            Value => { %Data, %Preferences },
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }

    return ( %Data, %Preferences );
}

sub CustomerUserAdd {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Customer backend is read only!' );
        return;
    }

    $Self->{LogObject}->Log( Priority => 'error', Message => 'Not supported for this module!' );

    return;
}

sub CustomerUserUpdate {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Customer backend is read only!' );
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Customer backend is read only!' );
        return;
    }

    $Self->{LogObject}->Log( Priority => 'error', Message => 'Not supported for this module!' );

    return;
}

sub GenerateRandomPassword {
    my ( $Self, %Param ) = @_;

    # generated passwords are eight characters long by default.
    my $Size = $Param{Size} || 8;

    # The list of characters that can appear in a randomly generated password.
    # Note that users can put any character into a password they choose themselves.
    my @PwChars
        = ( 0 .. 9, 'A' .. 'Z', 'a' .. 'z', '-', '_', '!', '@', '#', '$', '%', '^', '&', '*' );

    # number of characters in the list.
    my $PwCharsLen = scalar(@PwChars);

    # generate the password.
    my $Password = '';
    for ( my $i = 0; $i < $Size; $i++ ) {
        $Password .= $PwChars[ rand $PwCharsLen ];
    }

    return $Password;
}

sub SetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    # cache reset
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Delete(
            Type => $Self->{CacheType},
            Key  => "CustomerUserDataGet::$Param{UserID}",
        );
    }
    return $Self->{PreferencesObject}->SetPreferences(%Param);
}

sub GetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    return $Self->{PreferencesObject}->GetPreferences(%Param);
}

sub SearchPreferences {
    my ( $Self, %Param ) = @_;

    return $Self->{PreferencesObject}->SearchPreferences(%Param);
}

sub _ConvertFrom {
    my ( $Self, $Text ) = @_;

    return if !defined $Text;

    if ( !$Self->{SourceCharset} || !$Self->{DestCharset} ) {
        return $Text;
    }

    return $Self->{EncodeObject}->Convert(
        Text => $Text,
        From => $Self->{SourceCharset},
        To   => $Self->{DestCharset},
    );
}

sub _ConvertTo {
    my ( $Self, $Text ) = @_;

    return if !defined $Text;

    if ( !$Self->{SourceCharset} || !$Self->{DestCharset} ) {
        $Self->{EncodeObject}->EncodeInput( \$Text );
        return $Text;
    }

    return $Self->{EncodeObject}->Convert(
        Text => $Text,
        To   => $Self->{SourceCharset},
        From => $Self->{DestCharset},
    );
}

sub DESTROY {
    my ( $Self, %Param ) = @_;

    # take down session
    if ( $Self->{LDAP} ) {
        $Self->{LDAP}->unbind();
    }

    return 1;
}

1;
