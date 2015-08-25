# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerUser::DB;

use strict;
use warnings;

use Crypt::PasswdMD5 qw(unix_md5_crypt apache_md5_crypt);
use Digest::SHA;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::CheckItem',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Time',
    'Kernel::System::Valid',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed data
    for my $Needed (qw( PreferencesObject CustomerUserMap )) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # get database object
    $Self->{DBObject} = $Kernel::OM->Get('Kernel::System::DB');

    # max shown user per search list
    $Self->{UserSearchListLimit} = $Self->{CustomerUserMap}->{CustomerUserSearchListLimit} || 250;

    # config options
    $Self->{CustomerTable} = $Self->{CustomerUserMap}->{Params}->{Table}
        || die "Need CustomerUser->Params->Table in Kernel/Config.pm!";
    $Self->{CustomerKey} = $Self->{CustomerUserMap}->{CustomerKey}
        || $Self->{CustomerUserMap}->{Key}
        || die "Need CustomerUser->CustomerKey in Kernel/Config.pm!";
    $Self->{CustomerID} = $Self->{CustomerUserMap}->{CustomerID}
        || die "Need CustomerUser->CustomerID in Kernel/Config.pm!";
    $Self->{ReadOnly}                 = $Self->{CustomerUserMap}->{ReadOnly};
    $Self->{ExcludePrimaryCustomerID} = $Self->{CustomerUserMap}->{CustomerUserExcludePrimaryCustomerID} || 0;
    $Self->{SearchPrefix}             = $Self->{CustomerUserMap}->{CustomerUserSearchPrefix};

    if ( !defined $Self->{SearchPrefix} ) {
        $Self->{SearchPrefix} = '';
    }
    $Self->{SearchSuffix} = $Self->{CustomerUserMap}->{CustomerUserSearchSuffix};
    if ( !defined $Self->{SearchSuffix} ) {
        $Self->{SearchSuffix} = '*';
    }

    # check if CustomerKey is var or int
    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[0] eq 'UserLogin' && $Entry->[5] =~ /^int$/i ) {
            $Self->{CustomerKeyInteger} = 1;
            last ENTRY;
        }
    }

    # set cache type
    $Self->{CacheType} = 'CustomerUser' . $Param{Count};

    # create cache object, but only if CacheTTL is set in customer config
    if ( $Self->{CustomerUserMap}->{CacheTTL} ) {
        $Self->{CacheObject} = $Kernel::OM->Get('Kernel::System::Cache');
    }

    # create new db connect if DSN is given
    if ( $Self->{CustomerUserMap}->{Params}->{DSN} ) {
        $Self->{DBObject} = Kernel::System::DB->new(
            DatabaseDSN  => $Self->{CustomerUserMap}->{Params}->{DSN},
            DatabaseUser => $Self->{CustomerUserMap}->{Params}->{User},
            DatabasePw   => $Self->{CustomerUserMap}->{Params}->{Password},
            %{ $Self->{CustomerUserMap}->{Params} },
        ) || die('Can\'t connect to database!');

        # remember that we have the DBObject not from parent call
        $Self->{NotParentDBObject} = 1;
    }

    # this setting specifies if the table has the create_time,
    # create_by, change_time and change_by fields of OTRS
    $Self->{ForeignDB} = $Self->{CustomerUserMap}->{Params}->{ForeignDB} ? 1 : 0;

    $Self->{CaseSensitive} = $Self->{CustomerUserMap}->{Params}->{CaseSensitive} || 0;

    return $Self;
}

sub CustomerName {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserLogin!',
        );
        return;
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Name = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => "CustomerName::$Param{UserLogin}",
        );
        return $Name if defined $Name;
    }

    # build SQL string 1/2
    my $SQL = "SELECT ";
    if ( $Self->{CustomerUserMap}->{CustomerUserNameFields} ) {
        $SQL .= join( ", ", @{ $Self->{CustomerUserMap}->{CustomerUserNameFields} } );
    }
    else {
        $SQL .= "first_name, last_name ";
    }
    $SQL .= " FROM $Self->{CustomerTable} WHERE ";

    # check CustomerKey type
    my $UserLogin = $Param{UserLogin};
    if ( $Self->{CaseSensitive} ) {
        $SQL .= "$Self->{CustomerKey} = ?";
    }
    else {
        $SQL .= "LOWER($Self->{CustomerKey}) = LOWER(?)";
    }

    # get data
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => [ \$Param{UserLogin} ],
        Limit => 1,
    );
    my @NameParts;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        FIELD:
        for my $Field (@Row) {
            next FIELD if !$Field;
            push @NameParts, $Field;
        }
    }
    my $Name = join( ' ', @NameParts );

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => "CustomerName::$Param{UserLogin}",
            Value => $Name,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }
    return $Name;
}

