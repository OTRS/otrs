# --
# Kernel/System/CustomerUser/DB.pm - some customer user functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerUser::DB;

use strict;
use warnings;

use Crypt::PasswdMD5 qw(unix_md5_crypt);

use Kernel::System::Cache;
use Kernel::System::CheckItem;
use Kernel::System::Time;
use Kernel::System::Valid;

use vars qw(@ISA);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DBObject ConfigObject LogObject PreferencesObject CustomerUserMap MainObject EncodeObject)
        )
    {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # create additional objects
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new( %{$Self} );
    $Self->{TimeObject}      = Kernel::System::Time->new( %{$Self} );
    $Self->{ValidObject}     = Kernel::System::Valid->new( %{$Self} );

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
    $Self->{ReadOnly} = $Self->{CustomerUserMap}->{ReadOnly};
    $Self->{ExcludePrimaryCustomerID}
        = $Self->{CustomerUserMap}->{CustomerUserExcludePrimaryCustomerID} || 0;
    $Self->{SearchPrefix} = $Self->{CustomerUserMap}->{CustomerUserSearchPrefix};

    # charset settings
    $Self->{SourceCharset}       = $Self->{CustomerUserMap}->{Params}->{SourceCharset}       || '';
    $Self->{DestCharset}         = $Self->{CustomerUserMap}->{Params}->{DestCharset}         || '';
    $Self->{CharsetConvertForce} = $Self->{CustomerUserMap}->{Params}->{CharsetConvertForce} || '';

    # db connection settings, disable Encode utf8 if source db is not utf8
    my %DatabasePreferences;
    if ( $Self->{SourceCharset} !~ /utf(-8|8)/i ) {
        $DatabasePreferences{Encode} = 0;
    }

    if ( !defined $Self->{SearchPrefix} ) {
        $Self->{SearchPrefix} = '';
    }
    $Self->{SearchSuffix} = $Self->{CustomerUserMap}->{CustomerUserSearchSuffix};
    if ( !defined $Self->{SearchSuffix} ) {
        $Self->{SearchSuffix} = '*';
    }

    # check if CustomerKey is var or int
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[0] eq 'UserLogin' && $Entry->[5] =~ /^int$/i ) {
            $Self->{CustomerKeyInteger} = 1;
            last;
        }
    }

    # set cache type
    $Self->{CacheType} = 'CustomerUser' . $Param{Count};

    # create cache object, but only if CacheTTL is set in customer config
    if ( $Self->{CustomerUserMap}->{CacheTTL} ) {
        $Self->{CacheObject} = Kernel::System::Cache->new( %{$Self} );
    }

    # create new db connect if DSN is given
    if ( $Self->{CustomerUserMap}->{Params}->{DSN} ) {
        $Self->{DBObject} = Kernel::System::DB->new(
            LogObject    => $Param{LogObject},
            ConfigObject => $Param{ConfigObject},
            MainObject   => $Param{MainObject},
            EncodeObject => $Param{EncodeObject},
            DatabaseDSN  => $Self->{CustomerUserMap}->{Params}->{DSN},
            DatabaseUser => $Self->{CustomerUserMap}->{Params}->{User},
            DatabasePw   => $Self->{CustomerUserMap}->{Params}->{Password},
            %DatabasePreferences,
            %{ $Self->{CustomerUserMap}->{Params} },
        ) || die('Can\'t connect to database!');

        # remember that we have the DBObject not from parent call
        $Self->{NotParentDBObject} = 1;
    }

    $Self->{CaseSensitive} = $Self->{CustomerUserMap}->{Params}->{CaseSensitive} || 0;

    return $Self;
}

