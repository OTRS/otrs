# --
# Kernel/System/User.pm - some user functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::User;

use strict;
use warnings;

use Crypt::PasswdMD5 qw(unix_md5_crypt);
use Digest::SHA;

use Kernel::System::CacheInternal;
use Kernel::System::CheckItem;
use Kernel::System::Valid;

=head1 NAME

Kernel::System::User - user lib

=head1 SYNOPSIS

All user functions. E. g. to add and updated user and other functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::User;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $UserObject = Kernel::System::User->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject TimeObject MainObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # get user table
    $Self->{UserTable}       = $Self->{ConfigObject}->Get('DatabaseUserTable')       || 'user';
    $Self->{UserTableUserID} = $Self->{ConfigObject}->Get('DatabaseUserTableUserID') || 'id';
    $Self->{UserTableUserPW} = $Self->{ConfigObject}->Get('DatabaseUserTableUserPW') || 'pw';
    $Self->{UserTableUser}   = $Self->{ConfigObject}->Get('DatabaseUserTableUser')   || 'login';

    # create needed object
    $Self->{ValidObject}     = Kernel::System::Valid->new( %{$Self} );
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new( %{$Self} );

    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'User',
        TTL  => 60 * 60 * 3,
    );

    # set lower if database is case sensitive
    $Self->{Lower} = '';
    if ( $Self->{DBObject}->GetDatabaseFunction('CaseSensitive') ) {
        $Self->{Lower} = 'LOWER';
    }

    # load generator preferences module
    my $GeneratorModule = $Self->{ConfigObject}->Get('User::PreferencesModule')
        || 'Kernel::System::User::Preferences::DB';
    if ( $Self->{MainObject}->Require($GeneratorModule) ) {
        $Self->{PreferencesObject} = $GeneratorModule->new( %{$Self} );
    }

    return $Self;
}

=item GetUserData()

get user data (UserLogin, UserFirstname, UserLastname, UserEmail, ...)

    my %User = $UserObject->GetUserData(
        UserID => 123,
    );

    or

    my %User = $UserObject->GetUserData(
        User          => 'franz',
        Valid         => 1,       # not required -> 0|1 (default 0)
                                  # returns only data if user is valid
        NoOutOfOffice => 1,       # not required -> 0|1 (default 0)
                                  # returns data without out of office infos
    );

=cut