sub CustomerSearch {
    my ( $Self, %Param ) = @_;

    my %Users;
    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;

    # check needed stuff
    if (
        !$Param{Search}
        && !$Param{UserLogin}
        && !$Param{PostMasterSearch}
        && !$Param{CustomerID}
        && !$Param{CustomerIDRaw}
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Search, UserLogin, PostMasterSearch, CustomerIDRaw or CustomerID!',
        );
        return;
    }

    # check cache
    my $CacheKey = join '::', map { $_ . '=' . $Param{$_} } sort keys %Param;

    if ( $Self->{CacheObject} ) {
        my $Users = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType} . '_CustomerSearch',
            Key  => $CacheKey,
        );
        return %{$Users} if ref $Users eq 'HASH';
    }

    # build SQL string 1/2
    my $SQL = "SELECT $Self->{CustomerKey} ";
    my @Bind;
    if ( $Self->{CustomerUserMap}->{CustomerUserListFields} ) {
        for my $Entry ( @{ $Self->{CustomerUserMap}->{CustomerUserListFields} } ) {
            $SQL .= ", $Entry";
        }
    }
    else {
        $SQL .= " , first_name, last_name, email ";
    }

    # get like escape string needed for some databases (e.g. oracle)
    my $LikeEscapeString = $Self->{DBObject}->GetDatabaseFunction('LikeEscapeString');

    # build SQL string 2/2
    $SQL .= " FROM $Self->{CustomerTable} WHERE ";
    if ( $Param{Search} ) {
        if ( !$Self->{CustomerUserMap}->{CustomerUserSearchFields} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Need CustomerUserSearchFields in CustomerUser config, unable to search for '$Param{Search}'!",
            );
            return;
        }

        my $Search = $Self->{DBObject}->QueryStringEscape( QueryString => $Param{Search} );

        my %QueryCondition = $Self->{DBObject}->QueryCondition(
            Key           => $Self->{CustomerUserMap}->{CustomerUserSearchFields},
            Value         => $Search,
            SearchPrefix  => $Self->{SearchPrefix},
            SearchSuffix  => $Self->{SearchSuffix},
            CaseSensitive => $Self->{CaseSensitive},
            BindMode      => 1,
        );

        $SQL .= $QueryCondition{SQL};
        push @Bind, @{ $QueryCondition{Values} };

        $SQL .= ' ';
    }
    elsif ( $Param{PostMasterSearch} ) {
        if ( $Self->{CustomerUserMap}->{CustomerUserPostMasterSearchFields} ) {
            my $SQLExt = '';
            for my $Field ( @{ $Self->{CustomerUserMap}->{CustomerUserPostMasterSearchFields} } ) {
                if ($SQLExt) {
                    $SQLExt .= ' OR ';
                }
                my $PostMasterSearch = $Self->{DBObject}->Quote( $Param{PostMasterSearch} );
                push @Bind, \$PostMasterSearch;

                if ( $Self->{CaseSensitive} ) {
                    $SQLExt .= " $Field = ? ";
                }
                else {
                    $SQLExt .= " LOWER($Field) = LOWER(?) ";
                }
            }
            $SQL .= $SQLExt;
        }
    }
    elsif ( $Param{UserLogin} ) {

        my $UserLogin = $Param{UserLogin};

        # check CustomerKey type
        if ( $Self->{CustomerKeyInteger} ) {

            # return if login is no integer
            return if $Param{UserLogin} !~ /^(\+|\-|)\d{1,16}$/;

            $SQL .= "$Self->{CustomerKey} = ?";
            push @Bind, \$UserLogin;
        }
        else {
            $UserLogin = '%' . $Self->{DBObject}->Quote( $UserLogin, 'Like' ) . '%';
            $UserLogin =~ s/\*/%/g;
            push @Bind, \$UserLogin;
            if ( $Self->{CaseSensitive} ) {
                $SQL .= "$Self->{CustomerKey} LIKE ? $LikeEscapeString";
            }
            else {
                $SQL .= "LOWER($Self->{CustomerKey}) LIKE LOWER(?) $LikeEscapeString";
            }
        }
    }
    elsif ( $Param{CustomerID} ) {

        my $CustomerID = $Self->{DBObject}->Quote( $Param{CustomerID}, 'Like' );
        $CustomerID =~ s/\*/%/g;
        push @Bind, \$CustomerID;

        if ( $Self->{CaseSensitive} ) {
            $SQL .= "$Self->{CustomerID} LIKE ? $LikeEscapeString";
        }
        else {
            $SQL .= "LOWER($Self->{CustomerID}) LIKE LOWER(?) $LikeEscapeString";
        }
    }
    elsif ( $Param{CustomerIDRaw} ) {

        push @Bind, \$Param{CustomerIDRaw};

        if ( $Self->{CaseSensitive} ) {
            $SQL .= "$Self->{CustomerID} = ? ";
        }
        else {
            $SQL .= "LOWER($Self->{CustomerID}) = LOWER(?) ";
        }
    }

    # add valid option
    if ( $Self->{CustomerUserMap}->{CustomerValid} && $Valid ) {

        # get valid object
        my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

        $SQL .= ' AND '
            . $Self->{CustomerUserMap}->{CustomerValid}
            . ' IN (' . join( ', ', $ValidObject->ValidIDsGet() ) . ') ';
    }

    # get data
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => $Self->{UserSearchListLimit},
    );
    ROW:
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        next ROW if $Users{ $Row[0] };
        POSITION:
        for my $Position ( 1 .. 8 ) {
            next POSITION if !$Row[$Position];
            $Users{ $Row[0] } .= $Row[$Position] . ' ';
        }
        $Users{ $Row[0] } =~ s/^(.*)\s(.+?\@.+?\..+?)(\s|)$/"$1" <$2>/;
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType} . '_CustomerSearch',
            Key   => $CacheKey,
            Value => \%Users,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }
    return %Users;
}