sub CustomerName {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserLogin!' );
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
    if ( $Self->{CustomerKeyInteger} ) {

        # return if login is no integer
        return if $Param{UserLogin} !~ /^(\+|\-|)\d{1,16}$/;

        $UserLogin = $Self->{DBObject}->Quote( $UserLogin, 'Integer' );

        $SQL .= "$Self->{CustomerKey} = $UserLogin";
    }
    else {

        $UserLogin = $Self->{DBObject}->Quote($UserLogin);
        if ( $Self->{CaseSensitive} ) {
            $SQL .= "$Self->{CustomerKey} = '$UserLogin'";
        }
        else {
            $SQL .= "LOWER($Self->{CustomerKey}) = LOWER('$UserLogin')";
        }
    }

    # get data
    my $SQLConvert = $Self->_ConvertTo($SQL);
    return if !$Self->{DBObject}->Prepare( SQL => $SQLConvert, Limit => 1 );
    my @NameParts;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        for my $Field (@Row) {
            next if !$Field;
            push @NameParts, $Field;
        }
    }
    my $Name = join( ' ', @NameParts );
    $Name = $Self->_ConvertFrom($Name);

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
    if ( !$Param{Search} && !$Param{UserLogin} && !$Param{PostMasterSearch} && !$Param{CustomerID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Search, UserLogin, PostMasterSearch or CustomerID!',
        );
        return;
    }

    # build SQL string 1/2
    my $SQL = "SELECT $Self->{CustomerKey} ";
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
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Need CustomerUserSearchFields in CustomerUser config, unable to search for '$Param{Search}'!",
            );
            return;
        }

        my $Search = $Self->{DBObject}->QueryStringEscape( QueryString => $Param{Search} );

        $SQL .= $Self->{DBObject}->QueryCondition(
            Key           => $Self->{CustomerUserMap}->{CustomerUserSearchFields},
            Value         => $Search,
            SearchPrefix  => $Self->{SearchPrefix},
            SearchSuffix  => $Self->{SearchSuffix},
            CaseSensitive => $Self->{CaseSensitive},
        ) . ' ';
    }
    elsif ( $Param{PostMasterSearch} ) {
        if ( $Self->{CustomerUserMap}->{CustomerUserPostMasterSearchFields} ) {
            my $SQLExt = '';
            for my $Field ( @{ $Self->{CustomerUserMap}->{CustomerUserPostMasterSearchFields} } ) {
                if ($SQLExt) {
                    $SQLExt .= ' OR ';
                }
                my $PostMasterSearch = $Self->{DBObject}->Quote( $Param{PostMasterSearch}, 'Like' );
                if ( $Self->{CaseSensitive} ) {
                    $SQLExt .= " $Field LIKE '$PostMasterSearch' $LikeEscapeString ";
                }
                else {
                    $SQLExt .= " LOWER($Field) LIKE LOWER('$PostMasterSearch') $LikeEscapeString ";
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

            $SQL .= "$Self->{CustomerKey} = $UserLogin";
        }
        else {
            $UserLogin = $Self->{DBObject}->Quote( $UserLogin, 'Like' );
            $UserLogin =~ s/\*/%/g;
            if ( $Self->{CaseSensitive} ) {
                $SQL .= "$Self->{CustomerKey} LIKE '$UserLogin' $LikeEscapeString";
            }
            else {
                $SQL .= "LOWER($Self->{CustomerKey}) LIKE LOWER('$UserLogin') $LikeEscapeString";
            }
        }
    }
    elsif ( $Param{CustomerID} ) {

        my $CustomerID = $Self->{DBObject}->Quote( $Param{CustomerID}, 'Like' );
        $CustomerID =~ s/\*/%/g;
        if ( $Self->{CaseSensitive} ) {
            $SQL .= "$Self->{CustomerID} LIKE '$CustomerID' $LikeEscapeString";
        }
        else {
            $SQL .= "LOWER($Self->{CustomerID}) LIKE LOWER('$CustomerID') $LikeEscapeString";
        }
    }

    # add valid option
    if ( $Self->{CustomerUserMap}->{CustomerValid} && $Valid ) {
        $SQL .= ' AND '
            . $Self->{CustomerUserMap}->{CustomerValid}
            . ' IN (' . join( ', ', $Self->{ValidObject}->ValidIDsGet() ) . ') ';
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Users = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType} . '_CustomerSearch',
            Key  => "CustomerSearch::$SQL",
        );
        return %{$Users} if ref $Users eq 'HASH';
    }

    # get data
    my $SQLConvert = $Self->_ConvertTo($SQL);
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQLConvert,
        Limit => $Self->{UserSearchListLimit},
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        next if $Users{ $Row[0] };
        for my $Position ( 1 .. 8 ) {
            next if !$Row[$Position];
            $Row[$Position] = $Self->_ConvertFrom( $Row[$Position] );
            $Users{ $Row[0] } .= $Row[$Position] . ' ';
        }
        $Users{ $Row[0] } =~ s/^(.*)\s(.+?\@.+?\..+?)(\s|)$/"$1" <$2>/;
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType} . '_CustomerSearch',
            Key   => "CustomerSearch::$SQL",
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

    my $SQL .= "
        SELECT DISTINCT($Self->{CustomerID})
        FROM $Self->{CustomerTable}
        WHERE 1 = 1 ";

    # add valid option
    if ( $Self->{CustomerUserMap}->{CustomerValid} && $Valid ) {
        my $ValidIDs = join( ', ', $Self->{ValidObject}->ValidIDsGet() );
        $SQL .= "
            AND $Self->{CustomerUserMap}->{CustomerValid} IN ($ValidIDs) ";
    }

    # add search term
    if ($SearchTerm) {
        my $SearchTermEscaped = $Self->{DBObject}->QueryStringEscape( QueryString => $SearchTerm );

        $SQL .= ' AND ';
        $SQL .= $Self->{DBObject}->QueryCondition(
            Key           => $Self->{CustomerID},
            Value         => $SearchTermEscaped,
            SearchPrefix  => $Self->{SearchPrefix},
            SearchSuffix  => $Self->{SearchSuffix},
            CaseSensitive => $Self->{CaseSensitive},
        );
        $SQL .= ' ';
    }

    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

    my @Result;

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @Result, $Self->_ConvertFrom( $Row[0] );
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
    my %Data = $Self->CustomerUserDataGet( User => $Param{User} );

    # there are multi customer ids
    my @CustomerIDs;
    if ( $Data{UserCustomerIDs} ) {

        # used separators
        for my $Split ( ';', ',', '|' ) {

            # next if separator is not there
            next if $Data{UserCustomerIDs} !~ /\Q$Split\E/;

            # split it
            my @IDs = split /\Q$Split\E/, $Data{UserCustomerIDs};
            for my $ID (@IDs) {
                $ID =~ s/^\s+//g;
                $ID =~ s/\s+$//g;
                push @CustomerIDs, $ID;
            }
            last;
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

    my %Data;

    # check needed stuff
    if ( !$Param{User} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need User!' );
        return;
    }

    # build select
    my $SQL = 'SELECT ';
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        $SQL .= " $Entry->[2], ";
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

    # check CustomerKey type
    my $User = $Param{User};
    if ( $Self->{CustomerKeyInteger} ) {

        # return if login is no integer
        return if $Param{User} !~ /^(\+|\-|)\d{1,16}$/;

        $SQL .= "$Self->{CustomerKey} = " . $Self->{DBObject}->Quote( $User, 'Integer' );
    }
    else {
        if ( $Self->{CaseSensitive} ) {
            $SQL .= "$Self->{CustomerKey} = '" . $Self->{DBObject}->Quote($User) . "'";
        }
        else {
            $SQL
                .= "LOWER($Self->{CustomerKey}) = LOWER('" . $Self->{DBObject}->Quote($User) . "')";
        }
    }

    # get initial data
    my $SQLConvert = $Self->_ConvertTo($SQL);
    return if !$Self->{DBObject}->Prepare( SQL => $SQLConvert );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my $MapCounter = 0;
        for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
            $Row[$MapCounter] = $Self->_ConvertFrom( $Row[$MapCounter] );
            $Data{ $Entry->[0] } = $Row[$MapCounter];
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
        $Preferences{UserLastLoginTimestamp} = $Self->{TimeObject}->SystemTime2TimeStamp(
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

    # return data
    return ( %Data, %Preferences );
}

sub CustomerUserAdd {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Customer backend is read only!' );
        return;
    }

    # check needed stuff
    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( !$Param{ $Entry->[0] } && $Entry->[4] ) {

            # skip UserLogin, will be checked later
            next ENTRY if ( $Entry->[0] eq 'UserLogin' );

            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Entry->[0]!" );
            return;
        }
    }
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    # if no UserLogin is given
    if ( !$Param{UserLogin} && $Self->{CustomerUserMap}->{AutoLoginCreation} ) {
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );
        my $Prefix = $Self->{CustomerUserMap}->{AutoLoginCreationPrefix} || 'auto';
        $Param{UserLogin} = "$Prefix-$Year$Month$Day$Hour$Min" . int( rand(99) );
    }

    # check if user login exists
    if ( !$Param{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserLogin!' );
        return;
    }

    # check email address if already exists
    if ( $Param{UserEmail} && $Self->{CustomerUserMap}->{CustomerUserEmailUniqCheck} ) {
        my %Result = $Self->CustomerSearch(
            Valid            => 0,
            PostMasterSearch => $Param{UserEmail},
        );
        if (%Result) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Email already exists!',
            );
            return;
        }
    }

    # check email address mx
    if (
        $Param{UserEmail}
        && !$Self->{CheckItemObject}->CheckEmail( Address => $Param{UserEmail} )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Email address ($Param{UserEmail}) not valid ("
                . $Self->{CheckItemObject}->CheckError() . ")!",
        );
        return;
    }

    # quote values
    my %Value;
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[5] =~ /^int$/i ) {
            if ( $Param{ $Entry->[0] } ) {
                $Value{ $Entry->[0] }
                    = $Self->{DBObject}->Quote( $Param{ $Entry->[0] }, 'Integer' );
            }
            else {
                $Value{ $Entry->[0] } = 0;
            }
        }
        else {
            if ( $Param{ $Entry->[0] } ) {
                $Value{ $Entry->[0] }
                    = "'" . $Self->{DBObject}->Quote( $Param{ $Entry->[0] } ) . "'";
            }
            else {
                $Value{ $Entry->[0] } = "''";
            }
        }
    }

    # build insert
    my $SQL = "INSERT INTO $Self->{CustomerTable} (";
    my %SeenKey;    # If the map contains duplicated field names, insert only once.
    MAPENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        next MAPENTRY if ( lc( $Entry->[0] ) eq "userpassword" );
        next MAPENTRY if $SeenKey{ $Entry->[2] }++;
        $SQL .= " $Entry->[2], ";
    }
    $SQL .= 'create_time, create_by, change_time, change_by)';
    $SQL .= ' VALUES (';
    my %SeenValue;
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        next if ( lc( $Entry->[0] ) eq "userpassword" );
        next if $SeenValue{ $Entry->[2] }++;
        $SQL .= " $Value{ $Entry->[0] }, ";
    }
    $SQL .= "current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    $SQL = $Self->_ConvertTo($SQL);
    return if !$Self->{DBObject}->Do( SQL => $SQL );

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "CustomerUser: '$Param{UserLogin}' created successfully ($Param{UserID})!",
    );

    # set password
    if ( $Param{UserPassword} ) {
        $Self->SetPassword( UserLogin => $Param{UserLogin}, PW => $Param{UserPassword} );
    }

    $Self->_CustomerUserCacheClear( UserLogin => $Param{UserLogin} );

    return $Param{UserLogin};
}