sub GetUserData {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{User} && !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need User or UserID!' );
        return;
    }

    # get configuration for the full name order
    my $FirstnameLastNameOrder = $Self->{ConfigObject}->Get('FirstnameLastnameOrder') || 0;

    # check if result is cached
    if ( $Param{Valid} ) {
        $Param{Valid} = 1;
    }
    else {
        $Param{Valid} = 0;
    }
    if ( $Param{NoOutOfOffice} ) {
        $Param{NoOutOfOffice} = 1;
    }
    else {
        $Param{NoOutOfOffice} = 0;
    }

    my $CacheKey;
    if ( $Param{User} ) {
        $CacheKey
            = 'GetUserData::User::'
            . $Param{User} . '::'
            . $Param{Valid} . '::'
            . $FirstnameLastNameOrder . '::'
            . $Param{NoOutOfOffice};
    }
    else {
        $CacheKey
            = 'GetUserData::UserID::'
            . $Param{UserID} . '::'
            . $Param{Valid} . '::'
            . $FirstnameLastNameOrder . '::'
            . $Param{NoOutOfOffice};
    }

    # check cache
    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    return %{$Cache} if $Cache;

    # get initial data
    my @Bind;
    my $SQL = "SELECT $Self->{UserTableUserID}, $Self->{UserTableUser}, "
        . " title, first_name, last_name, $Self->{UserTableUserPW}, valid_id, "
        . " create_time, change_time FROM $Self->{UserTable} WHERE ";

    if ( $Param{User} ) {
        my $User = lc $Param{User};
        $SQL .= " $Self->{Lower}($Self->{UserTableUser}) = ?";
        push @Bind, \$User;
    }
    else {
        $SQL .= " $Self->{UserTableUserID} = ?";
        push @Bind, \$Param{UserID};
    }

    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => 1,
    );

    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{UserID}        = $Row[0];
        $Data{UserLogin}     = $Row[1];
        $Data{UserTitle}     = $Row[2];
        $Data{UserFirstname} = $Row[3];
        $Data{UserLastname}  = $Row[4];
        $Data{UserPw}        = $Row[5];
        $Data{ValidID}       = $Row[6];
        $Data{CreateTime}    = $Row[7];
        $Data{ChangeTime}    = $Row[8];
    }

    # check data
    if ( !$Data{UserID} ) {
        if ( $Param{User} ) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Panic! No UserData for user: '$Param{User}'!!!",
            );
            return;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Panic! No UserData for user id: '$Param{UserID}'!!!",
            );
            return;
        }
    }

    # check valid, return if there is locked for valid users
    if ( $Param{Valid} ) {

        my $Hit = 0;

        for ( $Self->{ValidObject}->ValidIDsGet() ) {
            if ( $_ eq $Data{ValidID} ) {
                $Hit = 1;
            }
        }

        if ( !$Hit ) {

            # set cache
            $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => {} );
            return;
        }
    }

    # generate the full name and save it in the hash
    my $UserFullname;
    if ( $FirstnameLastNameOrder eq '0' ) {
        $UserFullname = $Data{UserFirstname} . ' '
            . $Data{UserLastname};
    }
    elsif ( $FirstnameLastNameOrder eq '1' ) {
        $UserFullname = $Data{UserLastname} . ', '
            . $Data{UserFirstname};
    }
    elsif ( $FirstnameLastNameOrder eq '2' ) {
        $UserFullname = $Data{UserFirstname} . ' '
            . $Data{UserLastname} . ' ('
            . $Data{UserLogin} . ')';
    }
    elsif ( $FirstnameLastNameOrder eq '3' ) {
        $UserFullname = $Data{UserLastname} . ', '
            . $Data{UserFirstname} . ' ('
            . $Data{UserLogin} . ')';
    }
    elsif ( $FirstnameLastNameOrder eq '4' ) {
        $UserFullname = '(' . $Data{UserLogin}
            . ') ' . $Data{UserFirstname}
            . ' ' . $Data{UserLastname};
    }
    elsif ( $FirstnameLastNameOrder eq '5' ) {
        $UserFullname = '(' . $Data{UserLogin}
            . ') ' . $Data{UserLastname}
            . ', ' . $Data{UserFirstname};
    }

    # save the generated fullname in the hash.
    $Data{UserFullname} = $UserFullname;

    # get preferences
    my %Preferences = $Self->GetPreferences( UserID => $Data{UserID} );

    # add last login timestamp
    if ( $Preferences{UserLastLogin} ) {
        $Preferences{UserLastLoginTimestamp} = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $Preferences{UserLastLogin},
        );
    }

    # check compat stuff
    if ( !$Preferences{UserEmail} ) {
        $Preferences{UserEmail} = $Data{UserLogin};
    }

    # out of office check
    if ( !$Param{NoOutOfOffice} ) {
        if ( $Preferences{OutOfOffice} ) {
            my $Time = $Self->{TimeObject}->SystemTime();
            my $Start
                = "$Preferences{OutOfOfficeStartYear}-$Preferences{OutOfOfficeStartMonth}-$Preferences{OutOfOfficeStartDay} 00:00:00";
            my $TimeStart = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $Start,
            );
            my $End
                = "$Preferences{OutOfOfficeEndYear}-$Preferences{OutOfOfficeEndMonth}-$Preferences{OutOfOfficeEndDay} 23:59:59";
            my $TimeEnd = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $End,
            );
            my $Till = int( ( $TimeEnd - $Time ) / 60 / 60 / 24 );
            my $TillDate
                = "$Preferences{OutOfOfficeEndYear}-$Preferences{OutOfOfficeEndMonth}-$Preferences{OutOfOfficeEndDay}";
            if ( $TimeStart < $Time && $TimeEnd > $Time ) {
                $Preferences{OutOfOfficeMessage} = "*** out of office till $TillDate/$Till d ***";
                $Data{UserLastname} .= ' ' . $Preferences{OutOfOfficeMessage};
            }
        }
    }

    # merge hash
    %Data = ( %Data, %Preferences );

    # add preferences defaults
    my $Config = $Self->{ConfigObject}->Get('PreferencesGroups');
    if ( $Config && ref $Config eq 'HASH' ) {

        for my $Key ( sort keys %{$Config} ) {

            # next if no default data exists
            next if !defined $Config->{$Key}->{DataSelected};

            # check if data is defined
            next if defined $Data{ $Config->{$Key}->{PrefKey} };

            # set default data
            $Data{ $Config->{$Key}->{PrefKey} } = $Config->{$Key}->{DataSelected};
        }
    }

    # set cache
    $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \%Data );

    return %Data;
}

