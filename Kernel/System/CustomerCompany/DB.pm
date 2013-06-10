# --
# Kernel/System/CustomerCompany/DB.pm - some customer user functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerCompany::DB;

use strict;
use warnings;

use Kernel::System::Cache;
use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 0.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DBObject ConfigObject LogObject CustomerCompanyMap MainObject EncodeObject)
        )
    {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # create additional objects
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    # config options
    $Self->{CustomerCompanyTable} = $Self->{CustomerCompanyMap}->{Params}->{Table}
        || die "Need CustomerCompany->Params->Table in Kernel/Config.pm!";
    $Self->{CustomerCompanyKey} = $Self->{CustomerCompanyMap}->{CustomerCompanyKey}
        || die "Need CustomerCompany->CustomerCompanyKey in Kernel/Config.pm!";
    $Self->{CustomerCompanyValid} = $Self->{CustomerCompanyMap}->{'CustomerCompanyValid'};
    $Self->{SearchListLimit}      = $Self->{CustomerCompanyMap}->{'CustomerCompanySearchListLimit'};
    $Self->{SearchPrefix}         = $Self->{CustomerCompanyMap}->{'CustomerCompanySearchPrefix'};
    if ( !defined( $Self->{SearchPrefix} ) ) {
        $Self->{SearchPrefix} = '';
    }
    $Self->{SearchSuffix} = $Self->{CustomerCompanyMap}->{'CustomerCompanySearchSuffix'};
    if ( !defined( $Self->{SearchSuffix} ) ) {
        $Self->{SearchSuffix} = '*';
    }

    # charset settings
    $Self->{SourceCharset} = $Self->{CustomerCompanyMap}->{Params}->{SourceCharset} || '';
    $Self->{DestCharset}   = $Self->{CustomerCompanyMap}->{Params}->{DestCharset}   || '';
    $Self->{CharsetConvertForce}
        = $Self->{CustomerCompanyMap}->{Params}->{CharsetConvertForce} || '';

    # db connection settings, disable Encode utf8 if source db is no utf8
    my %DatabasePreferences;
    if ( $Self->{SourceCharset} !~ /utf(-8|8)/i ) {
        $DatabasePreferences{Encode} = 0;
    }

    # create cache object, but only if CacheTTL is set in customer config
    if ( $Self->{CustomerCompanyMap}->{CacheTTL} ) {
        $Self->{CacheObject} = Kernel::System::Cache->new( %{$Self} );
        $Self->{CacheType}   = 'CustomerCompany' . $Param{Count};
        $Self->{CacheTTL}    = $Self->{CustomerCompanyMap}->{CacheTTL} || 0;
    }

    # create new db connect if DSN is given
    if ( $Self->{CustomerCompanyMap}->{Params}->{DSN} ) {
        $Self->{DBObject} = Kernel::System::DB->new(
            LogObject    => $Param{LogObject},
            ConfigObject => $Param{ConfigObject},
            MainObject   => $Param{MainObject},
            EncodeObject => $Param{EncodeObject},
            DatabaseDSN  => $Self->{CustomerCompanyMap}->{Params}->{DSN},
            DatabaseUser => $Self->{CustomerCompanyMap}->{Params}->{User},
            DatabasePw   => $Self->{CustomerCompanyMap}->{Params}->{Password},
            Type         => $Self->{CustomerCompanyMap}->{Params}->{Type} || '',
            %DatabasePreferences,
        ) || die('Can\'t connect to database!');

        # remember that we have the DBObject not from parent call
        $Self->{NotParentDBObject} = 1;
    }

    # this setting specifies if the table has the create_time,
    # create_by, change_time and change_by fields of OTRS
    $Self->{ForeignDB} = $Self->{CustomerCompanyMap}->{Params}->{ForeignDB} ? 1 : 0;

    # see if database is case sensitive
    $Self->{CaseSensitive} = $Self->{CustomerCompanyMap}->{Params}->{CaseSensitive} || 0;

    return $Self;
}

