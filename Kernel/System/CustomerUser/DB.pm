# --
# Kernel/System/CustomerUser/DB.pm - some customer user functions
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: DB.pm,v 1.60 2008-02-12 21:58:53 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::CustomerUser::DB;

use strict;
use warnings;
use Kernel::System::CheckItem;
use Kernel::System::Valid;
use Kernel::System::Cache;
use Kernel::System::Encode;

use Crypt::PasswdMD5 qw(unix_md5_crypt);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.60 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject PreferencesObject CustomerUserMap)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create valid object
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    # create check item object
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new(%Param);

    # create encode object
    $Self->{EncodeObject}    = Kernel::System::Encode->new(%Param);

    # create cache object
    if ( $Self->{CustomerUserMap}->{'CacheTTL'} ) {
        $Self->{CacheObject} = Kernel::System::Cache->new(%Param);
    }

    # max shown user a search list
    $Self->{UserSearchListLimit} = $Self->{CustomerUserMap}->{'CustomerUserSearchListLimit'} || 250;

    # config options
    $Self->{CustomerTable} = $Self->{CustomerUserMap}->{Params}->{Table}
        || die "Need CustomerUser->Params->Table in Kernel/Config.pm!";
    $Self->{CustomerKey} = $Self->{CustomerUserMap}->{CustomerKey}
        || $Self->{CustomerUserMap}->{Key}
        || die "Need CustomerUser->CustomerKey in Kernel/Config.pm!";
    $Self->{CustomerID} = $Self->{CustomerUserMap}->{CustomerID}
        || die "Need CustomerUser->CustomerID in Kernel/Config.pm!";
    $Self->{ReadOnly} = $Self->{CustomerUserMap}->{ReadOnly};
    $Self->{ExcludePrimaryCustomerID} = $Self->{CustomerUserMap}->{CustomerUserExcludePrimaryCustomerID} || 0;
    $Self->{SearchPrefix} = $Self->{CustomerUserMap}->{'CustomerUserSearchPrefix'};
    if ( !defined( $Self->{SearchPrefix} ) ) {
        $Self->{SearchPrefix} = '';
    }
    $Self->{SearchSuffix} = $Self->{CustomerUserMap}->{'CustomerUserSearchSuffix'};
    if ( !defined( $Self->{SearchSuffix} ) ) {
        $Self->{SearchSuffix} = '*';
    }

    # cache key prefix
    if ( !defined( $Param{Count} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need Count param, update Kernel/System/CustomerUser.pm to v1.32 or higher!",
        );
        $Param{Count} = '';
    }
    $Self->{CacheKey} = 'CustomerUser' . $Param{Count};

    # create new db connect if DSN is given
    if ( $Self->{CustomerUserMap}->{Params}->{DSN} ) {
        $Self->{DBObject} = Kernel::System::DB->new(
            LogObject    => $Param{LogObject},
            ConfigObject => $Param{ConfigObject},
            MainObject   => $Param{MainObject},
            DatabaseDSN  => $Self->{CustomerUserMap}->{Params}->{DSN},
            DatabaseUser => $Self->{CustomerUserMap}->{Params}->{User},
            DatabasePw   => $Self->{CustomerUserMap}->{Params}->{Password},
            Type         => $Self->{CustomerUserMap}->{Params}->{Type} || '',
        ) || die('Can\'t connect to database!');

        # remember that we have the DBObject not from parent call
        $Self->{NotParentDBObject} = 1;
    }

    return $Self;
}