=item UserAdd()

to add new users

    my $UserID = $UserObject->UserAdd(
        UserFirstname => 'Huber',
        UserLastname  => 'Manfred',
        UserLogin     => 'mhuber',
        UserPw        => 'some-pass', # not required
        UserEmail     => 'email@example.com',
        ValidID       => 1,
        ChangeUserID  => 123,
    );

=cut

sub UserAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserFirstname UserLastname UserLogin UserEmail ValidID ChangeUserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
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

    # check password
    if ( !$Param{UserPw} ) {
        $Param{UserPw} = $Self->GenerateRandomPassword();
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => "INSERT INTO $Self->{UserTable} "
            . "(title, first_name, last_name, "
            . " $Self->{UserTableUser}, $Self->{UserTableUserPW}, "
            . " valid_id, create_time, create_by, change_time, change_by)"
            . " VALUES "
            . " (?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)",
        Bind => [
            \$Param{UserTitle}, \$Param{UserFirstname}, \$Param{UserLastname},
            \$Param{UserLogin}, \$Param{UserPw},        \$Param{ValidID},
            \$Param{ChangeUserID}, \$Param{ChangeUserID},
        ],
    );

    # get new user id
    my $UserLogin = lc $Param{UserLogin};
    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT $Self->{UserTableUserID} FROM $Self->{UserTable} "
            . " WHERE $Self->{Lower}($Self->{UserTableUser}) = ?",
        Bind  => [ \$UserLogin ],
        Limit => 1,
    );

    # fetch the result
    my $UserID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $UserID = $Row[0];
    }

    # check if user exists
    if ( !$UserID ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Unable to create User: '$Param{UserLogin}' ($Param{ChangeUserID})!",
        );
        return;
    }

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message =>
            "User: '$Param{UserLogin}' ID: '$UserID' created successfully ($Param{ChangeUserID})!",
    );

    # set password
    $Self->SetPassword( UserLogin => $Param{UserLogin}, PW => $Param{UserPw} );

    # set email address
    $Self->SetPreferences( UserID => $UserID, Key => 'UserEmail', Value => $Param{UserEmail} );

    # delete cache
    $Self->{CacheInternalObject}->CleanUp();
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'Group' );

    return $UserID;
}

=item UserUpdate()

to update users

    $UserObject->UserUpdate(
        UserID        => 4321,
        UserFirstname => 'Huber',
        UserLastname  => 'Manfred',
        UserLogin     => 'mhuber',
        UserPw        => 'some-pass', # not required
        UserEmail     => 'email@example.com',
        ValidID       => 1,
        ChangeUserID  => 123,
    );

=cut