sub CustomerUserList {
    my ( $Self, %Param ) = @_;

    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Users = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => "CustomerUserList::$Valid",
        );
        return %{$Users} if ref $Users eq 'HASH';
    }

    # do not use valid option if no valid option is used
    if ( !$Self->{CustomerUserMap}->{CustomerValid} ) {
        $Valid = 0;
    }

    # get data
    my %Users = $Self->{DBObject}->GetTableData(
        What  => "$Self->{CustomerKey}, $Self->{CustomerKey}, $Self->{CustomerID}",
        Table => $Self->{CustomerTable},
        Clamp => 1,
        Valid => $Valid,
    );

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => "CustomerUserList::$Valid",
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

    my $CacheType = $Self->{CacheType} . '_CustomerIDList';
    my $CacheKey  = "CustomerIDList::${Valid}::$SearchTerm";

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Result = $Self->{CacheObject}->Get(
            Type => $CacheType,
            Key  => $CacheKey,
        );
        return @{$Result} if ref $Result eq 'ARRAY';
    }

    my $SQL = "
        SELECT DISTINCT($Self->{CustomerID})
        FROM $Self->{CustomerTable}
        WHERE 1 = 1 ";
    my @Bind;

    # add valid option
    if ( $Self->{CustomerUserMap}->{CustomerValid} && $Valid ) {

        # get valid object
        my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

        my $ValidIDs = join( ', ', $ValidObject->ValidIDsGet() );
        $SQL .= "
            AND $Self->{CustomerUserMap}->{CustomerValid} IN ($ValidIDs) ";
    }

    # add search term
    if ($SearchTerm) {
        my $SearchTermEscaped = $Self->{DBObject}->QueryStringEscape( QueryString => $SearchTerm );

        $SQL .= ' AND ';
        my %QueryCondition = $Self->{DBObject}->QueryCondition(
            Key           => $Self->{CustomerID},
            Value         => $SearchTermEscaped,
            SearchPrefix  => $Self->{SearchPrefix},
            SearchSuffix  => $Self->{SearchSuffix},
            CaseSensitive => $Self->{CaseSensitive},
            BindMode      => 1,
        );
        $SQL .= $QueryCondition{SQL};
        push @Bind, @{ $QueryCondition{Values} };

        $SQL .= ' ';
    }

    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my @Result;

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @Result, $Row[0];
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $CacheType,
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need User!',
        );
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
    my %Data = $Self->CustomerUserDataGet( User => $Param{User} );

    # there are multi customer ids
    my @CustomerIDs;
    if ( $Data{UserCustomerIDs} ) {

        # used separators
        SPLIT:
        for my $Split ( ';', ',', '|' ) {

            next SPLIT if $Data{UserCustomerIDs} !~ /\Q$Split\E/;

            # split it
            my @IDs = split /\Q$Split\E/, $Data{UserCustomerIDs};
            for my $ID (@IDs) {
                $ID =~ s/^\s+//g;
                $ID =~ s/\s+$//g;
                push @CustomerIDs, $ID;
            }
            last SPLIT;
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
            Key   => "CustomerIDs::$Param{User}",
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need User!',
        );
        return;
    }

    # build select
    my $SQL = 'SELECT ';
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        $SQL .= " $Entry->[2], ";
    }

    if ( !$Self->{ForeignDB} ) {
        $SQL .= "create_time, create_by, change_time, change_by, ";
    }

    $SQL .= $Self->{CustomerKey} . " FROM $Self->{CustomerTable} WHERE ";

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Data = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => "CustomerUserDataGet::$Param{User}",
        );
        return %{$Data} if ref $Data eq 'HASH';
    }

    # check customer key type
    my $User = $Param{User};

    if ( $Self->{CaseSensitive} ) {
        $SQL .= "$Self->{CustomerKey} = ?";
    }
    else {
        $SQL .= "LOWER($Self->{CustomerKey}) = LOWER(?)";
    }

    # ask the database
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => [ \$User ],
        Limit => 1,
    );

    # fetch the result
    my %Data;
    ROW:
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        my $MapCounter = 0;

        for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
            $Data{ $Entry->[0] } = $Row[$MapCounter];
            $MapCounter++;
        }

        next ROW if $Self->{ForeignDB};

        for my $Key (qw(CreateTime CreateBy ChangeTime ChangeBy)) {
            $Data{$Key} = $Row[$MapCounter];
            $MapCounter++;
        }
    }

    # check data
    if ( !$Data{UserLogin} ) {

        # cache request
        if ( $Self->{CacheObject} ) {
            $Self->{CacheObject}->Set(
                Type  => $Self->{CacheType},
                Key   => "CustomerUserDataGet::$Param{User}",
                Value => {},
                TTL   => $Self->{CustomerUserMap}->{CacheTTL},
            );
        }
        return;
    }

    # compat!
    $Data{UserID} = $Data{UserLogin};

    # get preferences
    my %Preferences = $Self->GetPreferences( UserID => $Data{UserID} );

    # add last login timestamp
    if ( $Preferences{UserLastLogin} ) {
        $Preferences{UserLastLoginTimestamp} = $Kernel::OM->Get('Kernel::System::Time')->SystemTime2TimeStamp(
            SystemTime => $Preferences{UserLastLogin},
        );
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => "CustomerUserDataGet::$Param{User}",
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Customer backend is read only!',
        );
        return;
    }

    # check needed stuff
    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( !$Param{ $Entry->[0] } && $Entry->[4] ) {

            # skip UserLogin, will be checked later
            next ENTRY if ( $Entry->[0] eq 'UserLogin' );

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Entry->[0]!",
            );
            return;
        }
    }
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # if no UserLogin is given
    if ( !$Param{UserLogin} && $Self->{CustomerUserMap}->{AutoLoginCreation} ) {

        # get time object
        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

        my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
            SystemTime => $TimeObject->SystemTime(),
        );
        my $Prefix = $Self->{CustomerUserMap}->{AutoLoginCreationPrefix} || 'auto';
        $Param{UserLogin} = "$Prefix-$Year$Month$Day$Hour$Min" . int( rand(99) );
    }

    # check if user login exists
    if ( !$Param{UserLogin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserLogin!',
        );
        return;
    }

    # check email address if already exists
    if ( $Param{UserEmail} && $Self->{CustomerUserMap}->{CustomerUserEmailUniqCheck} ) {
        my %Result = $Self->CustomerSearch(
            Valid            => 0,
            PostMasterSearch => $Param{UserEmail},
        );
        if (%Result) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Email already exists!',
            );
            return;
        }
    }

    # get check item object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    # check email address mx
    if (
        $Param{UserEmail}
        && !$CheckItemObject->CheckEmail( Address => $Param{UserEmail} )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Email address ($Param{UserEmail}) not valid ("
                . $CheckItemObject->CheckError() . ")!",
        );
        return;
    }

    # quote values
    my %Value;
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[5] =~ /^int$/i ) {
            if ( $Param{ $Entry->[0] } ) {
                $Value{ $Entry->[0] } = $Param{ $Entry->[0] };
            }
            else {
                $Value{ $Entry->[0] } = 0;
            }
        }
        else {
            if ( $Param{ $Entry->[0] } ) {
                $Value{ $Entry->[0] } = $Param{ $Entry->[0] };
            }
            else {
                $Value{ $Entry->[0] } = '';
            }
        }
    }

    # build insert
    my $SQL = "INSERT INTO $Self->{CustomerTable} (";
    my @Bind;
    my %SeenKey;    # If the map contains duplicated field names, insert only once.
    my @ColumnNames;

    MAPENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        next MAPENTRY if ( lc( $Entry->[0] ) eq "userpassword" );
        next MAPENTRY if $SeenKey{ $Entry->[2] }++;
        push @ColumnNames, $Entry->[2];
    }

    $SQL .= join ', ', @ColumnNames;

    if ( !$Self->{ForeignDB} ) {
        $SQL .= ', create_time, create_by, change_time, change_by';
    }

    $SQL .= ') VALUES (';

    my %SeenValue;
    my $BindColumns = 0;

    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        next ENTRY if ( lc( $Entry->[0] ) eq "userpassword" );
        next ENTRY if $SeenValue{ $Entry->[2] }++;
        $BindColumns++;
        push @Bind, \$Value{ $Entry->[0] };
    }

    $SQL .= join ', ', ('?') x $BindColumns;

    if ( !$Self->{ForeignDB} ) {
        $SQL .= ', current_timestamp, ?, current_timestamp, ?';
        push @Bind, \$Param{UserID};
        push @Bind, \$Param{UserID};
    }

    $SQL .= ')';

    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind
    );

    # log notice
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "CustomerUser: '$Param{UserLogin}' created successfully ($Param{UserID})!",
    );

    # set password
    if ( $Param{UserPassword} ) {
        $Self->SetPassword(
            UserLogin => $Param{UserLogin},
            PW        => $Param{UserPassword}
        );
    }

    $Self->_CustomerUserCacheClear( UserLogin => $Param{UserLogin} );

    return $Param{UserLogin};
}