sub CustomerCompanyList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    my $Valid = 1;
    if ( !$Param{Valid} && defined( $Param{Valid} ) ) {
        $Valid = 0;
    }

    my $CacheType = $Self->{CacheType} . '_CustomerCompanyList';
    my $CacheKey = "CustomerCompanyList::${Valid}::" . ( $Param{Search} || '' );

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Data = $Self->{CacheObject}->Get(
            Type => $CacheType,
            Key  => $CacheKey,
        );
        return %{$Data} if ref $Data eq 'HASH';
    }

    # what is the result
    my $What = join(
        ', ',
        @{ $Self->{CustomerCompanyMap}->{CustomerCompanyListFields} }
    );

    # add valid option if required
    my $SQL;
    if ($Valid) {
        $SQL
            .= "$Self->{CustomerCompanyValid} IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )";
    }

    # where
    if ( $Param{Search} ) {

        my @Parts = split /\+/, $Param{Search}, 6;
        for my $Part (@Parts) {
            $Part = $Self->{SearchPrefix} . $Part . $Self->{SearchSuffix};
            $Part =~ s/\*/%/g;
            $Part =~ s/%%/%/g;

            if ( defined $SQL ) {
                $SQL .= " AND ";
            }

            my $CustomerCompanySearchFields
                = $Self->{CustomerCompanyMap}->{CustomerCompanySearchFields};

            if ( $CustomerCompanySearchFields && ref $CustomerCompanySearchFields eq 'ARRAY' ) {

                my @SQLParts;
                my $QuotedPart = $Self->{DBObject}->Quote($Part);
                for my $Field ( @{$CustomerCompanySearchFields} ) {
                    if ( $Self->{CaseSensitive} ) {
                        push @SQLParts, "LOWER($Field) LIKE LOWER('$QuotedPart')";
                    }
                    else {
                        push @SQLParts, "$Field LIKE '$QuotedPart'";
                    }
                }
                if (@SQLParts) {
                    $SQL .= join( ' OR ', @SQLParts );
                }
            }
        }
    }
    $SQL = $Self->_ConvertTo($SQL);

    # sql
    my $CompleteSQL
        = "SELECT $Self->{CustomerCompanyKey}, $What FROM $Self->{CustomerCompanyTable}";
    $CompleteSQL .= $SQL ? " WHERE $SQL" : '';

    # ask database
    $Self->{DBObject}->Prepare(
        SQL   => $CompleteSQL,
        Limit => 50000,
    );

    # fetch the result
    my %List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        my $CustomerCompanyID = shift @Row;
        $List{$CustomerCompanyID} = join( ' ', map { $Self->_ConvertFrom($_) } @Row );
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $CacheType,
            Key   => $CacheKey,
            Value => \%List,
            TTL   => $Self->{CacheTTL},
        );
    }

    return %List;
}

sub CustomerCompanyGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{CustomerID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need CustomerID!' );
        return;
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Data = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => "CustomerCompanyGet::$Param{CustomerID}",
        );
        return %{$Data} if ref $Data eq 'HASH';
    }

    # build select
    my @Fields;
    my %FieldsMap;
    for my $Entry ( @{ $Self->{CustomerCompanyMap}->{Map} } ) {
        push @Fields, $Entry->[2];
        $FieldsMap{ $Entry->[2] } = $Entry->[0];
    }
    my $SQL = 'SELECT ' . join( ', ', @Fields );

    if ( !$Self->{ForeignDB} ) {
        $SQL .= ", change_time, create_time";
    }

    # this seems to be legacy, if Name is passed it should take precedence over CustomerID
    my $CustomerID = $Param{Name} || $Param{CustomerID};

    $SQL .= " FROM $Self->{CustomerCompanyTable} WHERE ";
    my $CustomerIDQuoted = $Self->{DBObject}->Quote($CustomerID);
    if ( $Self->{CaseSensitive} ) {
        $SQL .= "LOWER($Self->{CustomerCompanyKey}) = LOWER( ? )";
    }
    else {
        $SQL .= "$Self->{CustomerCompanyKey} = ?";
    }
    $SQL = $Self->_ConvertTo($SQL);

    # get initial data
    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => [ \$CustomerID ]
    );

    # fetch the result
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        my $MapCounter = 0;

        for my $Field (@Fields) {
            $Data{ $FieldsMap{$Field} } = $Self->_ConvertFrom( $Row[$MapCounter] );
            $MapCounter++;
        }

        $Data{ChangeTime} = $Row[$MapCounter];
        $MapCounter++;
        $Data{CreateTime} = $Row[$MapCounter];
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => "CustomerCompanyGet::$Param{CustomerID}",
            Value => \%Data,
            TTL   => $Self->{CacheTTL},
        );
    }

    # return data
    return (%Data);
}