sub UserUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID UserFirstname UserLastname UserLogin ValidID ChangeUserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
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

    # update db
    return if !$Self->{DBObject}->Do(
        SQL => "UPDATE $Self->{UserTable} SET title = ?, first_name = ?, last_name = ?, "
            . " $Self->{UserTableUser} = ?, valid_id = ?, "
            . " change_time = current_timestamp, change_by = ? "
            . " WHERE $Self->{UserTableUserID} = ?",
        Bind => [
            \$Param{UserTitle}, \$Param{UserFirstname}, \$Param{UserLastname},
            \$Param{UserLogin}, \$Param{ValidID}, \$Param{ChangeUserID}, \$Param{UserID},
        ],
    );

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "User: '$Param{UserLogin}' updated successfully ($Param{ChangeUserID})!",
    );

    # check pw
    if ( $Param{UserPw} ) {
        $Self->SetPassword( UserLogin => $Param{UserLogin}, PW => $Param{UserPw} );
    }

    # set email address
    $Self->SetPreferences(
        UserID => $Param{UserID},
        Key    => 'UserEmail',
        Value  => $Param{UserEmail}
    );

    # delete cache
    $Self->{CacheInternalObject}->CleanUp();
    $Self->{CacheInternalObject}->CleanUp( OtherType => 'Group' );

    return 1;
}

=item UserSearch()

to search users

    my %List = $UserObject->UserSearch(
        Search => '*some*', # also 'hans+huber' possible
        Valid  => 1, # not required
    );

    my %List = $UserObject->UserSearch(
        UserLogin => '*some*',
        Limit     => 50,
        Valid     => 1, # not required
    );

    my %List = $UserObject->UserSearch(
        PostMasterSearch => 'email@example.com',
        Valid            => 1, # not required
    );

=cut

sub UserSearch {
    my ( $Self, %Param ) = @_;

    my %Users;
    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;

    # check needed stuff
    if ( !$Param{Search} && !$Param{UserLogin} && !$Param{PostMasterSearch} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Search, UserLogin or PostMasterSearch!',
        );
        return;
    }

    # get like escape string needed for some databases (e.g. oracle)
    my $LikeEscapeString = $Self->{DBObject}->GetDatabaseFunction('LikeEscapeString');

    # build SQL string 1/2
    my $SQL    = "SELECT $Self->{UserTableUserID} ";
    my @Fields = qw(login first_name last_name);
    if (@Fields) {
        for my $Entry (@Fields) {
            $SQL .= ", $Entry";
        }
    }

    # build SQL string 2/2
    $SQL .= " FROM $Self->{UserTable} WHERE ";
    if ( $Param{Search} ) {
        $SQL .= $Self->{DBObject}->QueryCondition(
            Key   => \@Fields,
            Value => $Param{Search},
        ) . ' ';
    }
    elsif ( $Param{PostMasterSearch} ) {

        my %UserID = $Self->SearchPreferences(
            Key   => 'UserEmail',
            Value => $Param{PostMasterSearch},
        );

        for ( sort keys %UserID ) {
            my %User = $Self->GetUserData(
                UserID => $_,
                Valid  => $Param{Valid},
            );
            if (%User) {
                return %UserID;
            }
        }

        return;
    }
    elsif ( $Param{UserLogin} ) {
        $Param{UserLogin} =~ s/\*/%/g;
        $SQL .= " $Self->{Lower}($Self->{UserTableUser}) LIKE $Self->{Lower}('"
            . $Self->{DBObject}->Quote( $Param{UserLogin}, 'Like' ) . "') $LikeEscapeString";
    }

    # add valid option
    if ($Valid) {
        $SQL .= "AND valid_id IN (" . join( ', ', $Self->{ValidObject}->ValidIDsGet() ) . ")";
    }

    # get data
    return if !$Self->{DBObject}->Prepare(
        SQL => $SQL,
        Limit => $Self->{UserSearchListLimit} || $Param{Limit},
    );

    # fetch the result
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        for ( 1 .. 8 ) {
            if ( $Row[$_] ) {
                $Users{ $Row[0] } .= $Row[$_] . ' ';
            }
        }
        $Users{ $Row[0] } =~ s/^(.*)\s(.+?\@.+?\..+?)(\s|)$/"$1" <$2>/;
    }

    return %Users;
}