sub CustomerUserUpdate {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Customer backend is read only!' );
        return;
    }

    # check needed stuff
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( !$Param{ $Entry->[0] } && $Entry->[4] && $Entry->[0] ne 'UserPassword' ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Entry->[0]!" );
            return;
        }
    }

    # check email address
    if (
        $Param{UserEmail}
        && !$Self->{CheckItemObject}->CheckEmail( Address => $Param{UserEmail} )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Email address ($Param{UserEmail}) not valid ("
                . $Self->{CheckItemObject}->CheckError() . ")!",
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
            $Self->{LogObject}->Log(
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
                $Value{ $Entry->[0] }
                    = $Self->{DBObject}->Quote( $Param{ $Entry->[0] }, 'Integer' );
            }
            else {
                $Value{ $Entry->[0] } = 0;
            }
        }
        else {
            if ( $Param{ $Entry->[0] } ) {
                $Value{ $Entry->[0] }
                    = "'" . $Self->{DBObject}->Quote( $Param{ $Entry->[0] } ) . "'";
            }
            else {
                $Value{ $Entry->[0] } = "''";
            }
        }
    }

    # update db
    my $SQL = "UPDATE $Self->{CustomerTable} SET ";
    my %SeenKey;    # If the map contains duplicated field names, insert only once.
    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        next ENTRY if $Entry->[7];                               # skip readonly fields
        next ENTRY if ( lc( $Entry->[0] ) eq "userpassword" );
        next ENTRY if $SeenKey{ $Entry->[2] }++;
        $SQL .= " $Entry->[2] = $Value{ $Entry->[0] }, ";
    }
    $SQL .= " change_time = current_timestamp, ";
    $SQL .= " change_by = $Param{UserID} ";
    $SQL .= " WHERE ";

    # check CustomerKey type
    if ( $Self->{CustomerKeyInteger} ) {

        # return if login is no integer
        return if $Param{ID} !~ /^(\+|\-|)\d{1,16}$/;

        $SQL .= "$Self->{CustomerKey} = " . $Self->{DBObject}->Quote( $Param{ID}, 'Integer' );
    }
    else {
        $SQL .= "LOWER($Self->{CustomerKey}) = LOWER('"
            . $Self->{DBObject}->Quote( $Param{ID} ) . "')";
    }

    $SQL = $Self->_ConvertTo($SQL);
    return if !$Self->{DBObject}->Do( SQL => $SQL );

    # check if we need to update Customer Preferences
    if ( $Param{UserLogin} ne $UserData{UserLogin} ) {

        # preferences table data
        $Self->{PreferencesTable}
            = $Self->{ConfigObject}->Get('CustomerPreferences')->{Params}->{Table}
            || 'customer_preferences';
        $Self->{PreferencesTableUserID}
            = $Self->{ConfigObject}->Get('CustomerPreferences')->{Params}->{TableUserID}
            || 'user_id';

        # update the preferences
        return if !$Self->{DBObject}->Prepare(
            SQL => "UPDATE $Self->{PreferencesTable} "
                . "SET $Self->{PreferencesTableUserID} = ? "
                . "WHERE $Self->{PreferencesTableUserID} = ?",
            Bind => [ \$Param{UserLogin}, \$Param{ID}, ],
        );
    }

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "CustomerUser: '$Param{UserLogin}' updated successfully ($Param{UserID})!",
    );

    # check pw
    if ( $Param{UserPassword} ) {
        $Self->SetPassword( UserLogin => $Param{UserLogin}, PW => $Param{UserPassword} );
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Customer backend is read only!' );
        return;
    }

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserLogin!' );
        return;
    }
    my $CryptedPw = '';

    # get crypt type
    my $CryptType = $Self->{ConfigObject}->Get('Customer::AuthModule::DB::CryptType') || '';

    # crypt plain (no crypt at all)
    if ( $CryptType eq 'plain' ) {
        $CryptedPw = $Pw;
    }

    # crypt with unix crypt
    elsif ( $CryptType eq 'crypt' ) {

        # encode output, needed by crypt() only non utf8 signs
        $Self->{EncodeObject}->EncodeOutput( \$Pw );
        $Self->{EncodeObject}->EncodeOutput( \$Login );

        $CryptedPw = crypt( $Pw, $Login );
        $Self->{EncodeObject}->EncodeInput( \$CryptedPw );
    }

    # crypt with md5 crypt
    elsif ( $CryptType eq 'md5' || !$CryptType ) {

        # encode output, needed by unix_md5_crypt() only non utf8 signs
        $Self->{EncodeObject}->EncodeOutput( \$Pw );
        $Self->{EncodeObject}->EncodeOutput( \$Login );

        $CryptedPw = unix_md5_crypt( $Pw, $Login );
        $Self->{EncodeObject}->EncodeInput( \$CryptedPw );
    }

    # crypt with sha1
    elsif ( $CryptType eq 'sha1' ) {

        my $SHAObject;
        if ( $Self->{MainObject}->Require('Digest::SHA') ) {
            $SHAObject = Digest::SHA->new('sha1');
        }
        else {
            $Self->{MainObject}->Require('Digest::SHA::PurePerl');
            $SHAObject = Digest::SHA::PurePerl->new('sha1');
        }

        # encode output, needed by sha1_hex() only non utf8 signs
        $Self->{EncodeObject}->EncodeOutput( \$Pw );

        $SHAObject->add($Pw);
        $CryptedPw = $SHAObject->hexdigest();
    }

    # crypt with sha2
    # if CrypType is set to anything else, including sha2
    else {

        my $SHAObject;
        if ( $Self->{MainObject}->Require('Digest::SHA') ) {
            $SHAObject = Digest::SHA->new('sha256');
        }
        else {
            $Self->{MainObject}->Require('Digest::SHA::PurePerl');
            $SHAObject = Digest::SHA::PurePerl->new('sha256');
        }

        # encode output, needed by sha256_hex() only non utf8 signs
        $Self->{EncodeObject}->EncodeOutput( \$Pw );

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
            . " $Param{PasswordCol} = '" . $Self->{DBObject}->Quote($CryptedPw) . "' "
            . " WHERE ";

        # check CustomerKey type
        if ( $Self->{CustomerKeyInteger} ) {

            # return if login is no integer
            return if $Param{UserLogin} !~ /^(\+|\-|)\d{1,16}$/;

            $SQL
                .= "$Param{LoginCol} = " . $Self->{DBObject}->Quote( $Param{UserLogin}, 'Integer' );
        }
        else {
            if ( $Self->{CaseSensitive} ) {
                $SQL .= "$Param{LoginCol} = '"
                    . $Self->{DBObject}->Quote( $Param{UserLogin} ) . "'";
            }
            else {
                $SQL .= "LOWER($Param{LoginCol}) = LOWER('"
                    . $Self->{DBObject}->Quote( $Param{UserLogin} ) . "')";
            }
        }

        return if !$Self->{DBObject}->Do( SQL => $SQL );

        # log notice
        $Self->{LogObject}->Log(
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

    $Self->_CustomerUserCacheClear( UserLogin => $Param{UserID} );

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
        Text  => $Text,
        From  => $Self->{SourceCharset},
        To    => $Self->{DestCharset},
        Force => $Self->{CharsetConvertForce},
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
        Text  => $Text,
        To    => $Self->{SourceCharset},
        From  => $Self->{DestCharset},
        Force => $Self->{CharsetConvertForce},
    );
}

sub _CustomerUserCacheClear {
    my ( $Self, %Param ) = @_;

    return if !$Self->{CacheObject};

    if ( !$Param{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserLogin!' );
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