sub CustomerName {
    my ( $Self, %Param ) = @_;

    my $Name = '';

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need UserLogin!" );
        return;
    }

    # build SQL string 1/2
    my $SQL = "SELECT $Self->{CustomerKey} ";
    if ( $Self->{CustomerUserMap}->{CustomerUserNameFields} ) {
        for my $Entry ( @{ $Self->{CustomerUserMap}->{CustomerUserNameFields} } ) {
            $SQL .= ", $Entry";
        }
    }
    else {
        $SQL .= " , first_name, last_name ";
    }
    $SQL
        .= " FROM $Self->{CustomerTable} WHERE "
        . " LOWER($Self->{CustomerKey}) = LOWER('"
        . $Self->{DBObject}->Quote( $Param{UserLogin} ) . "')";

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Name = $Self->{CacheObject}->Get( Key => $Self->{CacheKey} . "::CustomerName::$SQL" );
        if ( defined($Name) ) {
            return $Name;
        }
    }

    # get data
    $Self->{DBObject}->Prepare( SQL => $SQL, Limit => 1 );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        for my $Position ( 1 .. 8 ) {
            if ( $Row[$Position] ) {
                if ( !$Name ) {
                    $Name = $Row[$Position];
                }
                else {
                    $Name .= ' ' . $Row[$Position];
                }
            }
        }
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Key   => $Self->{CacheKey} . "::CustomerName::$SQL",
            Value => $Name,
            TTL   => $Self->{CustomerUserMap}->{'CacheTTL'},
        );
    }
    return $Name;
}

sub CustomerSearch {
    my ( $Self, %Param ) = @_;

    my %Users = ();
    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;

    # check needed stuff
    if ( !$Param{Search} && !$Param{UserLogin} && !$Param{PostMasterSearch} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need Search, UserLogin or PostMasterSearch!",
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

    # build SQL string 2/2
    $SQL .= " FROM $Self->{CustomerTable} WHERE ";
    if ( $Param{Search} ) {
        my $Count = 0;
        my @Parts = split( /\+/, $Param{Search}, 6 );
        for my $Part (@Parts) {
            $Part = $Self->{SearchPrefix} . $Part . $Self->{SearchSuffix};
            $Part =~ s/\*/%/g;
            $Part =~ s/%%/%/g;
            if ($Count) {
                $SQL .= " AND ";
            }
            $Count++;
            if ( $Self->{CustomerUserMap}->{CustomerUserSearchFields} ) {
                my $SQLExt = '';
                for my $Field ( @{ $Self->{CustomerUserMap}->{CustomerUserSearchFields} } ) {
                    if ($SQLExt) {
                        $SQLExt .= ' OR ';
                    }
                    $SQLExt .= " LOWER($Field) LIKE LOWER('" . $Self->{DBObject}->Quote( $Part, 'Like' ) . "') ";
                }
                if ($SQLExt) {
                    $SQL .= "($SQLExt)";
                }
            }
            else {
                $SQL .= " LOWER($Self->{CustomerKey}) LIKE LOWER('"
                    . $Self->{DBObject}->Quote( $Part, 'Like' ) . "') ";
            }
        }
    }
    elsif ( $Param{PostMasterSearch} ) {
        if ( $Self->{CustomerUserMap}->{CustomerUserPostMasterSearchFields} ) {
            my $SQLExt = '';
            for my $Field ( @{ $Self->{CustomerUserMap}->{CustomerUserPostMasterSearchFields} } ) {
                if ($SQLExt) {
                    $SQLExt .= ' OR ';
                }
                $SQLExt .= " LOWER($Field) LIKE LOWER('"
                    . $Self->{DBObject}->Quote( $Param{PostMasterSearch}, 'Like' ) . "') ";
            }
            $SQL .= $SQLExt;
        }
    }
    elsif ( $Param{UserLogin} ) {
        $Param{UserLogin} =~ s/\*/%/g;
        $SQL .= " LOWER($Self->{CustomerKey}) LIKE LOWER('"
            . $Self->{DBObject}->Quote( $Param{UserLogin}, 'Like' ) . "')";
    }

    # add valid option
    if ( $Self->{CustomerUserMap}->{CustomerValid} && $Valid ) {
        $SQL .= "AND "
            . $Self->{CustomerUserMap}->{CustomerValid}
            . " IN (".join(', ', $Self->{ValidObject}->ValidIDsGet() ).") ";
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Users = $Self->{CacheObject}->Get(
            Key => $Self->{CacheKey} . "::CustomerSearch::$SQL",
        );
        if ($Users) {
            return %{$Users};
        }
    }

    # get data
    $Self->{DBObject}->Prepare( SQL => $SQL, Limit => $Self->{UserSearchListLimit} );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( !$Users{ $Row[0] } ) {
            for my $Position ( 1 .. 8 ) {
                if ( $Row[$Position] ) {
                    $Users{ $Row[0] } .= $Row[$Position] . ' ';
                }
            }
            $Users{ $Row[0] } =~ s/^(.*)\s(.+?\@.+?\..+?)(\s|)$/"$1" <$2>/;
        }
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Key   => $Self->{CacheKey} . "::CustomerSearch::$SQL",
            Value => \%Users,
            TTL   => $Self->{CustomerUserMap}->{'CacheTTL'},
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
            Key => $Self->{CacheKey} . "::CustomerUserList::$Valid",
        );
        if ($Users) {
            return %{$Users};
        }
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
            Key   => $Self->{CacheKey} . "::CustomerUserList::$Valid",
            Value => \%Users,
            TTL   => $Self->{CustomerUserMap}->{'CacheTTL'},
        );
    }
    return %Users;
}