=item SetPassword()

to set users passwords

    $UserObject->SetPassword(
        UserLogin => 'some-login',
        PW        => 'some-new-password'
    );

=cut

sub SetPassword {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserLogin!' );
        return;
    }

    # get old user data
    my %User = $Self->GetUserData( User => $Param{UserLogin} );
    if ( !$User{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'No such User!' );
        return;
    }

    my $Pw = $Param{PW} || '';
    my $CryptedPw = '';

    # get crypt type
    my $CryptType = $Self->{ConfigObject}->Get('AuthModule::DB::CryptType') || 'sha2';

    # crypt plain (no crypt at all)
    if ( $CryptType eq 'plain' ) {
        $CryptedPw = $Pw;
    }

    # crypt with unix crypt
    elsif ( $CryptType eq 'crypt' ) {

        # encode output, needed by crypt() only non utf8 signs
        $Self->{EncodeObject}->EncodeOutput( \$Pw );
        $Self->{EncodeObject}->EncodeOutput( \$Param{UserLogin} );

        $CryptedPw = crypt( $Pw, $Param{UserLogin} );
    }

    # crypt with md5
    elsif ( $CryptType eq 'md5' || !$CryptType ) {

        # encode output, needed by unix_md5_crypt() only non utf8 signs
        $Self->{EncodeObject}->EncodeOutput( \$Pw );
        $Self->{EncodeObject}->EncodeOutput( \$Param{UserLogin} );

        $CryptedPw = unix_md5_crypt( $Pw, $Param{UserLogin} );
    }

    # crypt with sha1
    elsif ( $CryptType eq 'sha1' ) {

        my $SHAObject = Digest::SHA->new('sha1');

        # encode output, needed by sha1_hex() only non utf8 signs
        $Self->{EncodeObject}->EncodeOutput( \$Pw );

        $SHAObject->add($Pw);
        $CryptedPw = $SHAObject->hexdigest();
    }

    # bcrypt
    elsif ( $CryptType eq 'bcrypt' ) {

        if ( !$Self->{MainObject}->Require('Crypt::Eksblowfish::Bcrypt') ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "User: '$User{UserLogin}' tried to store password with bcrypt but 'Crypt::Eksblowfish::Bcrypt' is not installed!",
            );
            return;
        }

        my $Cost = 9;
        my $Salt = $Self->{MainObject}->GenerateRandomString( Length => 16 );

        # remove UTF8 flag, required by Crypt::Eksblowfish::Bcrypt
        $Self->{EncodeObject}->EncodeOutput( \$Pw );

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

    # crypt with sha256 as fallback
    else {

        my $SHAObject = Digest::SHA->new('sha256');

        # encode output, needed by sha256_hex() only non utf8 signs
        $Self->{EncodeObject}->EncodeOutput( \$Pw );

        $SHAObject->add($Pw);
        $CryptedPw = $SHAObject->hexdigest();
    }

    # update db
    my $UserLogin = lc $Param{UserLogin};
    return if !$Self->{DBObject}->Do(
        SQL => "UPDATE $Self->{UserTable} SET $Self->{UserTableUserPW} = ? "
            . " WHERE $Self->{Lower}($Self->{UserTableUser}) = ?",
        Bind => [ \$CryptedPw, \$UserLogin ],
    );

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "User: '$Param{UserLogin}' changed password successfully!",
    );

    return 1;
}

=item UserLookup()

