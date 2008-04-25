# --
# Kernel/System/User.pm - some user functions
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: User.pm,v 1.80 2008-04-25 10:57:45 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::User;

use strict;
use warnings;

use Kernel::System::CheckItem;
use Kernel::System::Valid;
use Kernel::System::Encode;
use Crypt::PasswdMD5 qw(unix_md5_crypt);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.80 $) [1];

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
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::User;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        MainObject   => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        MainObject   => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $UserObject = Kernel::System::User->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject TimeObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # get user table
    $Self->{UserTable}       = $Self->{ConfigObject}->Get('DatabaseUserTable')       || 'user';
    $Self->{UserTableUserID} = $Self->{ConfigObject}->Get('DatabaseUserTableUserID') || 'id';
    $Self->{UserTableUserPW} = $Self->{ConfigObject}->Get('DatabaseUserTableUserPW') || 'pw';
    $Self->{UserTableUser}   = $Self->{ConfigObject}->Get('DatabaseUserTableUser')   || 'login';

    # create needed object
    $Self->{ValidObject}     = Kernel::System::Valid->new(%Param);
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new(%Param);
    $Self->{EncodeObject}    = Kernel::System::Encode->new(%Param);

    # load generator preferences module
    my $GeneratorModule = $Self->{ConfigObject}->Get('User::PreferencesModule')
        || 'Kernel::System::User::Preferences::DB';
    if ( $Self->{MainObject}->Require($GeneratorModule) ) {
        $Self->{PreferencesObject} = $GeneratorModule->new(%Param);
    }

    return $Self;
}

=item GetUserData()

get user data (UserLogin, UserFirstname, UserLastname, UserEmail, ...)

    my %User = $UserObject->GetUserData(
        UserID => 123,
        Cached => 1, # not required -> 0|1 (default 0)
    );

    or

    my %User = $UserObject->GetUserData(
        User   => 'franz',
        Cached => 1, # not required -> 0|1 (default 0)
        Valid  => 1, # not required -> 0|1 (default 0)
                     # returns only data if user is valid
    );

=cut