sub CustomerIDs {
    my ( $Self, %Param ) = @_;

    my @CustomerIDs = ();

    # check needed stuff
    if ( !$Param{User} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need User!" );
        return;
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $CustomerIDs = $Self->{CacheObject}->Get(
            Key => $Self->{CacheKey} . "::CustomerIDs::$Param{User}",
        );
        if ($CustomerIDs) {
            return @{$CustomerIDs};
        }
    }

    # get customer data
    my %Data = $Self->CustomerUserDataGet( User => $Param{User} );

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
            Key   => $Self->{CacheKey} . "::CustomerIDs::$Param{User}",
            Value => \@CustomerIDs,
            TTL   => $Self->{CustomerUserMap}->{'CacheTTL'},
        );
    }
    return @CustomerIDs;
}

sub CustomerUserDataGet {
    my ( $Self, %Param ) = @_;

    my %Data;

    # check needed stuff
    if ( !$Param{User} && !$Param{CustomerID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need User or CustomerID!" );
        return;
    }

    # build select
    my $SQL = "SELECT ";
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        $SQL .= " $Entry->[2], ";
    }
    $SQL .= $Self->{CustomerKey} . " FROM $Self->{CustomerTable} WHERE ";
    if ( $Param{User} ) {

        # check cache
        if ( $Self->{CacheObject} ) {
            my $Data = $Self->{CacheObject}->Get(
                Key => $Self->{CacheKey} . "::CustomerUserDataGet::User::$Param{User}",
            );
            if ($Data) {
                return %{$Data};
            }
        }
        $SQL .= "LOWER($Self->{CustomerKey}) = LOWER('"
            . $Self->{DBObject}->Quote( $Param{User} ) . "')";
    }
    elsif ( $Param{CustomerID} ) {

        # check cache
        if ( $Self->{CacheObject} ) {
            my $Data = $Self->{CacheObject}->Get(
                Key => $Self->{CacheKey} . "::CustomerUserDataGet::CustomerID::$Param{CustomerID}",
            );
            if ($Data) {
                return %{$Data};
            }
        }
        $SQL .= "LOWER($Self->{CustomerID}) = LOWER('"
            . $Self->{DBObject}->Quote( $Param{CustomerID} ) . "')";
    }

    # get initial data
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my $MapCounter = 0;
        for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
            $Data{ $Entry->[0] } = $Row[$MapCounter];
            $MapCounter++;
        }
    }

    # check data
    if ( !exists $Data{UserLogin} && $Param{User} ) {

        # cache request
        if ( $Self->{CacheObject} ) {
            $Self->{CacheObject}->Set(
                Key   => $Self->{CacheKey} . "::CustomerUserDataGet::User::$Param{User}",
                Value => {},
                TTL   => $Self->{CustomerUserMap}->{'CacheTTL'},
            );
        }
        return;
    }
    if ( !exists $Data{UserLogin} && $Param{CustomerID} ) {

        # cache request
        if ( $Self->{CacheObject} ) {
            $Self->{CacheObject}->Set(
                Key => $Self->{CacheKey} . "::CustomerUserDataGet::CustomerID::$Param{CustomerID}",
                Value => {},
                TTL   => $Self->{CustomerUserMap}->{'CacheTTL'},
            );
        }
        return;
    }

    # compat!
    $Data{UserID} = $Data{UserLogin};

    # get preferences
    my %Preferences = $Self->{PreferencesObject}->GetPreferences( UserID => $Data{UserID} );

    # cache request
    if ( $Self->{CacheObject} ) {
        if ( $Param{User} ) {
            $Self->{CacheObject}->Set(
                Key   => $Self->{CacheKey} . "::CustomerUserDataGet::User::$Param{User}",
                Value => { %Data, %Preferences },
                TTL   => $Self->{CustomerUserMap}->{'CacheTTL'},
            );
        }
        elsif ( $Param{CustomerID} ) {
            $Self->{CacheObject}->Set(
                Key => $Self->{CacheKey} . "::CustomerUserDataGet::CustomerID::$Param{CustomerID}",
                Value => { %Data, %Preferences },
                TTL   => $Self->{CustomerUserMap}->{'CacheTTL'},
            );
        }
    }

    # return data
    return ( %Data, %Preferences );
}