user login or id lookup

    my $UserLogin = $UserObject->UserLookup(
        UserID => 1,
    );

    my $UserID = $UserObject->UserLookup(
        UserLogin => 'some_user_login',
    );

=cut

sub UserLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserLogin} && !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserLogin or UserID!' );
        return;
    }

    if ( $Param{UserLogin} ) {

        # check cache
        my $CacheKey = 'UserLookup::ID::' . $Param{UserLogin};
        my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
        return $Cache if $Cache;

        # build sql query
        my $UserLogin = lc $Param{UserLogin};

        return if !$Self->{DBObject}->Prepare(
            SQL => "SELECT $Self->{UserTableUserID} FROM $Self->{UserTable} "
                . " WHERE $Self->{Lower}($Self->{UserTableUser}) = ?",
            Bind  => [ \$UserLogin ],
            Limit => 1,
        );

        # fetch the result
        my $ID;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $ID = $Row[0];
        }

        if ( !$ID ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No UserID found for '$Param{UserLogin}'!",
            );
            return;
        }

        # set cache
        $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => $ID );

        return $ID;
    }

    else {

        # check cache
        my $CacheKey = 'UserLookup::Login::' . $Param{UserID};
        my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
        return $Cache if $Cache;

        # build sql query
        return if !$Self->{DBObject}->Prepare(
            SQL => "SELECT $Self->{UserTableUser} FROM $Self->{UserTable} "
                . " WHERE $Self->{UserTableUserID} = ?",
            Bind  => [ \$Param{UserID} ],
            Limit => 1,
        );

        # fetch the result
        my $Login;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Login = $Row[0];
        }

        if ( !$Login ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No UserLogin found for '$Param{UserID}'!",
            );
            return;
        }

        # set cache
        $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => $Login );

        return $Login;
    }
}

=item UserName()

get user name

    my $Name = $UserObject->UserName(
        UserLogin => 'some-login',
    );

    or

    my $Name = $UserObject->UserName(
        UserID => 123,
    );

=cut

sub UserName {
    my ( $Self, %Param ) = @_;

    my %User = $Self->GetUserData(%Param);

    return if !%User;
    return $User{UserFullname};
}

=item UserList()

return a hash with all users

    my %List = $UserObject->UserList(
        Type  => 'Short', # Short|Long, default Short
        Valid => 1,       # not required, default 0
    );

=cut

sub UserList {
    my ( $Self, %Param ) = @_;

    my $Type = $Param{Type} || 'Short';

    # set valid option
    my $Valid = $Param{Valid};
    if ( !defined $Valid || $Valid ) {
        $Valid = 1;
    }
    else {
        $Valid = 0;
    }

    # get configuration for the full name order
    my $FirstnameLastNameOrder = $Self->{ConfigObject}->Get('FirstnameLastnameOrder') || 0;

    # check cache
    my $CacheKey = 'UserList::' . $Type . '::' . $Valid
        . '::' . $FirstnameLastNameOrder;
    my $Cache = $Self->{CacheInternalObject}->Get(
        Key => $CacheKey,
    );
    return %{$Cache} if $Cache;

    my $SelectStr;
    if ( $Type eq 'Short' ) {
        $SelectStr = "$Self->{ConfigObject}->{DatabaseUserTableUserID}, "
            . " $Self->{ConfigObject}->{DatabaseUserTableUser}";
    }
    else {
        $SelectStr = "$Self->{ConfigObject}->{DatabaseUserTableUserID}, "
            . " last_name, first_name, "
            . " $Self->{ConfigObject}->{DatabaseUserTableUser}";
    }

    # sql query
    if ($Valid) {
        return if !$Self->{DBObject}->Prepare(
            SQL =>
                "SELECT $SelectStr FROM $Self->{ConfigObject}->{DatabaseUserTable} WHERE valid_id IN "
                . "( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )",
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL => "SELECT $SelectStr FROM $Self->{ConfigObject}->{DatabaseUserTable}",
        );
    }

    # fetch the result
    my %UsersRaw;
    my %Users;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $UsersRaw{ $Row[0] } = $Row[1];
    }

    if ( $Type eq 'Short' ) {
        %Users = %UsersRaw;
    }
    else {
        for my $CurrentUserID ( sort keys %UsersRaw ) {
            my $UserFullname = $Self->UserName( UserID => $CurrentUserID );
            $Users{$CurrentUserID} = $UserFullname;
        }
    }

    # check vacation option
    for my $UserID ( sort keys %Users ) {
        next if !$UserID;

        my %User = $Self->GetUserData(
            UserID => $UserID,
        );
        if ( $User{OutOfOfficeMessage} ) {
            $Users{$UserID} .= ' ' . $User{OutOfOfficeMessage};
        }
    }

    # set cache
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \%Users,
    );

    return %Users;
}