sub CustomerUserUpdate {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Customer backend is read only!',
        );
        return;
    }

    # check needed stuff
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( !$Param{ $Entry->[0] } && $Entry->[4] && $Entry->[0] ne 'UserPassword' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Entry->[0]!",
            );
            return;
        }
    }

    # get check item object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    # check email address
    if (
        $Param{UserEmail}
        && !$CheckItemObject->CheckEmail( Address => $Param{UserEmail} )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Email address ($Param{UserEmail}) not valid ("
                . $CheckItemObject->CheckError() . ")!",
        );
        return;
    }

    # get old user data (pw)
    my %UserData = $Self->CustomerUserDataGet( User => $Param{ID} );

    # if we update the email address, check if it already exists
    if (
        $Param{UserEmail}
        && $Self->{CustomerUserMap}->{CustomerUserEmailUniqCheck}
        && lc $Param{UserEmail} ne lc $UserData{UserEmail}
        )
    {
        my %Result = $Self->CustomerSearch(
            Valid            => 0,
            PostMasterSearch => $Param{UserEmail},
        );
        if (%Result) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Email already exists!',
            );
            return;
        }
    }

    # quote values
    my %Value;
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[5] =~ /^int$/i ) {
            if ( $Param{ $Entry->[0] } ) {
                $Value{ $Entry->[0] } = $Param{ $Entry->[0] };
            }
            else {
                $Value{ $Entry->[0] } = 0;
            }
        }
        else {
            if ( $Param{ $Entry->[0] } ) {
                $Value{ $Entry->[0] } = $Param{ $Entry->[0] };
            }
            else {
                $Value{ $Entry->[0] } = "";
            }
        }
    }

    # update db
    my $SQL = "UPDATE $Self->{CustomerTable} SET ";
    my @Bind;

    my %SeenKey;    # If the map contains duplicated field names, insert only once.
    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        next ENTRY if $Entry->[7];                               # skip readonly fields
        next ENTRY if ( lc( $Entry->[0] ) eq "userpassword" );
        next ENTRY if $SeenKey{ $Entry->[2] }++;
        $SQL .= " $Entry->[2] = ?, ";
        push @Bind, \$Value{ $Entry->[0] };
    }

    if ( !$Self->{ForeignDB} ) {
        $SQL .= 'change_time = current_timestamp, change_by = ?';
        push @Bind, \$Param{UserID};
    }
    else {
        chop $SQL;
        chop $SQL;
    }

    $SQL .= ' WHERE ';

    if ( $Self->{CaseSensitive} ) {
        $SQL .= "$Self->{CustomerKey} = ?";
    }
    else {
        $SQL .= "LOWER($Self->{CustomerKey}) = LOWER(?)";
    }
    push @Bind, \$Param{ID};

    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind
    );

    # check if we need to update Customer Preferences
    if ( $Param{UserLogin} ne $UserData{UserLogin} ) {

        # update the preferences
        $Self->{PreferencesObject}->RenamePreferences(
            NewUserID => $Param{UserLogin},
            OldUserID => $UserData{UserLogin},
        );
    }

    # log notice
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "CustomerUser: '$Param{UserLogin}' updated successfully ($Param{UserID})!",
    );

    # check pw
    if ( $Param{UserPassword} ) {
        $Self->SetPassword(
            UserLogin => $Param{UserLogin},
            PW        => $Param{UserPassword}
        );
    }

    $Self->_CustomerUserCacheClear( UserLogin => $Param{UserLogin} );
    if ( $Param{UserLogin} ne $UserData{UserLogin} ) {
        $Self->_CustomerUserCacheClear( UserLogin => $UserData{UserLogin} );
    }

    return 1;
}