sub CustomerUserAdd {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Customer backend is ro!" );
        return;
    }

    # check needed stuff
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( !$Param{ $Entry->[0] } && $Entry->[4] ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Entry->[0]!" );
            return;
        }
    }
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need UserID!" );
        return;
    }

    # just if no UserLogin is given
    if ( !$Param{UserLogin} && $Self->{CustomerUserMap}->{AutoLoginCreation} ) {
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WDay ) = localtime( time() );
        $Year  = $Year - 100;
        $Year  = "0$Year" if ( $Year < 10 );
        $Month = $Month + 1;
        $Month = "0$Month" if ( $Month < 10 );
        $Day   = "0$Day" if ( $Day < 10 );
        $Hour  = "0$Hour" if ( $Hour < 10 );
        $Min   = "0$Min" if ( $Min < 10 );
        my $Prefix = $Self->{CustomerUserMap}->{AutoLoginCreationPrefix} || 'auto';
        $Param{UserLogin} = "$Prefix-$Year$Month$Day$Hour$Min" . int( rand(99) );
    }

    # check if user login exists
    if ( !$Param{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need UserLogin!" );
        return;
    }

    # check email address if already exists
    if ( $Param{UserEmail} && $Self->{CustomerUserMap}->{CustomerUserEmailUniqCheck} ) {
        my %Result = $Self->CustomerSearch(
            Valid            => 1,
            PostMasterSearch => $Param{UserEmail},
        );
        if (%Result) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Email already exists!" );
            return;
        }
    }

    # check email address mx
    if ( $Param{UserEmail}
        && !$Self->{CheckItemObject}->CheckEmail( Address => $Param{UserEmail} ) )
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
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[0] !~ /^UserPassword$/i ) {
            $SQL .= " $Entry->[2], ";
        }
    }
    $SQL .= "create_time, create_by, change_time, change_by)";
    $SQL .= " VALUES (";
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[0] !~ /^UserPassword$/i ) {
            $SQL .= " $Value{ $Entry->[0] }, ";
        }
    }
    $SQL .= "current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {

        # log notice
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "CustomerUser: '$Param{UserLogin}' created successfully ($Param{UserID})!",
        );

        # set password
        if ( $Param{UserPassword} ) {
            $Self->SetPassword( UserLogin => $Param{UserLogin}, PW => $Param{UserPassword} );
        }

        # cache resete
        if ( $Self->{CacheObject} ) {
            $Self->{CacheObject}->Delete(
                Key => $Self->{CacheKey} . "::CustomerUserDataGet::User::$Param{UserLogin}", );
        }
        return $Param{UserLogin};
    }
    else {
        return;
    }
}

sub CustomerUserUpdate {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Customer backend is ro!" );
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
    if ( $Param{UserEmail}
        && !$Self->{CheckItemObject}->CheckEmail( Address => $Param{UserEmail} ) )
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
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[0] !~ /^UserPassword$/i ) {
            $SQL .= " $Entry->[2] = $Value{ $Entry->[0] }, ";
        }
    }
    $SQL .= " change_time = current_timestamp, ";
    $SQL .= " change_by = $Param{UserID} ";
    $SQL .= " WHERE LOWER($Self->{CustomerKey}) = LOWER('"
        . $Self->{DBObject}->Quote( $Param{ID} ) . "')";

    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {

        # log notice
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "CustomerUser: '$Param{UserLogin}' updated successfully ($Param{UserID})!",
        );

        # check pw
        if ( $Param{UserPassword} ) {
            $Self->SetPassword( UserLogin => $Param{UserLogin}, PW => $Param{UserPassword} );
        }

        # cache resete
        if ( $Self->{CacheObject} ) {
            $Self->{CacheObject}->Delete(
                Key => $Self->{CacheKey} . "::CustomerUserDataGet::User::$Param{UserLogin}",
            );
        }
        return 1;
    }
    else {
        return;
    }
}