=item GenerateRandomPassword()

generate a random password

    my $Password = $UserObject->GenerateRandomPassword();

    or

    my $Password = $UserObject->GenerateRandomPassword(
        Size => 16,
    );

=cut

sub GenerateRandomPassword {
    my ( $Self, %Param ) = @_;

    # Generated passwords are eight characters long by default.
    my $Size = $Param{Size} || 8;

    my $Password = $Self->{MainObject}->GenerateRandomString(
        Length => $Size,
    );

    # Return the password.
    return $Password;
}

=item SetPreferences()

set user preferences

    $UserObject->SetPreferences(
        Key    => 'UserComment',
        Value  => 'some comment',
        UserID => 123,
    );

=cut

sub SetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Key UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get current setting
    my %User = $Self->GetUserData(
        UserID        => $Param{UserID},
        NoOutOfOffice => 1,
    );

    # no updated needed
    return 1 if exists $User{ $Param{Key} } && $User{ $Param{Key} } eq $Param{Value};

    # delete cache
    my $Login = $Self->UserLookup( UserID => $Param{UserID} );
    $Self->{CacheInternalObject}->CleanUp();

    # set preferences
    return $Self->{PreferencesObject}->SetPreferences(%Param);
}

=item GetPreferences()

get user preferences

    my %Preferences = $UserObject->GetPreferences(
        UserID => 123,
    );

=cut

sub GetPreferences {
    my ( $Self, %Param ) = @_;

    return $Self->{PreferencesObject}->GetPreferences(%Param);
}

=item SearchPreferences()

search in user preferences

    my %UserList = $UserObject->SearchPreferences(
        Key   => 'UserEmail',
        Value => 'email@example.com',   # optional, limit to a certain value/pattern
    );

=cut

sub SearchPreferences {
    my $Self = shift;

    return $Self->{PreferencesObject}->SearchPreferences(@_);
}

=item TokenGenerate()

generate a random token

    my $Token = $UserObject->TokenGenerate(
        UserID => 123,
    );

=cut

sub TokenGenerate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need UserID!" );
        return;
    }
    my $Token = $Self->{MainObject}->GenerateRandomString(
        Length => 15,
    );

    # save token in preferences
    $Self->SetPreferences(
        Key    => 'UserToken',
        Value  => $Token,
        UserID => $Param{UserID},
    );

    return $Token;
}

=item TokenCheck()

check password token

    my $Valid = $UserObject->TokenCheck(
        Token  => $Token,
        UserID => 123,
    );

=cut

sub TokenCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Token} || !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Token and UserID!' );
        return;
    }

    # get preferences token
    my %Preferences = $Self->GetPreferences(
        UserID => $Param{UserID},
    );

    # check requested vs. stored token
    if ( $Preferences{UserToken} && $Preferences{UserToken} eq $Param{Token} ) {

        # reset password token
        $Self->SetPreferences(
            Key    => 'UserToken',
            Value  => '',
            UserID => $Param{UserID},
        );

        # return true if token is valid
        return 1;
    }

    # return false if token is invalid
    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