sub SetPassword {
    my ( $Self, %Param ) = @_;

    my $Login = $Param{UserLogin};
    my $Pw = $Param{PW} || '';

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Customer backend is read only!',
        );
        return;
    }

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserLogin!',
        );
        return;
    }
    my $CryptedPw = '';

    # get crypt type
    my $CryptType = $Kernel::OM->Get('Kernel::Config')->Get('Customer::AuthModule::DB::CryptType') || 'sha2';

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # crypt plain (no crypt at all)
    if ( $CryptType eq 'plain' ) {
        $CryptedPw = $Pw;
    }

    # crypt with unix crypt
    elsif ( $CryptType eq 'crypt' ) {

        # encode output, needed by crypt() only non utf8 signs
        $EncodeObject->EncodeOutput( \$Pw );
        $EncodeObject->EncodeOutput( \$Login );

        $CryptedPw = crypt( $Pw, $Login );
        $EncodeObject->EncodeInput( \$CryptedPw );
    }

    # crypt with md5 crypt
    elsif ( $CryptType eq 'md5' || !$CryptType ) {

        # encode output, needed by unix_md5_crypt() only non utf8 signs
        $EncodeObject->EncodeOutput( \$Pw );
        $EncodeObject->EncodeOutput( \$Login );

        $CryptedPw = unix_md5_crypt( $Pw, $Login );
        $EncodeObject->EncodeInput( \$CryptedPw );
    }

    # crypt with md5 crypt (compatible with Apache's .htpasswd files)
    elsif ( $CryptType eq 'apr1' ) {

        # encode output, needed by apache_md5_crypt() only non utf8 signs
        $EncodeObject->EncodeOutput( \$Pw );
        $EncodeObject->EncodeOutput( \$Login );

        $CryptedPw = apache_md5_crypt( $Pw, $Login );
        $EncodeObject->EncodeInput( \$CryptedPw );
    }

    # crypt with sha1
    elsif ( $CryptType eq 'sha1' ) {

        my $SHAObject = Digest::SHA->new('sha1');

        # encode output, needed by sha1_hex() only non utf8 signs
        $EncodeObject->EncodeOutput( \$Pw );

        $SHAObject->add($Pw);
        $CryptedPw = $SHAObject->hexdigest();
    }

    # bcrypt
    elsif ( $CryptType eq 'bcrypt' ) {

        # get main object
        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        if ( !$MainObject->Require('Crypt::Eksblowfish::Bcrypt') ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "CustomerUser: '$Login' tried to store password with bcrypt but 'Crypt::Eksblowfish::Bcrypt' is not installed!",
            );
            return;
        }

        my $Cost = 9;
        my $Salt = $MainObject->GenerateRandomString( Length => 16 );

        # remove UTF8 flag, required by Crypt::Eksblowfish::Bcrypt
        $EncodeObject->EncodeOutput( \$Pw );

        # calculate password hash
        my $Octets = Crypt::Eksblowfish::Bcrypt::bcrypt_hash(
            {
                key_nul => 1,
                cost    => 9,
                salt    => $Salt,
            },
            $Pw
        );

        # We will store cost and salt in the password string so that it can be decoded
        #   in future even if we use a higher cost by default.
        $CryptedPw = "BCRYPT:$Cost:$Salt:" . Crypt::Eksblowfish::Bcrypt::en_base64($Octets);
    }

    # crypt with sha2 as fallback
    else {

        my $SHAObject = Digest::SHA->new('sha256');

        # encode output, needed by sha256_hex() only non utf8 signs
        $EncodeObject->EncodeOutput( \$Pw );

        $SHAObject->add($Pw);
        $CryptedPw = $SHAObject->hexdigest();
    }

    # update db
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[0] =~ /^UserPassword$/i ) {
            $Param{PasswordCol} = $Entry->[2];
        }
        if ( $Entry->[0] =~ /^UserLogin$/i ) {
            $Param{LoginCol} = $Entry->[2];
        }
    }

    # check if needed pw col. exists (else there is no pw col.)
    if ( $Param{PasswordCol} && $Param{LoginCol} ) {
        my $SQL = "UPDATE $Self->{CustomerTable} SET "
            . " $Param{PasswordCol} = ? "
            . " WHERE ";

        if ( $Self->{CaseSensitive} ) {
            $SQL .= "$Param{LoginCol} = ?";
        }
        else {
            $SQL .= "LOWER($Param{LoginCol}) = LOWER(?)";
        }

        return if !$Self->{DBObject}->Do(
            SQL  => $SQL,
            Bind => [ \$CryptedPw, \$Param{UserLogin} ],
        );

        # log notice
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "CustomerUser: '$Param{UserLogin}' changed password successfully!",
        );

        $Self->_CustomerUserCacheClear( UserLogin => $Param{UserLogin} );

        return 1;
    }

    # need no pw to set
    return 1;
}