sub SetPassword {
    my ( $Self, %Param ) = @_;

    my $Pw = $Param{PW} || '';

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Customer backend is ro!" );
        return;
    }

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need UserLogin!" );
        return;
    }
    my $CryptedPw = '';

    # md5 pw
    if (   $Self->{ConfigObject}->Get('Customer::AuthModule::DB::CryptType')
        && $Self->{ConfigObject}->Get('Customer::AuthModule::DB::CryptType') eq 'plain' )
    {
        $CryptedPw = $Pw;
    }
    elsif ($Self->{ConfigObject}->Get('Customer::AuthModule::DB::CryptType')
        && $Self->{ConfigObject}->Get('Customer::AuthModule::DB::CryptType') eq 'md5' )
    {

        # encode output, needed by unix_md5_crypt() only non utf8 signs
        $Self->{EncodeObject}->EncodeOutput( \$Pw );
        $Self->{EncodeObject}->EncodeOutput( \$Param{UserLogin} );

        $CryptedPw = unix_md5_crypt( $Pw, $Param{UserLogin} );
    }

    # crypt pw
    else {

        # crypt given pw (unfortunately there is a mod_perl2 bug on RH8 - check if
        # crypt() is working correctly) :-/
        if ( crypt( 'root', 'root@localhost' ) eq 'roK20XGbWEsSM' ) {

            # encode output, needed by crypt() only non utf8 signs
            $Self->{EncodeObject}->EncodeOutput( \$Pw );
            $Self->{EncodeObject}->EncodeOutput( \$Param{UserLogin} );

            $CryptedPw = crypt( $Pw, $Param{UserLogin} );
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "The crypt() of your mod_perl(2) is not working correctly! Update mod_perl!",
            );
            my $TempUser = quotemeta( $Param{UserLogin} );
            my $TempPw   = quotemeta($Pw);
            my $CMD      = "perl -e \"print crypt('$TempPw', '$TempUser');\"";
            open( IO, " $CMD | " ) || print STDERR "Can't open $CMD: $!";
            while (<IO>) {
                $CryptedPw .= $_;
            }
            close(IO);
            chomp $CryptedPw;
        }
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
        if ($Self->{DBObject}->Do(
                      SQL => "UPDATE $Self->{CustomerTable} SET "
                    . " $Param{PasswordCol} = '"
                    . $Self->{DBObject}->Quote($CryptedPw) . "' "
                    . " WHERE "
                    . " LOWER($Param{LoginCol}) = LOWER('"
                    . $Self->{DBObject}->Quote( $Param{UserLogin} ) . "')",
            )
            )
        {

            # log notice
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "CustomerUser: '$Param{UserLogin}' changed password successfully!",
            );

            # cache resete
            if ( $Self->{CacheObject} ) {
                $Self->{CacheObject}->Delete(
                    Key => $Self->{CacheKey} . "::CustomerUserDataGet::User::$Param{UserLogin}",
                );
            }
            return 1;
        }
        else {
            return;
        }
    }
    else {

        # need no pw to set
        return 1;
    }
}

sub GenerateRandomPassword {
    my ( $Self, %Param ) = @_;

    # Generated passwords are eight characters long by default.
    my $Size = $Param{Size} || 8;

    # The list of characters that can appear in a randomly generated password.
    # Note that users can put any character into a password they choose themselves.
    my @PwChars = ( 0 .. 9, 'A' .. 'Z', 'a' .. 'z', '-', '_', '!', '@', '#', '$', '%', '^', '&', '*' );

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

sub DESTROY {
    my ($Self) = @_;

    # disconnect if it's not a parent DBObject
    if ( $Self->{NotParentDBObject} ) {
        if ( $Self->{DBObject} ) {
            $Self->{DBObject}->Disconnect();
        }
    }
    return 1;
}

1;