sub GetUserData {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{User} && !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need User or UserID!" );
        return;
    }

    # check if result is cached
    if ( $Param{Cached} ) {
        if ( $Param{User} && $Self->{ 'GetUserData::User::' . $Param{User} } ) {
            return %{ $Self->{ 'GetUserData::User::' . $Param{User} } };
        }
        elsif ( $Param{UserID} && $Self->{ 'GetUserData::UserID::' . $Param{UserID} } ) {
            return %{ $Self->{ 'GetUserData::UserID::' . $Param{UserID} } };
        }
    }

    # get initial data
    my @Bind;
    my $SQL = "SELECT $Self->{UserTableUserID}, $Self->{UserTableUser}, "
        . " salutation, first_name, last_name, $Self->{UserTableUserPW}, valid_id "
        . " FROM $Self->{UserTable} WHERE ";
    if ( $Param{User} ) {
        my $User = lc $Param{User};
        $SQL .= " LOWER($Self->{UserTableUser}) = ?";
        push ( @Bind, \$User );
    }
    else {
        $SQL .= " $Self->{UserTableUserID} = ?";
        push ( @Bind, \$Param{UserID} );
    }
    return if ! $Self->{DBObject}->Prepare( SQL => $SQL, Bind => \@Bind );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{UserID}         = $Row[0];
        $Data{UserLogin}      = $Row[1];
        $Data{UserSalutation} = $Row[2];
        $Data{UserFirstname}  = $Row[3];
        $Data{UserLastname}   = $Row[4];
        $Data{UserPw}         = $Row[5];
        $Data{ValidID}        = $Row[6];
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
            return;
        }
    }

    # get preferences
    my %Preferences = $Self->GetPreferences( UserID => $Data{UserID} );

    # check compat stuff
    if ( !$Preferences{UserEmail} ) {
        $Preferences{UserEmail} = $Data{UserLogin};
    }

    # merge hash
    %Data = ( %Data, %Preferences );

    # cache user result
    if ( $Param{User} ) {
        $Self->{ 'GetUserData::User::' . $Param{User} } = \%Data;
    }
    elsif ( $Param{UserID} ) {
        $Self->{ 'GetUserData::UserID::' . $Param{UserID} } = \%Data;
    }

    # return data
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

    # check password
    if ( !$Param{UserPw} ) {
        $Param{UserPw} = $Self->GenerateRandomPassword();
    }

    # sql
    return if ! $Self->{DBObject}->Do(
        SQL => "INSERT INTO $Self->{UserTable} "
            . "(salutation, first_name, last_name, "
            . " $Self->{UserTableUser}, $Self->{UserTableUserPW}, "
            . " valid_id, create_time, create_by, change_time, change_by)"
            . " VALUES "
            . " (?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)",
        Bind => [
            \$Param{UserSalutation}, \$Param{UserFirstname}, \$Param{UserLastname},
            \$Param{UserLogin}, \$Param{UserPw}, \$Param{ValidID},
            \$Param{ChangeUserID}, \$Param{ChangeUserID},
        ],
    );

    # get new user id
    my $UserLogin = lc $Param{UserLogin};
    return if ! $Self->{DBObject}->Prepare(
        SQL  => "SELECT $Self->{UserTableUserID} FROM $Self->{UserTable} "
            . " WHERE LOWER($Self->{UserTableUser}) = ?",
        Bind => [ \$UserLogin ],
    );
    my $UserID = '';
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $UserID = $Row[0];
    }

    # check if user exists
    if ( !$UserID ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Unable to create User: '$Param{UserLogin}' ($Param{ChangeUserID})!",
        );
        return;
    }

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message => "User: '$Param{UserLogin}' ID: '$UserID' created successfully ($Param{ChangeUserID})!",
    );

    # set password
    $Self->SetPassword( UserLogin => $Param{UserLogin}, PW => $Param{UserPw} );

    # set email address
    $Self->SetPreferences( UserID => $UserID, Key => 'UserEmail', Value => $Param{UserEmail} );
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
    for (qw(UserID UserFirstname UserLastname UserLogin ValidID UserID ChangeUserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
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
    my %UserData = $Self->GetUserData( UserID => $Param{UserID} );

    # update db
    return if ! $Self->{DBObject}->Do(
        SQL => "UPDATE $Self->{UserTable} SET salutation = ?, first_name = ?, last_name = ?, "
            . " $Self->{UserTableUser} = ?, valid_id = ?, "
            . " change_time = current_timestamp, change_by = ? "
            . " WHERE $Self->{UserTableUserID} = ?",
        Bind => [
            \$Param{UserSalutation}, \$Param{UserFirstname}, \$Param{UserLastname},
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
            Key          => \@Fields,
            Value        => $Param{Search},
        ). ' ';
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
        return ();
    }
    elsif ( $Param{UserLogin} ) {
        $Param{UserLogin} =~ s/\*/%/g;
        $SQL .= " LOWER($Self->{UserTableUser}) LIKE LOWER('"
            . $Self->{DBObject}->Quote( $Param{UserLogin}, 'Like' ) . "')";
    }

    # add valid option
    if ($Valid) {
        $SQL .= "AND valid_id IN (".join(', ', $Self->{ValidObject}->ValidIDsGet() ).")";
    }

    # get data
    return if ! $Self->{DBObject}->Prepare(
        SQL => $SQL,
        Limit => $Self->{UserSearchListLimit} || $Param{Limit},
    );
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
    my $Pw = $Param{PW} || '';

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need UserLogin!" );
        return;
    }

    # get old user data
    my %User = $Self->GetUserData( User => $Param{UserLogin} );
    if ( !$User{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "No such User!" );
        return;
    }
    my $CryptedPw = '';

    # get crypt type
    my $CryptType = $Self->{ConfigObject}->Get('AuthModule::DB::CryptType') || '';

    # crypt plain (no crypt at all)
    if ( $CryptType eq 'plain' ) {
        $CryptedPw = $Pw;
    }

    # crypt with unix crypt
    elsif ( $CryptType eq 'crypt' ) {

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
                Message => 'The crypt() of your mod_perl(2) is not working correctly! Update mod_perl!',
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

    # crypt with md5
    else {

        # encode output, needed by unix_md5_crypt() only non utf8 signs
        $Self->{EncodeObject}->EncodeOutput( \$Pw );
        $Self->{EncodeObject}->EncodeOutput( \$Param{UserLogin} );

        $CryptedPw = unix_md5_crypt( $Pw, $Param{UserLogin} );
    }

    # md5 sum of pw, needed for password history
    my $MD5Pw = $Self->{MainObject}->MD5sum(
        String => \$Pw,
    );
    $Self->SetPreferences( UserID => $User{UserID}, Key => 'UserLastPw', Value => $MD5Pw );

    # update db
    my $UserLogin = lc $Param{UserLogin};
    return if ! $Self->{DBObject}->Do(
        SQL => "UPDATE $Self->{UserTable} SET $Self->{UserTableUserPW} = ? "
            . " WHERE LOWER($Self->{UserTableUser}) = ?",
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
        UserLogin => 1,
    );

=cut

sub UserLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserLogin} && !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need UserLogin or UserID!" );
        return;
    }
    if ( $Param{UserLogin} ) {

        # check cache
        if ( $Self->{ 'UserLookup::ID::' . $Param{UserLogin} } ) {
            return $Self->{ 'UserLookup::ID::' . $Param{UserLogin} };
        }

        # build sql query
        my $UserLogin = lc $Param{UserLogin};
        return if ! $Self->{DBObject}->Prepare(
            SQL => "SELECT $Self->{UserTableUserID} FROM $Self->{UserTable} "
                . " WHERE LOWER($Self->{UserTableUser}) = ?",
            Bind => [ \$UserLogin ],
        );
        my $ID;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $ID = $Row[0];
        }
        if ($ID) {

            # cache request
            $Self->{ 'UserLookup::ID::' . $Param{UserLogin} } = $ID;
            return $ID;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No UserID found for '$Param{UserLogin}'!",
            );
            return;
        }
    }
    else {

        # check cache
        if ( $Self->{ 'UserLookup::Login::' . $Param{UserID} } ) {
            return $Self->{ 'UserLookup::Login::' . $Param{UserID} };
        }

        # build sql query
        return if ! $Self->{DBObject}->Prepare(
            SQL => "SELECT $Self->{UserTableUser} FROM $Self->{UserTable} "
                . " WHERE $Self->{UserTableUserID} = ?",
            Bind => [ \$Param{UserID} ],
        );
        my $Login;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Login = $Row[0];
        }
        if ($Login) {

            # cache request
            $Self->{ 'UserLookup::Login::' . $Param{UserID} } = $Login;
            return $Login;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No UserLogin found for '$Param{UserID}'!",
            );
            return;
        }
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
    if (%User) {
        return "$User{UserFirstname} $User{UserLastname}";
    }
    else {
        return;
    }
}