sub GenerateRandomPassword {
    my ( $Self, %Param ) = @_;

    # generated passwords are eight characters long by default
    my $Size = $Param{Size} || 8;

    my $Password = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length => $Size,
    );

    return $Password;
}

sub SetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    $Self->_CustomerUserCacheClear( UserLogin => $Param{UserID} );

    return $Self->{PreferencesObject}->SetPreferences(%Param);
}

sub GetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    return $Self->{PreferencesObject}->GetPreferences(%Param);
}

sub SearchPreferences {
    my ( $Self, %Param ) = @_;

    return $Self->{PreferencesObject}->SearchPreferences(%Param);
}

sub _CustomerUserCacheClear {
    my ( $Self, %Param ) = @_;

    return if !$Self->{CacheObject};

    if ( !$Param{UserLogin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserLogin!',
        );
        return;
    }

    $Self->{CacheObject}->Delete(
        Type => $Self->{CacheType},
        Key  => "CustomerUserDataGet::$Param{UserLogin}",
    );
    $Self->{CacheObject}->Delete(
        Type => $Self->{CacheType},
        Key  => "CustomerName::$Param{UserLogin}",
    );
    $Self->{CacheObject}->Delete(
        Type => $Self->{CacheType},
        Key  => "CustomerIDs::$Param{UserLogin}",
    );

    # delete all search cache entries
    $Self->{CacheObject}->CleanUp(
        Type => $Self->{CacheType} . '_CustomerIDList',
    );
    $Self->{CacheObject}->CleanUp(
        Type => $Self->{CacheType} . '_CustomerSearch',
    );

    for my $Function (qw(CustomerUserList)) {
        for my $Valid ( 0 .. 1 ) {
            $Self->{CacheObject}->Delete(
                Type => $Self->{CacheType},
                Key  => "${Function}::${Valid}",
            );
        }
    }

    return 1;
}

sub DESTROY {
    my $Self = shift;

    # disconnect if it's not a parent DBObject
    if ( $Self->{NotParentDBObject} ) {
        if ( $Self->{DBObject} ) {
            $Self->{DBObject}->Disconnect();
        }
    }

    return 1;
}

1;