sub CustomerCompanyAdd {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => 'CustomerCompany backend is read only!' );
        return;
    }

    # build insert
    my $SQL = "INSERT INTO $Self->{CustomerCompanyTable} (";

    my $FieldInserted;
    for my $Entry ( @{ $Self->{CustomerCompanyMap}->{Map} } ) {
        $SQL .= ', ' if ($FieldInserted);
        $SQL .= " $Entry->[2] ";
        $FieldInserted = 1;
    }

    if ( !$Self->{ForeignDB} ) {
        $SQL .= ', ' if ($FieldInserted);
        $SQL .= 'create_time, create_by, change_time, change_by';
    }
    $SQL .= ") VALUES (";

    my $ValueInserted;
    for my $Entry ( @{ $Self->{CustomerCompanyMap}->{Map} } ) {

        $SQL .= ', ' if ($ValueInserted);

        if ( $Entry->[5] =~ /^int$/i ) {
            $SQL .= " " . $Self->{DBObject}->Quote( $Param{ $Entry->[0] } );
        }
        else {
            $SQL .= " '" . $Self->{DBObject}->Quote( $Param{ $Entry->[0] } ) . "'";
        }

        $ValueInserted = 1;
    }

    if ( !$Self->{ForeignDB} ) {
        $SQL .= ', ' if ($ValueInserted);
        $SQL .= "current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID}";
    }
    $SQL .= ")";

    $SQL = $Self->_ConvertTo($SQL);
    return if !$Self->{DBObject}->Do( SQL => $SQL );

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'info',
        Message =>
            "CustomerCompany: '$Param{CustomerCompanyName}/$Param{CustomerID}' created successfully ($Param{UserID})!",
    );

    $Self->_CustomerCompanyCacheClear( CustomerID => $Param{CustomerID} );

    return $Param{CustomerID};
}

sub CustomerCompanyUpdate {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Customer backend is read only!' );
        return;
    }

    # check needed stuff
    for my $Entry ( @{ $Self->{CustomerCompanyMap}->{Map} } ) {
        if ( !$Param{ $Entry->[0] } && $Entry->[4] && $Entry->[0] ne 'UserPassword' ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Entry->[0]!" );
            return;
        }
    }

    # update db
    my $SQL = "UPDATE $Self->{CustomerCompanyTable} SET ";
    my $FieldInserted;

    for my $Entry ( @{ $Self->{CustomerCompanyMap}->{Map} } ) {

        $SQL .= ', ' if $FieldInserted;
        if ( $Entry->[5] =~ /^int$/i ) {
            $SQL .= " $Entry->[2] = " . $Self->{DBObject}->Quote( $Param{ $Entry->[0] } );
        }
        elsif ( $Entry->[0] !~ /^UserPassword$/i ) {
            $SQL .= " $Entry->[2] = '" . $Self->{DBObject}->Quote( $Param{ $Entry->[0] } ) . "'";
        }
        $FieldInserted = 1;
    }

    if ( !$Self->{ForeignDB} ) {
        $SQL .= ", change_time = current_timestamp, change_by = $Param{UserID} ";
    }

    my $CustomerCompanyIDQuoted = $Self->{DBObject}->Quote( $Param{CustomerCompanyID} );
    if ( $Self->{CaseSensitive} ) {
        $SQL .= " WHERE LOWER($Self->{CustomerCompanyKey}) = LOWER('$CustomerCompanyIDQuoted')";
    }
    else {
        $SQL .= " WHERE $Self->{CustomerCompanyKey} = '$CustomerCompanyIDQuoted'";
    }
    $SQL = $Self->_ConvertTo($SQL);

    return if !$Self->{DBObject}->Do( SQL => $SQL );

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'info',
        Message =>
            "CustomerCompany: '$Param{CustomerCompanyName}/$Param{CustomerID}' updated successfully ($Param{UserID})!",
    );

    $Self->_CustomerCompanyCacheClear( CustomerID => $Param{CustomerID} );
    if ( $Param{CustomerCompanyID} ne $Param{CustomerID} ) {
        $Self->_CustomerCompanyCacheClear( CustomerID => $Param{CustomerCompanyID} );
    }

    return 1;
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

sub _CustomerCompanyCacheClear {
    my ( $Self, %Param ) = @_;

    return if !$Self->{CacheObject};

    if ( !$Param{CustomerID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need CustomerID!' );
        return;
    }

    $Self->{CacheObject}->Delete(
        Type => $Self->{CacheType},
        Key  => "CustomerComapnyGet::$Param{CustomerID}",
    );

    # delete all search cache entries
    $Self->{CacheObject}->CleanUp(
        Type => $Self->{CacheType} . '_CustomerCompanyList',
    );

    for my $Function (qw(CustomerCompanyList)) {
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