=item UserList()

return a hash with all users

    my %List = $UserObject->UserList(
        Type => 'Short', # Short|Long
        Valid => 1, # not required
    );

=cut

sub UserList {
    my ( $Self, %Param ) = @_;

    my $Valid = $Param{Valid} || 0;
    my $Type  = $Param{Type}  || 'Short';
    if ( $Type eq 'Short' ) {
        $Param{What} = "$Self->{ConfigObject}->{DatabaseUserTableUserID}, "
            . " $Self->{ConfigObject}->{DatabaseUserTableUser}";
    }
    else {
        $Param{What} = "$Self->{ConfigObject}->{DatabaseUserTableUserID}, "
            . " last_name, first_name, "
            . " $Self->{ConfigObject}->{DatabaseUserTableUser}";
    }
    my %Users = $Self->{DBObject}->GetTableData(
        What  => $Param{What},
        Table => $Self->{ConfigObject}->{DatabaseUserTable},
        Clamp => 1,
        Valid => $Valid,
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

    # The list of characters that can appear in a randomly generated password.
    # Note that users can put any character into a password they choose themselves.
    my @PwChars
        = ( 0 .. 9, 'A' .. 'Z', 'a' .. 'z', '-', '_', '!', '@', '#', '$', '%', '^', '&', '*' );

    # The number of characters in the list.
    my $PwCharsLen = scalar @PwChars;

    # Generate the password.
    my $Password = '';
    for ( my $i = 0; $i < $Size; $i++ ) {
        $Password .= $PwChars[ rand($PwCharsLen) ];
    }

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
    my $Self = shift;
    return $Self->{PreferencesObject}->SetPreferences(@_);
}

=item GetPreferences()

get user preferences

    my %Preferences = $UserObject->GetPreferences(
        UserID => 123,
    );

=cut

sub GetPreferences {
    my $Self = shift;
    return $Self->{PreferencesObject}->GetPreferences(@_);
}

=item SearchPreferences()

search in user preferences

    my %UserList = $UserObject->SearchPreferences(
        Key   => 'UserEmail',
        Value => 'email@example.com',
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

    # The list of characters that can appear in a randomly generated token.
    my @Chars = ( 0 .. 9, 'A' .. 'Z', 'a' .. 'z' );

    # The number of characters in the list.
    my $CharsLen = scalar @Chars;

    # Generate the token.
    my $Token = 'A';
    for ( my $i = 0; $i < 14; $i++ ) {
        $Token .= $Chars[ rand($CharsLen) ];
    }

    # save token in preferences
    $Self->SetPreferences(
        Key    => 'UserToken',
        Value  => $Token,
        UserID => $Param{UserID},
    );

    # Return the Token.
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
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Token and UserID!" );
        return;
    }

    # get preferences token
    my %Preferences = $Self->GetPreferences(
        UserID => $Param{UserID},
    );

    # check requested vs. stored token
    if ( $Preferences{UserToken} && $Preferences{UserToken} eq $Param{Token}) {

        # reset password token
        $Self->SetPreferences(
            Key => 'UserToken',
            Value => '',
            UserID => $Param{UserID},
        );

        # return true if token is valid
        return 1;
    }
    else {

        # return false if token is invalid
        return;
    }
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.80 $ $Date: 2008-04-25 10:57:45 $

=cut
